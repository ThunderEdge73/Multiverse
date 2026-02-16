Multiverse.SkillCard({
	key = "strike",
	tp_cost = 5,
	config = { extra = { blind_mult = 0.9 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.blind_mult,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			Multiverse.change_blind_size(function(chips)
				return chips * card.ability.extra.blind_mult
			end)
		end)
	end,
})

Multiverse.SkillCard({
	key = "snowgrave",
	no_save_on_use = true,
	tp_cost = 50,
	config = { extra = { seal = "mul_frozen" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
	end,
	use_skill = function(self, card, paid_amt, x)
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
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return #G.hand.cards > 1
	end,
})

Multiverse.SkillCard({
	key = "jud_slash",
	tp_cost = "X",
	config = { extra = { tp_per_split = 5 } },
	no_save_on_use = true,
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
		Multiverse.start_interaction({
			area = "hand",
			end_interaction = function()
				Multiverse.start_slashes(G.hand.highlighted[1])
				Multiverse.halve_cards(
					G.hand.highlighted[1],
					math.ceil(x / card.ability.extra.tp_per_split),
					true,
					nil,
					true
				)
			end,
			can_end_interaction = function()
				return #G.hand.highlighted == 1
			end,
			display_text = Multiverse.parse_vars(
				localize("k_mul_ubw"),
				{ math.ceil(x / card.ability.extra.tp_per_split) }
			),
		})
		return "destroy"
	end,
	can_use_skill = function(self, card)
		local targets = {}
		if G.hand then
			for _, c in ipairs(G.hand.cards) do
				if Multiverse.can_halve_card(c) and c ~= card then
					targets[#targets + 1] = c
				end
			end
		end
		return #targets > 0
	end,
})

Multiverse.SkillCard({
	key = "sinful_shell",
	tp_cost = "X",
	config = { extra = { tp_per_destroy = 8 } },
	no_save_on_use = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		return {
			vars = {
				Multiverse.get_final_X_value(self, card, true, true),
				card.ability.extra.tp_per_destroy,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "hand",
			end_interaction = function()
				SMODS.destroy_cards(G.hand.highlighted)
			end,
			can_end_interaction = function()
				return #G.hand.highlighted <= math.ceil(x / card.ability.extra.tp_per_destroy)
			end,
			display_text = Multiverse.parse_vars(
				localize("k_mul_sinful_shell"),
				{ math.ceil(x / card.ability.extra.tp_per_destroy) }
			),
		})
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		local targets = {}
		if G.hand then
			for _, c in ipairs(G.hand.cards) do
				if c ~= card then
					targets[#targets + 1] = c
				end
			end
		end
		return #targets > 0
	end,
})

Multiverse.SkillCard({
	key = "objection",
	tp_cost = 30,
	mul_impervious = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_impervious"]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			G.GAME.mul_objection_active = true
			Multiverse.apply_to_playing_cards(function(playing_card)
				SMODS.recalc_debuff(playing_card)
			end)
		end)
	end,
})

Multiverse.SkillCard({
	key = "teio_step",
	tp_cost = 40,
	config = { extra = { affected = 2, retriggers = 1 } },
	no_save_on_use = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		return {
			vars = {
				card.ability.extra.affected,
				card.ability.extra.retriggers,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "hand",
			end_interaction = function()
				Multiverse.apply_to_cards_animation(
					card,
					G.hand.highlighted,
					function(_card)
						_card.ability.perma_repetitions = _card.ability.perma_repetitions
							+ card.ability.extra.retriggers
					end,
					nil,
					function()
						G.hand:unhighlight_all()
					end
				)
			end,
			can_end_interaction = function()
				return #G.hand.highlighted <= card.ability.extra.affected
			end,
			display_text = Multiverse.parse_vars(
				localize("k_mul_teio_step"),
				{ card.ability.extra.affected, card.ability.extra.retriggers }
			),
		})
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return #G.hand.cards > 1
	end,
})

Multiverse.SkillCard({
	key = "rude_buster",
	tp_cost = 25,
	config = { extra = { blind_mult = 0.5, status = "psv_mul_vulnerable" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = blindexpander.Passives[card.ability.extra.status]
		return {
			vars = {
				card.ability.extra.blind_mult,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function ()
			Multiverse.change_blind_size(function (chips)
				return chips * card.ability.extra.blind_mult
			end)
			G.GAME.blind:add_passive(card.ability.extra.status)
		end)
	end,
	can_use_skill = function (self, card)
		return not find_passive(card.ability.extra.status)
	end
})
