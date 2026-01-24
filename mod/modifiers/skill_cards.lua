Multiverse.SkillCard({
	key = "strike",
	tp_cost = 10,
	config = { extra = { blind_div = 2 }},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.blind_div
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function ()
			Multiverse.change_blind_size(function (chips)
				return chips / card.ability.extra.blind_div
			end)
		end)
	end,
})

Multiverse.SkillCard({
	key = "snowgrave",
	tp_cost = 40,
	config = { extra = { seal = "mul_frozen" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
	end,
	use_skill = function(self, card, paid_amt, x)
		G.E_MANAGER:add_event(Event({
			func = function()
				Multiverse.start_interaction({
					area = "hand",
					end_interaction = function()
						Multiverse.apply_to_cards_animation(
							card,
							G.hand.highlighted,
							function(_card)
								_card:set_seal(card.ability.extra.seal)
							end,
							nil,
							function()
								G.hand:unhighlight_all()
							end
						)
					end,
					display_text = localize("k_mul_snowgrave"),
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
					display_text = Multiverse.parse_vars(
						localize("k_mul_ubw"),
						math.ceil(x / card.ability.extra.tp_per_split)
					),
				})
				return true
			end,
		}))
		return "destroy"
	end,
})
