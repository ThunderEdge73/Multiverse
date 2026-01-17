---@type Multiverse.SkillCard
Multiverse.SkillCard = SMODS.Enhancement:extend({
	obj_buffer = {},
	class_prefix = "sk",
	set = "mul_Skill",
	replace_base_card = true,
	no_rank = true,
	no_suit = true,
	atlas = "mul_skill_placeholder",
	required_params = {
		"key",
		"tp_cost",
	},
	can_use_skill = function(self, card)
		return true
	end,
	inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
		SMODS.Enhancement.inject_class(self)
	end,
	use_skill = function(self, card) end,
	--- DO NOT OVERRIDE
	get_final_tp_cost = function(self, card, ui_format)
		if ui_format and card.facing == "back" then
			return "?"
		end
		if self.tp_cost == "X" then
			return ui_format and "X" or G.GAME.mul_TP
		end
		local amt = (self.tp_cost - (card.ability.mul_tp_discount or 0))
		return ui_format and format_ui_value(amt) or amt
	end,
	generate_cost_ui = function(self, card)
		local t = {
			n = G.UIT.ROOT,
			config = {
				minw = 0.6,
				align = "tm",
				colour = darken(G.C.BLACK, 0.2),
				shadow = true,
				r = 0.05,
				padding = 0.05,
				minh = 1,
			},
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						colour = lighten(G.C.BLACK, 0.1),
						r = 0.1,
						minw = 1,
						minh = 0.55,
						emboss = 0.05,
						padding = 0.03,
					},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = {
										{
											suffix = " " .. localize("k_mul_TP"),
											string = self:get_final_tp_cost(card, true),
										},
									},
									colours = { G.C.FILTER },
									shadow = true,
									silent = true,
									bump = true,
									pop_in = 0,
									scale = 0.5,
								}),
							},
							func = "mul_update_tp_cost",
							ref_table = card,
						},
					},
				},
			},
		}
		return UIBox({
			definition = t,
			config = {
				align = "tm",
				offset = { x = 0, y = 0.4 },
				major = card,
				bond = "Weak",
				parent = card,
			},
		})
	end,
	generate_use_ui = function(self, card)
		local t = {
			n = G.UIT.ROOT,
			config = {
				ref_table = card,
				minw = 1.1,
				maxw = 1.3,
				padding = 0.1,
				align = "bm",
				colour = G.C.GREEN,
				shadow = true,
				r = 0.08,
				minh = 0.94,
				func = "mul_can_use_skill",
				one_press = true,
				button = "mul_use_skill",
				hover = true,
			},
			nodes = {
				{ n = G.UIT.T, config = { text = localize("b_use"), colour = G.C.WHITE, scale = 0.5 } },
			},
		}
		return UIBox({
			definition = t,
			config = {
				align = "bm",
				offset = { x = 0, y = -0.3 },
				major = card,
				bond = "Weak",
				parent = card,
			},
		})
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_mul_skill"), G.C.FILTER, nil, 1.2)
	end,
})

G.FUNCS.mul_update_tp_cost = function(e)
	local card = e.config.ref_table
	local center = card.config.center
	e.config.object.string[1].string = center:get_final_tp_cost(card, true)
end

G.FUNCS.mul_can_use_skill = function(e)
	local card = e.config.ref_table
	local center = card.config.center
	local locked = (G.play and #G.play.cards > 0)
		or G.CONTROLLER.locked
		or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
			and not (G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT)

	if
		G.GAME.blind.in_blind
		and #G.hand.highlighted == 1
		and G.hand.highlighted[1] == card
		and G.GAME.mul_TP >= center:get_final_tp_cost(card)
		and not locked
		and not card.debuff
		and center:can_use_skill(card)
	then
		e.config.button = "mul_use_skill"
		e.config.colour = G.C.GREEN
	else
		e.config.button = nil
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
	end
end

G.FUNCS.mul_use_skill = function(e)
	local card = e.config.ref_table
	local center = card.config.center
	local prev_state = G.STATE
	G.TAROT_INTERRUPT = G.STATE
	G.STATE = G.STATES.PLAY_TAROT
	G.CONTROLLER.locks.use = true
	Multiverse.ease_TP(-center:get_final_tp_cost(card))
	draw_card(G.hand, G.play, 1, "up", true, card)
	delay(0.2)
	local res = center:use_skill(card) or "discard"
    delay(0.6)
	if res == "discard" then
		card.ability.discarded = true
		draw_card(G.play, G.discard, 100, "down", false, card)
	elseif res == "retain" then
		draw_card(G.play, G.hand, 100, "down", false, card)
	elseif res == "destroy" then
		SMODS.destroy_cards(card, true)
	else
		--- TODO
	end
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
					return true
				end,
			}))
			return true
		end,
	}))
end

local inject_objects_hook = SMODS.injectObjects
function SMODS.injectObjects(class)
	inject_objects_hook(class)
	if class == SMODS.GameObject then
		Multiverse.SkillCard:inject_class()
	end
end
