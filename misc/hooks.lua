local is_face_hook = Card.is_face
function Card:is_face(from_boss)
	if SMODS.has_enhancement(self, "m_mul_normal") then
		if self.debuff and not from_boss then
			return is_face_hook(self, from_boss)
		end
		return true
	end
	return is_face_hook(self, from_boss)
end

local is_suit_hook = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
	if SMODS.has_enhancement(self, "m_mul_calling_card") then
		if flush_calc then
			if SMODS.has_no_suit(self) then
				return false
			end
			if SMODS.has_any_suit(self) and self:can_calculate() then
				return true
			end
			if SMODS.smeared_check({ base = { suit = "Hearts" } }, suit) then
				return true
			end
			return "Hearts" == suit
		else
			if self.debuff and not bypass_debuff then
				return
			end
			if SMODS.has_no_suit(self) then
				return false
			end
			if SMODS.has_any_suit(self) then
				return true
			end
			if SMODS.smeared_check({ base = { suit = "Hearts" } }, suit) then
				return true
			end
			return "Hearts" == suit
		end
	end
	return is_suit_hook(self, suit, bypass_debuff, flush_calc)
end

local get_id_hook = Card.get_id
function Card:get_id()
	if SMODS.has_enhancement(self, "m_mul_calling_card") then
		return 14
	end
	return get_id_hook(self)
end

local get_nominal_hook = Card.get_nominal
function Card:get_nominal(mod)
	local ret = get_nominal_hook(self, mod)
	local mult = 1
	if self.ability.effect == "Stone Card" or (self.config.center.no_suit and self.config.center.no_rank) then
		mult = -10000
	elseif self.config.center.no_suit then
		mult = 0
	end
	if SMODS.has_enhancement(self, "m_mul_calling_card") then
		ret = ret - self.base.suit_nominal * mult + 0.03 * mult
	end
	return ret
end

local draw_hook = love.draw
function love.draw()
	local ret = draw_hook()
	local width, height = love.graphics.getDimensions()
	local x_factor = width / 1536
	local y_factor = height / 864
	Multiverse.handle_other_drawing(x_factor, y_factor)
	Multiverse.handle_limbo_drawing(x_factor, y_factor)
	Multiverse.handle_undyne_drawing(x_factor, y_factor)
	return ret
end

local update_hook = Game.update
function Game:update(dt)
	local ret = update_hook(self, dt)
	Multiverse.update_animations()
	Multiverse.update_spears()
	Multiverse.update_transmutable_sticker_anim_state()
	Multiverse.update_deck_enchantments()
	Multiverse.update_main_menu()
	return ret
end

local set_sprites_hook = Card.set_sprites
function Card:set_sprites(_center, _front)
	set_sprites_hook(self, _center, _front)
	if self.playing_card and self.ability and Multiverse.is_valid_half(self) then
		if not self.children.mul_hitbox_indicator then
			self.children.mul_hitbox_indicator =
				SMODS.create_sprite(self.T.x, self.T.y, self.T.w, self.T.h, "mul_half_indicator", { x = 0, y = 0 })
			self.children.mul_hitbox_indicator.states.hover = self.states.hover
			self.children.mul_hitbox_indicator.states.click = self.states.click
			self.children.mul_hitbox_indicator.states.drag = self.states.drag
			self.children.mul_hitbox_indicator.states.collide.can = false
			self.children.mul_hitbox_indicator:set_role({ major = self, role_type = "Glued", draw_major = self })
		end
	end
	if Multiverse.can_receive_transmutable(self) then
		if not self.children.transmutable_target then
			self.children.transmutable_target = SMODS.create_sprite(
				self.T.x,
				self.T.y,
				self.T.w,
				self.T.h,
				"mul_transmutable_target",
				{ x = 0, y = 0 }
			)
			self.children.transmutable_target.role.draw_major = self
			self.children.transmutable_target.states.hover.can = false
			self.children.transmutable_target.states.click.can = false
		end
	end
end

local tooltip_hook = create_popup_UIBox_tooltip
function create_popup_UIBox_tooltip(tooltip)
	local ret = tooltip_hook(tooltip)
	if ret and tooltip.colour then
		ret.config.colour = tooltip.colour
	end
	return ret
end

local set_ability_hook = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
	if center == "m_mul_waldo" and G.GAME.waldo_already_created and not G.GAME.waldo_spawn then
		set_ability_hook(self, "c_base", initial, delay_sprites)
		if not Multiverse.all_animations["explosion"].is_active then
			Multiverse.start_animation("explosion")
			play_sound("mul_deltarune_explosion", 1, 0.8)
		end
	else
		set_ability_hook(self, center, initial, delay_sprites)
	end
end

local mousepressed_hook = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
	if Multiverse.very_important_thing then
		return
	end
	mousepressed_hook(x, y, button, istouch, presses)
	if Multiverse.in_limbo == "end" and not Multiverse.has_guessed then
		local clicked = Multiverse.detect_key_click(x, y)
		if clicked then
			Multiverse.has_guessed = true
			Multiverse.in_limbo = nil
			Multiverse.limbo_safe = clicked.is_correct
			if not clicked.is_correct then
				Multiverse.change_blind_size(function(chips)
					return chips * 10
				end)
				Multiverse.start_animation("explosion")
				play_sound("mul_deltarune_explosion", 1, 0.8)
			end
		end
	end
end

local keypressed_hook = love.keypressed
function love.keypressed(key, scancode, is_repeat)
	if Multiverse.very_important_thing then
		return
	end
	keypressed_hook(key, scancode, is_repeat)
	if Multiverse.in_undyne then
		if key == "left" or key == "right" or key == "up" or key == "down" then
			Multiverse.shield_dir = key
		end
	end
end

function Multiverse.cannot_interrupt()
	return Multiverse.in_limbo or Multiverse.in_undyne or Multiverse.very_important_thing
end

local options_hook = G.FUNCS.options
function G.FUNCS.options()
	if Multiverse.cannot_interrupt() then
		return
	end
	options_hook()
end

local info_hook = G.FUNCS.run_info
function G.FUNCS.run_info()
	if Multiverse.cannot_interrupt() then
		return
	end
	info_hook()
end

local deck_info_hook = G.FUNCS.deck_info
function G.FUNCS.deck_info()
	if Multiverse.cannot_interrupt() then
		return
	end
	deck_info_hook()
end

local start_run_hook = Game.start_run
function Game:start_run(args)
	start_run_hook(self, args)
	Multiverse.init_TP()
	Multiverse.init_thaumaturgy()
	Multiverse.init_myth()
	Multiverse.init_blinds()
	Multiverse.init_deck_enchantments()
	G.E_MANAGER:add_event(Event({
		func = function()
			if not G.mul_TP_meter then
				Multiverse.show_TP_meter()
			end
			return true
		end,
	}))
end

local can_sell_hook = Card.can_sell_card
function Card:can_sell_card()
	local ret = can_sell_hook(self)
	if self.ability and type(self.ability.extra) == "table" and self.ability.extra.is_active then
		return false
	end
	return ret
end

local ease_dollars_hook = ease_dollars
function ease_dollars(mod, instant)
	local amt = mod
	if to_big(mod) > to_big(0) then
		amt = amt * G.GAME.mul_money_mult
		if to_big(amt) < to_big(1e15) then
			amt = math.floor(to_number(amt) + 0.5)
		end
	end
	ease_dollars_hook(amt, instant)
end

local hover_hook = Card.hover
function Card:hover()
	if self.config.center.key == "c_mul_polymerization" then
		Multiverse.FUSION_HOVER = true
	end
	hover_hook(self)
end

local stop_hover_hook = Card.stop_hover
function Card:stop_hover()
	stop_hover_hook(self)
	if self.config.center.key == "c_mul_polymerization" then
		Multiverse.FUSION_HOVER = false
	end
end
