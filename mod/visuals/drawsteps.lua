SMODS.DrawStep({
	key = "active_consumable",
	order = 200,
	func = function(card, layer)
		if card.ability and type(card.ability.extra) == "table" and card.ability.extra.is_active then
			Multiverse.check_active_particles(card, true)
			card.children.center:draw_shader("booster", nil, card.ARGS.send_to_shader)
		end
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DrawStep({
	key = "transmutable_target",
	order = 201,
	func = function(card, layer)
		-- We dont want the effect to show if we are not in a run (G.consumeables does not exist outside a run)
		if not G.consumeables then
			return
		end
		-- We do a simple check for whether or not a certain consumable is highlighted here
		local philosophers_stone_highlighted = false
		for _, v in ipairs(G.consumeables.highlighted) do
			if v.config.center_key == "c_mul_philosophers_stone" then
				philosophers_stone_highlighted = true
				break
			end
		end
		-- If the card has a certain sticker and the correct consumable is highlighted,
		-- only then should the sprite be drawn
		-- This check can be changed as needed
		if card.ability and card.ability.mul_transmutable and philosophers_stone_highlighted then
			-- Slowly oscillating the scale of the card
			-- Change the constant factor to increase the overall size of the sprite
			local scale_mod = 0.32 + 0.02 * math.sin(1.8 * G.TIMERS.REAL)
			-- Rotates the sprite
			-- Multiply the rightmost G.TIMERS.REAL term to increase the rate of rotation
			local rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) + G.TIMERS.REAL
			-- Draws the shadow with a dissolve shader
			card.children.transmutable_target:draw_shader(
				"dissolve",
				0,
				nil,
				nil,
				card.children.center, -- Where we should draw the sprite relative to
				scale_mod,
				rotate_mod,
				nil,
				nil,
				nil,
				0.2 -- affects the tilt of the shadow, smaller number means a bigger tilt downwards
			)
			-- Draws the actual sprite
			card.children.transmutable_target:draw_shader(
				"dissolve",
				nil,
				nil,
				nil,
				card.children.center, -- Where we should draw the sprite relative to
				scale_mod,
				rotate_mod
			)
		end
	end,
	conditions = { vortex = false }, -- Do not draw on the main menu intro (not that it ever should)
	-- Will draw regardless of whether or not the card is facing frontwards or backwards
})

SMODS.DrawStep({
	key = "enchantment_shader",
	order = 1,
	func = function(card, layer)
		local enchantment_shader = false
		if G.GAME.mul_deck_enchantments and G.deck then
			for _, enchant in pairs(G.GAME.mul_deck_enchantments) do
				if enchant.level > 0 then
					enchantment_shader = true
					break
				end
			end
		end
		if enchantment_shader and card.area and card.area == G.deck then
			card.children.back:draw_shader("negative", nil, card.ARGS.send_to_shader, true)
			card.children.back:draw_shader("mul_enchantment", nil, card.ARGS.send_to_shader, true)
		end
	end,
	conditions = { vortex = false, facing = "back" },
})

local draw_shadow_hook = Card.should_draw_shadow
function Card:should_draw_shadow(...)
	if Multiverse.is_valid_half(self) then
		return self.facing == "back"
	end
	return draw_shadow_hook(self, ...)
end

local shadow_func = SMODS.DrawSteps["shadow"].func
SMODS.DrawSteps["shadow"].func = function(card, layer)
	shadow_func(card, layer)
	if
		not card.no_shadow
		and card.facing == "front"
		and G.SETTINGS.GRAPHICS.shadows == "On"
		and (
			Multiverse.is_valid_half(card)
			and (
				(card.area and card.area ~= G.discard and card.area.config.type ~= "deck")
				or not card.area
				or card.states.drag.is
			)
		)
	then
		card.shadow_height = 0 * (0.08 + 0.4 * math.sqrt(card.velocity.x ^ 2))
			+ (
				(((card.highlighted and card.area == G.play) or card.states.drag.is) and 0.35)
				or (card.area and card.area.config.type == "title_2") and 0.04
				or 0.1
			)
		if not card.children.mul_hitbox_indicator then
			card.children.mul_hitbox_indicator =
				SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, "mul_half_indicator", { x = 0, y = 0 })
			card.children.mul_hitbox_indicator.states.hover = card.states.hover
			card.children.mul_hitbox_indicator.states.click = card.states.click
			card.children.mul_hitbox_indicator.states.drag = card.states.drag
			card.children.mul_hitbox_indicator.states.collide.can = false
			card.children.mul_hitbox_indicator:set_role({ major = card, role_type = "Glued", draw_major = card })
		end
		if card.ability.mul_half_card == "left" then
			card.children.mul_hitbox_indicator:draw_shader(
				"mul_righthalf",
				card.shadow_height,
				card.ARGS.send_to_shader
			)
			card.children.center:draw_shader("mul_lefthalf", card.shadow_height, card.ARGS.send_to_shader)
		else
			card.children.mul_hitbox_indicator:draw_shader("mul_lefthalf", card.shadow_height, card.ARGS.send_to_shader)
			card.children.center:draw_shader("mul_righthalf", card.shadow_height, card.ARGS.send_to_shader)
		end
	end
end

SMODS.DrawStep({
	key = "half_card_render",
	order = -9,
	func = function(card, layer)
		if Multiverse.is_valid_half(card) then
			if not card.children.mul_hitbox_indicator then
				card.children.mul_hitbox_indicator =
					SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, "mul_half_indicator", { x = 0, y = 0 })
				card.children.mul_hitbox_indicator.states.hover = card.states.hover
				card.children.mul_hitbox_indicator.states.click = card.states.click
				card.children.mul_hitbox_indicator.states.drag = card.states.drag
				card.children.mul_hitbox_indicator.states.collide.can = false
				card.children.mul_hitbox_indicator:set_role({ major = card, role_type = "Glued", draw_major = card })
			end
			if card.ability.mul_half_card == "left" then
				card.children.mul_hitbox_indicator:draw_shader("mul_righthalf", nil, card.ARGS.send_to_shader)
				card.children.center:draw_shader("mul_lefthalf", nil, card.ARGS.send_to_shader)
			else
				card.children.mul_hitbox_indicator:draw_shader("mul_lefthalf", nil, card.ARGS.send_to_shader)
				card.children.center:draw_shader("mul_righthalf", nil, card.ARGS.send_to_shader)
			end
		end
	end,
	conditions = { vortex = false, facing = "front" },
})

Multiverse.TEMP_ENHANCEMENT_SPRITES = {}
SMODS.DrawStep({
	key = "frankenstein_render",
	order = -8,
	func = function(card, layer)
		if card.config.center_key == "m_mul_frankenstein" then
			local key1 = card.ability.extra.enhancement1
			local key2 = card.ability.extra.enhancement2
			if not Multiverse.is_valid_frankenstein(card) then
				key1 = "m_steel"
				key2 = "m_gold"
			end
			local obj1 = G.P_CENTERS[key1]
			local obj2 = G.P_CENTERS[key2]
			if not Multiverse.TEMP_ENHANCEMENT_SPRITES[key1] then
				Multiverse.TEMP_ENHANCEMENT_SPRITES[key1] =
					SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, obj1.atlas or "centers", obj1.pos)
			end
			if not Multiverse.TEMP_ENHANCEMENT_SPRITES[key2] then
				Multiverse.TEMP_ENHANCEMENT_SPRITES[key2] =
					SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, obj2.atlas or "centers", obj2.pos)
			end
			Multiverse.TEMP_ENHANCEMENT_SPRITES[key1].role.draw_major = card
			Multiverse.TEMP_ENHANCEMENT_SPRITES[key2].role.draw_major = card
			Multiverse.TEMP_ENHANCEMENT_SPRITES[key1]:draw_shader(
				"mul_lefthalf",
				nil,
				card.ARGS.send_to_shader,
				nil,
				card.children.center
			)
			Multiverse.TEMP_ENHANCEMENT_SPRITES[key2]:draw_shader(
				"mul_righthalf",
				nil,
				card.ARGS.send_to_shader,
				nil,
				card.children.center
			)
		end
	end,
	conditions = { vortex = false, facing = "front" },
})

SMODS.DrawStep({
	key = "enchanted_book_shader",
	order = 11,
	func = function(card, layer)
		if card.config.center_key == "c_mul_enchanted_book" then
			card.children.center:draw_shader("negative_shine", nil, card.ARGS.send_to_shader)
			card.children.center:draw_shader("mul_enchantment", nil, card.ARGS.send_to_shader)
		end
	end,
	conditions = { vortex = false, facing = "front" },
})

local greyed_draw_hook = SMODS.DrawSteps["greyed"].func
SMODS.DrawSteps["greyed"].func = function(card, layer)
	if card.mul_exhausted_display then
		card.children.center:draw_shader("mul_exhausted", nil, card.ARGS.send_to_shader)
		if card.children.front and (card.ability.delayed or not card:should_hide_front()) then
			card.children.front:draw_shader("mul_exhausted", nil, card.ARGS.send_to_shader)
		end
	else
		greyed_draw_hook(card, layer)
	end
end

local buttons_hook = SMODS.DrawSteps["tags_buttons"].func
SMODS.DrawSteps["tags_buttons"].func = function(card, layer)
	if card.children.mul_skill_cost_ui and card.area == G.hand and (not card.dissolve or card.dissolve == 0) then
		card.children.mul_skill_cost_ui:draw()
	end
	if Multiverse.in_interaction() then
		return
	end
	buttons_hook(card, layer)
	if card.children.mul_skill_use_button and card.highlighted then
		card.children.mul_skill_use_button:draw()
	end
	if card.children.mul_joker_use_button and card.highlighted then
		card.children.mul_joker_use_button:draw()
	end
end
