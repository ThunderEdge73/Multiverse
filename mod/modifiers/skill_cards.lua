Multiverse.SkillCard({
	key = "strike",
	tp_cost = 5,
	config = { extra = { xblindsize = 0.9 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xblindsize,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		delay(0.4)
		SMODS.calculate_effect({
			xblindsize = card.ability.extra.xblindsize,
			colour = G.C.PURPLE,
		}, card)
		delay(0.4)
	end,
})

Multiverse.SkillCard({
	key = "snowgrave",
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
			select_limit = math.ceil(x / card.ability.extra.tp_per_destroy),
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
			select_limit = card.ability.extra.affected,
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
	tp_cost = 15,
	config = { extra = { xblindsize = 0.7, status = "psv_mul_vulnerable", amt = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = blindexpander.Passives[card.ability.extra.status]
		return {
			vars = {
				card.ability.extra.xblindsize,
				card.ability.extra.amt,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		delay(0.4)
		SMODS.calculate_effect({
			xblindsize = card.ability.extra.xblindsize,
			colour = G.C.PURPLE,
			func = function()
				Multiverse.modify_passive_stacks(card.ability.extra.status, card.ability.extra.amt)
			end,
		}, card)
		delay(0.4)
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
			select_limit = card.ability.extra.affected,
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
	config = { extra = { status = "psv_mul_burning", amt = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = blindexpander.Passives[card.ability.extra.status]
		return {
			vars = {
				card.ability.extra.amt,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			Multiverse.modify_passive_stacks(card.ability.extra.status, card.ability.extra.amt)
		end)
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
							G.E_MANAGER:add_event(Event({
								func = function()
									G.STATE = G.STATES.DRAW_TO_HAND
									G.E_MANAGER:add_event(Event({
										trigger = "immediate",
										func = function()
											G.STATE_COMPLETE = false
											return true
										end,
									}))
									return true
								end,
							}))
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
						local copied_card = SMODS.copy_card(card_to_copy, { area = G.consumeables })
						copied_card:set_edition("e_negative", true)
						return true
					end,
				}))
			end,
			select_limit = 1,
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

Multiverse.SkillCard({
	key = "atomize",
	tp_cost = 10,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ethereal"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhausts"]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			Multiverse.exhaust_cards(G.hand.cards)
		end)
	end,
	can_use_skill = function(self, card)
		return #G.hand.cards > 0
	end,
	ethereal = true,
})

Multiverse.SkillCard({
	key = "dredge",
	tp_cost = 10,
	ethereal = true,
	config = { extra = { returned = 3 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ethereal"]
		return {
			vars = {
				card.ability.extra.returned,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "discard",
			end_interaction = function()
				local cards = Multiverse.get_discard_view_selected()
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						local count = #cards
						for i = 1, count do
							draw_card(
								G.discard,
								G.hand,
								i * 100 / count,
								"up",
								nil,
								cards[i],
								0.005,
								i % 2 == 0,
								nil,
								math.max((21 - i) / 20, 0.7)
							)
						end
						return true
					end,
				}))
			end,
			select_limit = card.ability.extra.returned,
			display_text = Multiverse.parse_vars(localize("k_mul_dredge"), { card.ability.extra.returned }),
		}, card)
	end,
	can_use_skill = function(self, card)
		return #G.discard.cards > 0
	end,
})

Multiverse.SkillCard({
	key = "light_burns_sky",
	tp_cost = 70,
	config = { extra = { xmult = 0.5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
		return {
			vars = {
				card.ability.extra.xmult,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.apply_to_cards_animation(card, G.hand.cards, function(_card)
			local first = _card == G.hand.cards[1]
			_card:set_edition("e_polychrome", nil, not first)
			_card.ability.perma_x_mult = _card.ability.perma_x_mult + card.ability.extra.xmult
		end)
	end,
	can_use_skill = function(self, card)
		return #G.discard.cards > 0
	end,
})

Multiverse.SkillCard({
	key = "pocket_aces",
	tp_cost = 20,
	mul_impulse = true,
	mul_impervious = true,
	config = { extra = { cards = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_impulse"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_impervious"]
		return {
			vars = {
				card.ability.extra.cards,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			local cards = Multiverse.get_unique_pseudorandom_elements(
				Multiverse.filter(G.deck.cards, function(item)
					return item:get_id() == 14
				end),
				card.ability.extra.cards,
				"mul_pocket_aces"
			)
			local count = #cards
			for i = 1, count do
				draw_card(
					G.deck,
					G.hand,
					i * 100 / count,
					"up",
					nil,
					cards[i],
					0.005,
					i % 2 == 0,
					nil,
					math.max((21 - i) / 20, 0.7)
				)
			end
		end)
	end,
	can_use_skill = function(self, card)
		return #Multiverse.filter(G.deck.cards, function(item)
			return item:get_id() == 14
		end) > 0
	end,
})

Multiverse.SkillCard({
	key = "pot_of_greed",
	tp_cost = 5,
	config = { extra = { cards = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		return {
			vars = {
				card.ability.extra.cards,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.draw_cards(card.ability.extra.cards)
		end)
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return #G.deck.cards >= card.ability.extra.cards
	end,
})

Multiverse.SkillCard({
	key = "prepared",
	tp_cost = 5,
	config = { extra = { cards = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.cards,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.draw_cards(card.ability.extra.cards)
		end)
		Multiverse.start_interaction({
			select_limit = card.ability.extra.cards,
			area = "hand",
			can_end_interaction = function()
				return #G.hand.highlighted == math.min(#G.hand.cards, card.ability.extra.cards)
			end,
			display_text = Multiverse.parse_vars(localize("k_mul_prepared"), { card.ability.extra.cards }),
			end_interaction = function()
				G.FUNCS.discard_cards_from_highlighted(nil, true)
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.3,
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								G.STATE = G.STATES.DRAW_TO_HAND
								G.E_MANAGER:add_event(Event({
									trigger = "immediate",
									func = function()
										G.STATE_COMPLETE = false
										return true
									end,
								}))
								return true
							end,
						}))
						return true
					end,
				}))
			end,
		})
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return #G.deck.cards >= card.ability.extra.cards
	end,
})

Multiverse.SkillCard({
	key = "supplements",
	tp_cost = 15,
	config = { extra = { affected = 2, chips = 30 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.affected,
				card.ability.extra.chips,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "discard",
			end_interaction = function()
				local cards = Multiverse.get_discard_view_selected()
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						for _, c in ipairs(cards) do
							c.ability.perma_bonus = (c.ability.perma_bonus or 0) + card.ability.extra.chips
						end
						return true
					end,
				}))
			end,
			select_limit = card.ability.extra.affected,
			display_text = Multiverse.parse_vars(
				localize("k_mul_dredge"),
				{ card.ability.extra.affected, card.ability.extra.chips }
			),
		}, card)
	end,
	can_use_skill = function(self, card)
		return #G.discard.cards > 0
	end,
})
