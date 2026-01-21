Multiverse.SkillCard({
	key = "snowgrave",
	tp_cost = 40,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
	end,
	use_skill = function(self, card, paid_amt, x)
		G.E_MANAGER:add_event(Event({
			func = function()
				Multiverse.start_interaction({
					area = "hand",
					end_interaction = function()
						SMODS.destroy_cards(G.hand.highlighted)
					end,
					display_text = "Select any number of cards to destroy",
				})
				return true
			end,
		}))
		return "exhaust"
	end,
})

Multiverse.SkillCard({
	key = "ubw",
	tp_cost = "X",
	config = { extra = { tp_per_split = 5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ultimate"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_half"]
		return {
			vars = {
				Multiverse.get_final_X_value(self, card, true, true),
				card.ability.extra.tp_per_split,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		G.E_MANAGER:add_event(Event({
			func = function()
				Multiverse.start_interaction({
					area = "hand",
					end_interaction = function()
						Multiverse.halve_cards(
							G.hand.highlighted[1],
							math.ceil(x / card.ability.extra.tp_per_split),
							true
						)
					end,
					can_end_interaction = function()
						return #G.hand.highlighted == 1
					end,
					display_text = "Select 1 card to split into "
					.. math.ceil(x / card.ability.extra.tp_per_split)
						.. " Half Cards",
				})
				return true
			end,
		}))
		return "destroy"
	end,
})
