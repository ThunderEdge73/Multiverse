local is_face_hook = Card.is_face
function Card:is_face(from_boss, ...)
	if SMODS.has_enhancement(self, "m_mul_normal") then
		if self.debuff and not from_boss then
			return is_face_hook(self, from_boss, ...)
		end
		return true
	end
	return is_face_hook(self, from_boss, ...)
end

local get_id_hook = Card.get_id
function Card:get_id(...)
	if SMODS.has_enhancement(self, "m_mul_calling_card") then
		return 14
	end
	return get_id_hook(self, ...)
end

local draw_hook = love.draw
function love.draw()
	local ret = draw_hook()
	local width, height = love.graphics.getDimensions()
	local x_factor = width / 1536
	local y_factor = height / 864
	Multiverse.handle_other_drawing()
	Multiverse.handle_limbo_drawing(x_factor, y_factor)
	Multiverse.handle_undyne_drawing(x_factor, y_factor)
	return ret
end

local update_hook = Game.update
function Game:update(dt, ...)
	local ret = update_hook(self, dt, ...)
	Multiverse.update_drawables()
	Multiverse.update_spears()
	Multiverse.update_deck_enchantments()
	Multiverse.update_main_menu()
	return ret
end

local set_sprites_hook = Card.set_sprites
function Card:set_sprites(_center, _front, ...)
	local ret = set_sprites_hook(self, _center, _front, ...)
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
			self.children.transmutable_target =
				SMODS.create_sprite(self.T.x, self.T.y, self.T.w, self.T.h, "mul_transmutable_target", { x = 0, y = 0 })
			self.children.transmutable_target.role.draw_major = self
			self.children.transmutable_target.states.hover.can = false
			self.children.transmutable_target.states.click.can = false
		end
	end
	return ret
end

local tooltip_hook = create_popup_UIBox_tooltip
function create_popup_UIBox_tooltip(tooltip, ...)
	local ret = tooltip_hook(tooltip, ...)
	if ret and tooltip.colour then
		ret.config.colour = tooltip.colour
	end
	return ret
end

Multiverse.art_credits_visuals = {
	vertices = {
		{ 0, 0, 0, 0, unpack(darken(Multiverse.C.PRIMARY1, 0.1)) },
		{ 1, 0, 1, 0, unpack(darken(Multiverse.C.PRIMARY2, 0.1)) },
		{ 1, 1, 1, 1, unpack(darken(Multiverse.C.PRIMARY2, 0.1)) },
		{ 0, 1, 0, 1, unpack(darken(Multiverse.C.PRIMARY1, 0.1)) },
	},
}
Multiverse.art_credits_visuals.mesh = love.graphics.newMesh(Multiverse.art_credits_visuals.vertices)

local h_popup_hook = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card, ...)
	local ret = h_popup_hook(card, ...)
	local center = (card.config.center or {})
	if center.mul_art_credit or (center.original_mod == Multiverse and center.set ~= "Edition") then
		table.insert(ret.nodes[1].nodes, {
			n = G.UIT.R,
			config = { colour = G.C.CLEAR, padding = 0.1, align = "cm", w = 0 },
			nodes = {
				{
					n = G.UIT.R,
					config = {
						padding = 0.1,
						mul_custom_draw_func = function(self)
							local t = self.VT or self.T
							local offset = 0.1
							local border = 0.05
							local verts = {
								-border * G.TILESIZE,
								-border * G.TILESIZE,
								(t.w + offset + border) * G.TILESIZE,
								-border * G.TILESIZE,
								(t.w + border) * G.TILESIZE,
								(t.h + border) * G.TILESIZE,
								(-offset - border) * G.TILESIZE,
								(t.h + border) * G.TILESIZE,
							}
							local verts_bg = {
								(t.w + offset + border) * G.TILESIZE,
								-border * G.TILESIZE,
								(t.w + offset + border) * G.TILESIZE,
								border * 2.25 * G.TILESIZE,
								(t.w + border) * G.TILESIZE,
								(t.h + border * 2.25) * G.TILESIZE,
								(-offset - border) * G.TILESIZE,
								(t.h + border * 2.25) * G.TILESIZE,
								(-offset - border) * G.TILESIZE,
								(t.h + border) * G.TILESIZE,
								(t.w + border) * G.TILESIZE,
								(t.h + border) * G.TILESIZE,
							}
							love.graphics.setColor(darken(G.C.JOKER_GREY, 0.3))
							love.graphics.polygon("fill", verts_bg)
							love.graphics.setColor(lighten(G.C.JOKER_GREY, 0.5))
							love.graphics.polygon("fill", verts)

							love.graphics.setColor(1, 1, 1, 1)
							Multiverse.art_credits_visuals.mesh:setVertexAttribute(2, 1, (t.w + offset) * G.TILESIZE, 0)
							Multiverse.art_credits_visuals.mesh:setVertexAttribute(
								3,
								1,
								t.w * G.TILESIZE,
								t.h * G.TILESIZE
							)
							Multiverse.art_credits_visuals.mesh:setVertexAttribute(
								4,
								1,
								-offset * G.TILESIZE,
								t.h * G.TILESIZE
							)
							love.graphics.draw(Multiverse.art_credits_visuals.mesh)
						end,
						align = "cm",
						minw = 2,
					},
					nodes = {
						{
							n = G.UIT.T,
							config = {
								scale = 0.3,
								text = Multiverse.parse_vars(
									localize("k_mul_art_credit"),
									{ card.config.center.mul_art_credit or "ThunderEdge" }
								),
								colour = G.C.UI.TEXT_LIGHT,
							},
						},
					},
				},
			},
		})
		local old = ret.nodes[1].nodes[1]
		ret.nodes[1].nodes[1] = {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				old,
			},
		}
	end
	return ret
end

local set_ability_hook = Card.set_ability
function Card:set_ability(center, initial, delay_sprites, ...)
	local c = center
	if center == "m_mul_waldo" and not Multiverse._CREATING_WALDO then
		c = self.config.center_key
		G.E_MANAGER:add_event(Event({
			func = function()
				Multiverse.explode({ target = self, x_scale = 3, y_scale = 3 })
				return true
			end,
		}))
	end
	return set_ability_hook(self, c, initial, delay_sprites, ...)
end

local copy_card_hook = copy_card
function copy_card(other, new_card, card_scale, playing_card, strip_edition, ...)
	local ret = copy_card_hook(other, new_card, card_scale, playing_card, strip_edition, ...)
	if playing_card and ret.config.center_key == "m_mul_waldo" then
		G.E_MANAGER:add_event(Event({
			func = function()
				ret:set_ability("c_base")
				Multiverse.explode({ target = ret, x_scale = 3, y_scale = 3 })
				return true
			end,
		}))
	end
	return ret
end

local mousepressed_hook = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
	if Multiverse.very_important_thing then
		return
	end
	local ret = mousepressed_hook(x, y, button, istouch, presses)
	if Multiverse.in_limbo == "end" and not Multiverse.has_guessed then
		local clicked = Multiverse.detect_key_click(x, y)
		if clicked then
			Multiverse.has_guessed = true
			Multiverse.in_limbo = nil
			Multiverse.limbo_safe = clicked.is_correct
			if not clicked.is_correct then
				SMODS.calculate_effect({
					xblindsize = 3,
				}, G.GAME.blind)
				G.GAME.failed_limbo = true
				Multiverse.explode()
			end
		end
	end
	return ret
end

local keypressed_hook = love.keypressed
function love.keypressed(key, scancode, is_repeat)
	if Multiverse.very_important_thing then
		return
	end
	local ret = keypressed_hook(key, scancode, is_repeat)
	if Multiverse.in_undyne then
		if key == "left" or key == "right" or key == "up" or key == "down" then
			Multiverse.shield_dir = key
		end
	end
	return ret
end

local options_hook = G.FUNCS.options
function G.FUNCS.options(...)
	if Multiverse.cannot_interrupt() then
		return
	end
	return options_hook(...)
end

local info_hook = G.FUNCS.run_info
function G.FUNCS.run_info(...)
	if Multiverse.cannot_interrupt() then
		return
	end
	return info_hook(...)
end

local deck_info_hook = G.FUNCS.deck_info
function G.FUNCS.deck_info(...)
	if Multiverse.cannot_interrupt() then
		return
	end
	return deck_info_hook(...)
end

local start_run_hook = Game.start_run
function Game:start_run(args, ...)
	local ret = start_run_hook(self, args, ...)
	Multiverse.init_TP()
	Multiverse.init_thaumaturgy()
	Multiverse.init_myth()
	Multiverse.init_blinds()
	Multiverse.init_deck_enchantments()
	Multiverse.init_skills()
	G.E_MANAGER:add_event(Event({
		func = function()
			Multiverse.show_TP_meter()
			return true
		end,
	}))
	local blind_ref = G.GAME.blind
	G.GAME.blind = setmetatable({}, {
		__newindex = function(_, k, v)
			if not (k == "chips" and (blind_ref.config.blind.debuff or {}).mul_immutable and blind_ref[k] > v) then
				blind_ref[k] = v
			end
		end,
		__index = function(_, k)
			return blind_ref[k]
		end,
	})
	return ret
end

local disable_blind_hook = Blind.disable
function Blind:disable(...)
	local res = {}
	SMODS.calculate_context({ mul_prevent_disable = true, blind = self }, res)
	local prevent_disable = false
	for _, eff in pairs(res) do
		for _, tab in pairs(eff) do
			local is_already_prevented = prevent_disable
			if tab.prevent_disable then
				prevent_disable = true
				if type(tab.prevent_disable) == "function" then
					tab.prevent_disable(is_already_prevented)
				end
			end
		end
	end
	if not prevent_disable then
		return disable_blind_hook(self, ...)
	end
end

local ease_dollars_hook = ease_dollars
function ease_dollars(mod, instant, ...)
	local amt = mod
	if mod > 0 and G.GAME.mul_money_mult ~= 1 then
		amt = amt * G.GAME.mul_money_mult
		amt = math.floor(amt)
	end
	return ease_dollars_hook(amt, instant, ...)
end

local hover_hook = Card.hover
function Card:hover(...)
	if self.config.center_key == "c_mul_polymerization" then
		Multiverse.FUSION_HOVER = true
	end
	hover_hook(self, ...)
end

local stop_hover_hook = Card.stop_hover
function Card:stop_hover(...)
	local ret = stop_hover_hook(self, ...)
	if self.config.center_key == "c_mul_polymerization" then
		Multiverse.FUSION_HOVER = false
	end
	return ret
end

local card_click_hook = Card.click
function Card:click(...)
	card_click_hook(self, ...)
	if self.playing_card and self.highlighted then
		SMODS.calculate_context({ mul_highlighted = true, other_card = self })
	end
end

local highlight_hook = Card.highlight
function Card:highlight(is_highlighted, ...)
	local ret = highlight_hook(self, is_highlighted, ...)
	local obj = self.config.center
	if self.children.mul_joker_use_button then
		self.children.mul_joker_use_button:remove()
		self.children.mul_joker_use_button = nil
	end
	if self.children.mul_skill_use_button then
		self.children.mul_skill_use_button:remove()
		self.children.mul_skill_use_button = nil
	end
	if
		self.area == G.jokers
		and is_highlighted
		and obj.highlight_ui
		and type(obj.highlight_ui) == "function"
		and self.ability.set == "Joker"
	then
		---@type UIBox
		self.children.mul_joker_use_button = obj:highlight_ui(self)
	end
	if
		self.area == G.hand
		and is_highlighted
		and obj.generate_use_ui
		and type(obj.generate_use_ui) == "function"
		and self.ability.set == "mul_Skill"
	then
		self.children.mul_skill_use_button = obj:generate_use_ui(self)
	end
	return ret
end

local card_update_hook = Card.update
function Card:update(dt, ...)
	local ret = card_update_hook(self, dt, ...)
	if self.ability.set == "mul_Skill" then
		if not self.children.mul_skill_cost_ui then
			self.children.mul_skill_cost_ui = self.config.center:generate_cost_ui(self)
		end
	elseif self.children.mul_skill_cost_ui then
		self.children.mul_skill_cost_ui:remove()
		self.children.mul_skill_cost_ui = nil
	end
	return ret
end

local align_h_popup_hook = Card.align_h_popup
function Card:align_h_popup(...)
	local ret = align_h_popup_hook(self, ...)
	if ret.type == "tm" and self.children.mul_skill_cost_ui then
		ret.offset.y = ret.offset.y - 0.6
	end
	return ret
end

local sort_hook = CardArea.sort
function CardArea:sort(method, ...)
	sort_hook(self, method, ...)
	Multiverse.handle_pins(self.cards)
end

local exit_overlay_menu_hook = G.FUNCS.exit_overlay_menu
function G.FUNCS.exit_overlay_menu()
	exit_overlay_menu_hook()
	Multiverse.DETAILED_ENCHANTMENT_VIEW = nil
end

local is_playing_card_hook = SMODS.is_playing_card
function SMODS.is_playing_card(card, ...)
	local set = (card.ability or {}).set or ((card.config or {}).center or {}).set
	return is_playing_card_hook(card, ...) or set == "mul_Skill"
end

local localize_bonuses_hook = SMODS.localize_perma_bonuses
function SMODS.localize_perma_bonuses(specific_vars, desc_nodes, ...)
	localize_bonuses_hook(specific_vars, desc_nodes, ...)
	if specific_vars and specific_vars.mul_perma_priority then
		localize({
			type = "other",
			key = "mul_perma_priority",
			nodes = desc_nodes,
			vars = { SMODS.signed(specific_vars.mul_perma_priority) },
		})
	end
	if specific_vars and specific_vars.mul_temp_priority then
		localize({
			type = "other",
			key = "mul_temp_priority",
			nodes = desc_nodes,
			vars = { SMODS.signed(specific_vars.mul_temp_priority) },
		})
	end
end

local draw_card_hook = draw_card
function draw_card(from, to, ...)
	if G.GAME.blind and G.GAME.blind.in_blind and from == G.deck then
		Multiverse.sort_deck_by_priority()
	end
	draw_card_hook(from, to, ...)
end
