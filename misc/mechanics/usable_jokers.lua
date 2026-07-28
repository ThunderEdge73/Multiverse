---@type Multiverse.UsableJoker
Multiverse.UsableJoker = SMODS.Joker:extend({
	can_use = function(self, card)
		return true
	end,
	use = function(self, card) end,
	ability_atlas = "mul_ability_placeholder",
	ability_pos = { x = 0, y = 0 },
	highlight_ui = function(self, card)
		return UIBox({
			definition = Multiverse.joker_use_UI_def(card),
			config = { align = "cl", offset = { x = 0.3, y = 0 }, parent = card, major = card, bond = "Strong" },
		})
	end,
})

function Card:mul_can_use_generic(any_state, skip_check)
	if
		not skip_check
		and ((G.play and #G.play.cards > 0) or G.CONTROLLER.locked or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0))
	then
		return false
	end
	if
		G.STATE ~= G.STATES.HAND_PLAYED
			and G.STATE ~= G.STATES.DRAW_TO_HAND
			and G.STATE ~= G.STATES.PLAY_TAROT
			and not Multiverse.in_interaction()
		or any_state
	then
		return true
	end
end

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
		if not card.debuff and card:mul_can_use_generic() and obj:can_use(card) then
			local prev_state = G.STATE
			G.TAROT_INTERRUPT = G.STATE
			G.STATE = G.STATES.PLAY_TAROT
			G.CONTROLLER.locks.use = true
			if G.booster_pack and not G.booster_pack.alignment.offset.py then
				G.booster_pack.alignment.offset.py = G.booster_pack.alignment.offset.y
				G.booster_pack.alignment.offset.y = G.ROOM.T.y + 29
			end
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
			G.jokers:remove_from_highlighted(card)
			delay(0.2)
			card:juice_up(0.3, 0.3)
			obj:use(card)
			delay(0.6)
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
							if G.booster_pack then
								G.booster_pack.alignment.offset.y = G.booster_pack.alignment.offset.py
								G.booster_pack.alignment.offset.py = nil
							end
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
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.1,
						func = function()
							save_run()
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
	local center = card.config.center
	if card:mul_can_use_generic() and not card.debuff and center:can_use(card) then
		e.config.colour = G.C.GREEN
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
	end
end
