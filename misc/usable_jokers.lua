---@type Multiverse.UsableJoker
Multiverse.UsableJoker = SMODS.Joker:extend({
	can_use_ability = function(self, card)
		return true
	end,
	use_ability = function(self, card) end,
	ability_atlas = "mul_ability_placeholder",
	ability_pos = { x = 0, y = 0 },
	highlight_ui = function(self, card)
		return UIBox({
			definition = Multiverse.joker_use_UI_def(card),
			config = { align = "cl", offset = { x = 0.3, y = 0 }, parent = card, major = card, bond = "Strong" },
		})
	end,
})

---@param card Card
Multiverse.joker_use_UI_def = function(card)
	local obj = card.config.center
	local ability_sprite = Sprite(0, 0, 1.2, 1.2, G.ASSET_ATLAS[obj.ability_atlas], obj.ability_pos)
	ability_sprite:define_draw_steps({ {
		shader = "dissolve",
	} })
	ability_sprite.tilt_var = { mx = 0, my = 0, dx = 0, dy = 0, amt = 0 }
	ability_sprite.states.collide.can = true
	function ability_sprite:hover()
		self:juice_up(0.1, 0.1)
		Node.hover(self)
	end
	function ability_sprite:stop_hover()
		Node.stop_hover(self)
	end
	function ability_sprite:click()
		Node.click(self)
		local locked = (G.play and #G.play.cards > 0)
			or G.CONTROLLER.locked
			or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
				and not (G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT)
		if obj:can_use_ability(card) and not locked and not card.debuff then
			local prev_state = G.STATE
			G.TAROT_INTERRUPT = G.STATE
			G.STATE = (G.STATE == G.STATES.TAROT_PACK and G.STATES.TAROT_PACK)
				or (G.STATE == G.STATES.PLANET_PACK and G.STATES.PLANET_PACK)
				or (G.STATE == G.STATES.SPECTRAL_PACK and G.STATES.SPECTRAL_PACK)
				or (G.STATE == G.STATES.STANDARD_PACK and G.STATES.STANDARD_PACK)
				or (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and G.STATES.SMODS_BOOSTER_OPENED)
				or (G.STATE == G.STATES.BUFFOON_PACK and G.STATES.BUFFOON_PACK)
				or G.STATES.PLAY_TAROT
			G.CONTROLLER.locks.use = true
			if G.shop and not G.shop.alignment.offset.py then
				G.shop.alignment.offset.py = G.shop.alignment.offset.y
				G.shop.alignment.offset.y = G.ROOM.T.y + 29
			end
			if G.blind_select and not G.blind_select.alignment.offset.py then
				G.blind_select.alignment.offset.py = G.blind_select.alignment.offset.y
				G.blind_select.alignment.offset.y = G.ROOM.T.y + 39
			end
			if G.round_eval and not G.round_eval.alignment.offset.py then
				G.round_eval.alignment.offset.py = G.round_eval.alignment.offset.y
				G.round_eval.alignment.offset.y = G.ROOM.T.y + 29
			end
			card:highlight(false)
			obj:use_ability(card)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.1,
						func = function()
							G.STATE = prev_state
							G.TAROT_INTERRUPT = nil
							G.CONTROLLER.locks.use = false
							if G.shop then
								G.shop.alignment.offset.y = G.shop.alignment.offset.py
								G.shop.alignment.offset.py = nil
							end
							if G.blind_select then
								G.blind_select.alignment.offset.y = G.blind_select.alignment.offset.py
								G.blind_select.alignment.offset.py = nil
							end
							if G.round_eval then
								G.round_eval.alignment.offset.y = G.round_eval.alignment.offset.py
								G.round_eval.alignment.offset.py = nil
							end
							return true
						end,
					}))
					return true
				end,
			}))
		end
	end
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR, align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = {
					r = 0.08,
					align = "cl",
					padding = 0.1,
					hover = true,
					shadow = true,
					colour = G.C.UI.BACKGROUND_INACTIVE,
					minw = 1.63,
					func = "mul_can_use_joker",
					ref_table = card,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("k_mul_activate"),
									scale = 0.3,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("k_mul_ability"),
									scale = 0.3,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = ability_sprite,
									align = "cm",
								},
							},
						},
					},
				},
			},
		},
	}
end

function G.FUNCS.mul_can_use_joker(e)
	local card = e.config.ref_table
	local obj = card.config.center
	local locked = (G.play and #G.play.cards > 0)
		or G.CONTROLLER.locked
		or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
			and not (G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT)
	if obj:can_use_ability(card) and not locked and not card.debuff then
		e.config.colour = G.C.GREEN
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
	end
end
