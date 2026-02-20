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
	key = "embrittlement",
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
		Multiverse.effect_animation(card, function()
			Multiverse.change_blind_size(function(chips)
				return chips * card.ability.extra.blind_mult
			end)
			G.GAME.blind:add_passive(card.ability.extra.status)
		end)
	end,
	can_use_skill = function(self, card)
		return not find_passive(card.ability.extra.status)
	end,
})

Multiverse.SkillCard({
	key = "rum_seventh",
	tp_cost = 100,
	mul_impulse = true,
	config = { extra = { affected = 2, percent = 100 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ultimate"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_impulse"]
		table.insert(info_queue, {
			set = "Other",
			key = "mul_transmutable",
			vars = { G.GAME.mul_thaumaturgy_energy_per_joker or 10 },
		})
		return {
			vars = {
				card.ability.extra.affected,
				card.ability.extra.percent,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "jokers",
			end_interaction = function()
				local c = SMODS.add_card({ set = "mul_can_transmute", key_append = "mul_rum_seventh" })
				Multiverse.increment_transmute_progress(c, nil, card.ability.extra.percent)
				SMODS.destroy_cards(G.jokers.highlighted)
			end,
			can_end_interaction = function()
				local count = 0
				for _, j in ipairs(G.jokers.highlighted) do
					if not SMODS.is_eternal(j, card) then
						count = count + 1
					end
				end
				if count ~= 2 then
					return false
				end
				local same_rarity = G.jokers.highlighted[1].config.center.rarity
					== G.jokers.highlighted[2].config.center.rarity
				return count == 2 and same_rarity
			end,
			display_text = Multiverse.parse_vars(localize("k_mul_rum_seventh"), { card.ability.extra.affected }),
		})
		return "destroy"
	end,
	can_use_skill = function(self, card)
		local rarity_counts = {}
		for _, j in ipairs(G.jokers.cards) do
			if not SMODS.is_eternal(j, card) then
				rarity_counts[j.config.center.rarity] = (rarity_counts[j.config.center.rarity] or 0) + 1
			end
		end
		for _, count in pairs(rarity_counts) do
			if count >= 2 then
				return true
			end
		end
		return false
	end,
})

Multiverse.SkillCard({
	key = "fireball",
	tp_cost = 25,
	config = { extra = { status = "psv_mul_burning" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = blindexpander.Passives["psv_mul_burning"]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			G.GAME.blind:add_passive(card.ability.extra.status)
		end)
	end,
	can_use_skill = function(self, card)
		return not find_passive(card.ability.extra.status)
	end,
})

Multiverse.SkillCard({
	key = "ultra_instinct",
	tp_cost = 0,
	config = { extra = { tp_per_discard = 4 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		return {
			vars = {
				card.ability.extra.tp_per_discard,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "hand",
			end_interaction = function()
				local amt = #G.hand.highlighted * card.ability.extra.tp_per_discard
				if amt > 0 then
					G.FUNCS.discard_cards_from_highlighted(nil, true)
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.3,
						func = function()
							Multiverse.ease_TP(amt)
							return true
						end,
					}))
				end
			end,
			display_text = localize("k_mul_ultra_instinct"),
		})
		return "exhaust"
	end,
})

Multiverse.SkillCard({
	key = "aurafarming",
	tp_cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		return {
			vars = {
				G.GAME.mul_thaumaturgy_energy or 0,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			local amt = G.GAME.mul_thaumaturgy_energy
			Multiverse.ease_thaumaturgy_energy(-amt)
			Multiverse.ease_TP(amt)
		end)
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return G.GAME.mul_thaumaturgy_energy > 0
	end,
})

Multiverse.SkillCard({
	key = "dupe_glitch",
	tp_cost = 15,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_retain"]
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "consumables",
			end_interaction = function()
				G.E_MANAGER:add_event(Event({
					func = function()
						local card_to_copy = G.consumeables.highlighted[1]
						local copied_card = copy_card(card_to_copy)
						copied_card:set_edition("e_negative", true)
						copied_card:add_to_deck()
						G.consumeables:emplace(copied_card)
						return true
					end,
				}))
			end,
			can_end_interaction = function()
				return #G.consumeables.highlighted == 1
			end,
			display_text = localize("k_mul_dupe_glitch"),
		})
		return "retain"
	end,
	can_use_skill = function(self, card)
		return #G.consumeables.cards > 0
	end,
})
