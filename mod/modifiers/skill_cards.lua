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
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
			}, card)
		end, true)
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
	impervious = true,
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
						_card.ability.perma_repetitions = (_card.ability.perma_repetitions or 0)
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
		return #G.hand.cards >= 1
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
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
				func = function()
					Multiverse.modify_passive_stacks(card.ability.extra.status, card.ability.extra.amt)
				end,
			}, card)
		end, true)
	end,
})

Multiverse.SkillCard({
	key = "rum_seventh",
	tp_cost = 100,
	impulse = true,
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
						delay = 0.4,
						func = function()
							ease_mul_tp(amt, true)
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
				(G.GAME.mul_thaumaturgy_energy or 0) + (G.GAME.mul_thaumaturgy_energy_buffer or 0),
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			local amt = G.GAME.mul_thaumaturgy_energy
			ease_mul_thaumaturgy_energy(-amt, true)
			ease_mul_tp(amt, true)
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
							Multiverse.draw_card(
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
		end, function(_card)
			return _card ~= card
		end)
	end,
	can_use_skill = function(self, card)
		return #G.discard.cards > 0
	end,
})

Multiverse.SkillCard({
	key = "pocket_aces",
	tp_cost = 20,
	impulse = true,
	impervious = true,
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
				Multiverse.draw_card(
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
	tp_cost = 0,
	config = { extra = { cards = 2 } },
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
		G.E_MANAGER:add_event(Event({
			func = function()
				G.E_MANAGER:add_event(Event({
					func = function()
						if #G.hand.cards > 0 then
							Multiverse.start_interaction({
								select_limit = card.ability.extra.cards,
								area = "hand",
								can_end_interaction = function()
									return #G.hand.highlighted == math.min(#G.hand.cards, card.ability.extra.cards)
								end,
								display_text = Multiverse.parse_vars(
									localize("k_mul_prepared"),
									{ math.min(#G.hand.cards, card.ability.extra.cards) }
								),
								end_interaction = function()
									G.FUNCS.discard_cards_from_highlighted(nil, true)
								end,
							})
						end
						return true
					end,
				}))
				return true
			end,
		}))
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
				for _, c in ipairs(cards) do
					c.ability.perma_bonus = (c.ability.perma_bonus or 0) + card.ability.extra.chips
				end
			end,
			select_limit = card.ability.extra.affected,
			display_text = Multiverse.parse_vars(
				localize("k_mul_supplements"),
				{ card.ability.extra.affected, card.ability.extra.chips }
			),
		}, card)
	end,
	can_use_skill = function(self, card)
		return #G.discard.cards > 0
	end,
})

Multiverse.SkillCard({
	key = "blue_rose_closer",
	tp_cost = 0,
	ethereal = true,
	config = { extra = { xblindsize = 0.1, hands = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ethereal"]
		return {
			vars = {
				card.ability.extra.hands,
				card.ability.extra.xblindsize,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
			}, card)
		end, true)
	end,
	can_use_skill = function(self, card)
		return G.GAME.current_round.hands_left == card.ability.extra.hands
	end,
})

Multiverse.SkillCard({
	key = "sovereign_blade",
	tp_cost = 20,
	config = { extra = { xblindsize = 0.5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_retain"]
		return {
			vars = {
				card.ability.extra.xblindsize,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
			}, card)
		end, true)
		return "retain"
	end,
})

Multiverse.SkillCard({
	key = "kamehameha",
	tp_cost = 15,
	config = { extra = { xblindsize = 0.9 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xblindsize,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			for _ = 1, (G.GAME.current_round.hands_played + G.GAME.current_round.discards_used) do
				SMODS.calculate_effect({
					xblindsize = card.ability.extra.xblindsize,
					colour = G.C.PURPLE,
				}, card)
			end
		end, true)
	end,
})

Multiverse.SkillCard({
	key = "hollow_technique_purple",
	tp_cost = 25,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.destroy_cards(G.hand.cards)
			ease_mul_tp(-G.GAME.mul_tp, true)
		end)
		return "exhaust"
	end,
})

Multiverse.SkillCard({
	key = "falcon_punch",
	tp_cost = 15,
	config = { extra = { xblindsize = 0.75, status = "psv_mul_dazed" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = blindexpander.Passives[card.ability.extra.status]
		return {
			vars = {
				card.ability.extra.xblindsize,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							Multiverse.modify_passive_stacks(card.ability.extra.status, 1)
							return true
						end,
					}))
				end,
			}, card)
		end, true)
	end,
})

Multiverse.SkillCard({
	key = "360_no_scope",
	tp_cost = 30,
	impulse = true,
	config = { extra = { tp = 40 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_impulse"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		return {
			vars = {
				card.ability.extra.tp,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			ease_mul_tp(card.ability.extra.tp, true)
			SMODS.draw_cards(1)
		end)
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return #G.deck.cards >= 1
	end,
})

Multiverse.SkillCard({
	key = "backflip",
	tp_cost = 15,
	config = { extra = { cards = 2, chips = 10 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.cards,
				card.ability.extra.chips,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			for _ = 1, 2 do
				Multiverse.drawn_card_modify_queue[#Multiverse.drawn_card_modify_queue + 1] = {
					perma_bonus = card.ability.extra.chips,
				}
			end
			SMODS.draw_cards(card.ability.extra.cards)
		end)
	end,
	can_use_skill = function(self, card)
		return #G.deck.cards >= card.ability.extra.cards
	end,
})

Multiverse.SkillCard({
	key = "megidolaon",
	tp_cost = 70,
	config = { extra = { edition = "e_mul_almighty" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ultimate"]
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.apply_to_cards_animation(card, G.hand.cards, function(_card)
			_card:set_edition(card.ability.extra.edition)
		end, function(_card)
			return _card ~= card
		end)
		return "destroy"
	end,
})

Multiverse.SkillCard({
	key = "wish",
	tp_cost = 80,
	impervious = true,
	config = { extra = { dollars = 10 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_impervious"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ultimate"]
		return {
			vars = {
				card.ability.extra.dollars,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			ease_dollars(card.ability.extra.dollars, true)
			SMODS.upgrade_poker_hands({ instant = true })
			SMODS.add_card({ set = "mul_Myth", edition = "e_negative" })
		end)
		return "destroy"
	end,
})

Multiverse.SkillCard({
	key = "invisibility",
	tp_cost = 40,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			local target = pseudorandom_element(
				Multiverse.filter(G.hand.cards, function(item)
					return item ~= card
				end),
				"mul_invisibility"
			)
			SMODS.copy_card(target, { area = G.hand })
		end)
		return "exhaust"
	end,
})

Multiverse.SkillCard({
	key = "icbm",
	tp_cost = 40,
	config = { extra = { xblindsize = 0.4 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xblindsize,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
				func = function()
					local indices = {}
					for i, c in ipairs(G.hand.cards) do
						if c ~= card then
							indices[#indices + 1] = i
						end
					end
					local index = pseudorandom("mul_icbm", 1, #indices)
					local cards = {}
					for _, v in ipairs({ -1, 0, 1 }) do
						if indices[index + v] then
							cards[#cards + 1] = G.hand.cards[indices[index + v]]
						end
					end
					SMODS.destroy_cards(cards)
					G.E_MANAGER:add_event(Event({
						func = function()
							Multiverse.explode({ target = G.hand.cards[indices[index]], x_scale = 3, y_scale = 3 })
							return true
						end,
					}))
				end,
			}, card)
		end, true)
	end,
})

Multiverse.SkillCard({
	key = "calc_gamble",
	tp_cost = 0,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			local old = G.hand.config.highlighted_limit
			G.hand.config.highlighted_limit = math.huge
			for _, c in ipairs(G.hand.cards) do
				if c ~= card then
					G.hand:add_to_highlighted(c, true)
				end
			end
			G.FUNCS.discard_cards_from_highlighted(nil, true)
			G.hand.config.highlighted_limit = old
		end)
	end,
})

Multiverse.SkillCard({
	key = "larceny",
	tp_cost = 20,
	sneaky = true,
	config = { extra = { money = 6 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_sneaky"]
		return {
			vars = {
				card.ability.extra.money,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			ease_dollars(card.ability.extra.money, true)
		end)
	end,
})

Multiverse.SkillCard({
	key = "ray_of_doom",
	tp_cost = "X",
	config = { extra = { mult = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ultimate"]
		return {
			vars = {
				card.ability.extra.mult,
				Multiverse.get_final_X_value(self, card, true),
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		local valid = Multiverse.filter(G.hand.cards, function(item)
			return item ~= card
		end)
		Multiverse.effect_animation(card, function()
			for i = 1, x do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.02,
					func = function()
						local t = pseudorandom_element(valid, "mul_ray_of_doom")
						t:juice_up(0.3, 0.1)
						t.ability.perma_mult = (t.ability.perma_mult or 0) + card.ability.extra.mult
						play_sound("card3")
						return true
					end,
				}))
			end
		end, true)
		return "destroy"
	end,
	can_use_skill = function(self, card)
		return #G.hand.cards > 0
	end,
})

Multiverse.SkillCard({
	key = "bloodletting",
	tp_cost = 0,
	config = { extra = { mult = 2, tp = 20 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.tp,
				card.ability.extra.mult,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			ease_mul_tp(card.ability.extra.tp, true)
			for _, c in ipairs(G.hand.cards) do
				if c ~= card then
					c.ability.perma_mult = (c.ability.perma_mult or 0) - card.ability.extra.mult
				end
			end
		end)
	end,
})

Multiverse.SkillCard({
	key = "eldritch_blast",
	tp_cost = 10,
	ethereal = true,
	config = { extra = { xblindsize = 0.9, thaumaturgy_energy = 5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ethereal"]
		return {
			vars = {
				card.ability.extra.thaumaturgy_energy,
				card.ability.extra.xblindsize,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							ease_mul_thaumaturgy_energy(card.ability.extra.thaumaturgy_energy, true)
							return true
						end,
					}))
				end,
			}, card)
		end, true)
	end,
})

Multiverse.SkillCard({
	key = "haste",
	tp_cost = 50,
	impulse = true,
	config = { extra = { affected = 2, priority = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_impulse"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_priority"]
		return {
			vars = {
				card.ability.extra.affected,
				card.ability.extra.priority,
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
						_card.ability.mul_perma_priority = (_card.ability.mul_perma_priority or 0)
							+ card.ability.extra.priority
					end,
					nil,
					function()
						G.hand:unhighlight_all()
					end
				)
			end,
			select_limit = card.ability.extra.affected,
			display_text = Multiverse.parse_vars(
				localize("k_mul_haste"),
				{ card.ability.extra.affected, card.ability.extra.retriggers }
			),
		})
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return #G.hand.cards >= 1
	end,
})

Multiverse.SkillCard({
	key = "chaos_form",
	tp_cost = 25,
	innate = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_innate"]
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			G.GAME.mul_chaos_form = true
		end)
	end,
})

Multiverse.SkillCard({
	key = "hyper_beam",
	tp_cost = 30,
	config = { extra = { extra_tp_cost = 5, xblindsize = 0.1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xblindsize,
				card.ability.extra.extra_tp_cost,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.calculate_effect({
				xblindsize = card.ability.extra.xblindsize,
				colour = G.C.PURPLE,
				func = function()
					G.GAME.mul_temp_skill_discount = (G.GAME.mul_temp_skill_discount or 0)
						- card.ability.extra.extra_tp_cost
				end,
			}, card)
		end, true)
	end,
})

Multiverse.SkillCard({
	key = "storm_ritual",
	buried = true,
	tp_cost = 10,
	config = { extra = { status = "psv_mul_shocked" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_buried"]
		info_queue[#info_queue + 1] = blindexpander.Passives[card.ability.extra.status]
		return {
			vars = {
				(G.GAME.mul_skill_usage or {}).round or 0,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		local n = G.GAME.mul_skill_usage.round
		Multiverse.effect_animation(card, function()
			Multiverse.modify_passive_stacks(card.ability.extra.status, n)
		end)
	end,
	can_use_skill = function(self, card)
		return G.GAME.mul_skill_usage.round > 0
	end,
})

Multiverse.SkillCard({
	key = "waterbending",
	tp_cost = 15,
	config = { extra = { amt = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		return {
			vars = {
				card.ability.extra.amt,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			SMODS.change_play_limit(card.ability.extra.amt)
			G.GAME.mul_waterbending = (G.GAME.mul_waterbending or 0) + card.ability.extra.amt
		end)
		return "exhaust"
	end,
})

Multiverse.SkillCard({
	key = "vine_growth",
	tp_cost = 15,
	config = { extra = { amt = 2, priority = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_priority"]
		return {
			vars = {
				card.ability.extra.amt,
				card.ability.extra.priority,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			local cards = Multiverse.get_unique_pseudorandom_elements(
				Multiverse.filter(G.deck.cards, function(item)
					return next(SMODS.get_enhancements(item)) ~= nil
				end),
				card.ability.extra.amt,
				"mul_vine_growth"
			)
			for _, c in ipairs(cards) do
				c.ability.mul_temp_priority = (c.ability.mul_temp_priority or 0) + card.ability.extra.priority
			end
		end)
	end,
	can_use_skill = function(self, card)
		return #Multiverse.filter(G.deck.cards, function(item)
			return next(SMODS.get_enhancements(item)) ~= nil
		end) > 0
	end,
})

Multiverse.SkillCard({
	key = "raise_undead",
	tp_cost = 30,
	buried = true,
	config = { extra = { copies = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_buried"]
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_skeletal"]
		return {
			vars = {
				card.ability.extra.copies,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "discard",
			end_interaction = function()
				local c = Multiverse.get_discard_view_selected()[1]
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						for _ = 1, card.ability.extra.copies do
							local t = SMODS.copy_card(c, { area = G.hand })
							t:set_ability("m_mul_skeletal")
						end
						return true
					end,
				}))
			end,
			can_end_interaction = function()
				return #Multiverse.get_discard_view_selected() > 0
			end,
			select_limit = 1,
			display_text = Multiverse.parse_vars(localize("k_mul_raise_undead"), { card.ability.extra.copies }),
		}, card)
	end,
	can_use_skill = function(self, card)
		return #G.discard.cards > 0
	end,
})

Multiverse.SkillCard({
	key = "wind_gale",
	tp_cost = 20,
	config = { extra = { cards = 2 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.cards,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			Multiverse.sort_deck_by_priority()
			local cards = { G.deck.cards[1], G.deck.cards[2] }
			local count = #cards
			for i = 1, count do
				Multiverse.draw_card(
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
		return #G.deck.cards >= card.ability.extra.cards
	end,
})

Multiverse.SkillCard({
	key = "earthen_spikes",
	tp_cost = 10,
	config = { extra = { status = "psv_mul_spiky_terrain", stacks = 10 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = blindexpander.Passives[card.ability.extra.status]
		return {
			vars = {
				card.ability.extra.stacks,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			Multiverse.modify_passive_stacks(card.ability.extra.status, card.ability.extra.stacks)
		end)
	end,
})

Multiverse.SkillCard({
	key = "exorcise_spirit",
	tp_cost = 10,
	config = { extra = { cards = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhausts"]
		return {
			vars = {
				card.ability.extra.cards,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			select_limit = card.ability.extra.cards,
			area = "hand",
			display_text = Multiverse.parse_vars(localize("k_mul_exorcise_spirit"), { card.ability.extra.cards }),
			end_interaction = function()
				Multiverse.exhaust_cards(G.hand.highlighted)
			end,
		})
	end,
})

Multiverse.SkillCard({
	key = "rude_buster",
	tp_cost = 20,
	config = { extra = { xblindsize = 0.6, crit = 0.3, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "mul_rude_buster")
		return {
			vars = {
				card.ability.extra.xblindsize,
				n,
				d,
				card.ability.extra.crit,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		if SMODS.pseudorandom_probability(card, "mul_rude_buster", 1, card.ability.extra.odds) then
			Multiverse.effect_animation(card, function()
				SMODS.calculate_effect({
					xblindsize = card.ability.extra.crit,
					colour = G.C.PURPLE,
				}, card)
			end, true)
		else
			Multiverse.effect_animation(card, function()
				SMODS.calculate_effect({
					xblindsize = card.ability.extra.xblindsize,
					colour = G.C.PURPLE,
				}, card)
			end, true)
		end
	end,
})

Multiverse.SkillCard({
	key = "juggling",
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
		G.E_MANAGER:add_event(Event({
			func = function()
				G.E_MANAGER:add_event(Event({
					func = function()
						if #G.hand.cards > 0 then
							Multiverse.start_interaction({
								select_limit = card.ability.extra.cards,
								area = "hand",
								can_end_interaction = function()
									return #G.hand.highlighted == math.min(#G.hand.cards, card.ability.extra.cards)
								end,
								display_text = Multiverse.parse_vars(
									localize("k_mul_juggling1"),
									{ math.min(#G.hand.cards, card.ability.extra.cards) }
								),
								end_interaction = function()
									G.FUNCS.discard_cards_from_highlighted(nil, true)
									G.E_MANAGER:add_event(Event({
										func = function()
											Multiverse.start_interaction({
												area = "discard",
												end_interaction = function()
													local cards = Multiverse.get_discard_view_selected()
													G.E_MANAGER:add_event(Event({
														trigger = "immediate",
														func = function()
															local count = #cards
															for i = 1, count do
																Multiverse.draw_card(
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
												select_limit = card.ability.extra.cards,
												display_text = Multiverse.parse_vars(
													localize("k_mul_juggling2"),
													{ card.ability.extra.cards }
												),
											}, card)
											return true
										end,
									}))
								end,
							})
						else
							Multiverse.start_interaction({
								area = "discard",
								end_interaction = function()
									local cards = Multiverse.get_discard_view_selected()
									G.E_MANAGER:add_event(Event({
										trigger = "immediate",
										func = function()
											local count = #cards
											for i = 1, count do
												Multiverse.draw_card(
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
								select_limit = card.ability.extra.cards,
								display_text = Multiverse.parse_vars(
									localize("k_mul_juggling2"),
									{ card.ability.extra.cards }
								),
							}, card)
						end
						return true
					end,
				}))
				return true
			end,
		}))
	end,
	can_use_skill = function(self, card)
		return #G.deck.cards >= card.ability.extra.cards
	end,
})

function Multiverse.set_card_counting_rank()
	G.GAME.current_round.mul_cc_rank = "Ace"
	local valid = {}
	for _, c in ipairs(G.playing_cards) do
		if not SMODS.has_no_rank(c) then
			table.insert(valid, c)
		end
	end
	local cc_card = pseudorandom_element(valid, "mul_cc_" .. G.GAME.round_resets.ante)
	if cc_card then
		G.GAME.current_round.mul_cc_rank = cc_card.base.value
	end
end

Multiverse.SkillCard({
	key = "card_counting",
	tp_cost = 15,
	sneaky = true,
	ethereal = true,
	config = { extra = { cards = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ethereal"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_sneaky"]
		return {
			vars = {
				card.ability.extra.cards,
				localize(G.GAME.current_round.mul_cc_rank or "Ace", "ranks"),
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			for _ = 1, 2 do
				Multiverse.drawn_card_modify_queue[#Multiverse.drawn_card_modify_queue + 1] = {
					func = function(c)
						assert(SMODS.change_base(c, nil, G.GAME.current_round.mul_cc_rank))
					end,
				}
			end
			SMODS.draw_cards(card.ability.extra.cards)
		end)
	end,
	can_use_skill = function(self, card)
		return #G.deck.cards >= card.ability.extra.cards
	end,
})

Multiverse.SkillCard({
	key = "sleight_of_hand",
	tp_cost = 20,
	sneaky = true,
	config = { extra = { boost = 1 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_sneaky"]
		return {
			vars = {
				card.ability.extra.boost,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.effect_animation(card, function()
			ease_hands_played(1, true)
			ease_discard(1, true, true)
		end)
		return "exhaust"
	end,
})

Multiverse.SkillCard({
	key = "foresight",
	tp_cost = 20,
	innate = true,
	config = { extra = { priority = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_innate"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_exhaust"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_priority"]
		return {
			vars = {
				card.ability.extra.priority,
			},
		}
	end,
	use_skill = function(self, card, paid_amt, x)
		Multiverse.start_interaction({
			area = "discard",
			end_interaction = function()
				local c = Multiverse.get_discard_view_selected()[1]
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						Multiverse.apply_to_playing_cards(function(playing_card)
							if
								playing_card ~= c
								and not SMODS.has_no_rank(playing_card)
								and not SMODS.has_no_suit(playing_card)
								and playing_card:get_id() == c:get_id()
							then
								local wild = false
								if SMODS.has_any_suit(playing_card) or SMODS.has_any_suit(c) then
									wild = true
									playing_card.ability.mul_temp_priority = (
										playing_card.ability.mul_temp_priority or 0
									) + card.ability.extra.priority
								end
								if not wild then
									for suit_key, _ in pairs(SMODS.Suits) do
										if playing_card:is_suit(suit_key) and c:is_suit(suit_key) then
											playing_card.ability.mul_temp_priority = (
												playing_card.ability.mul_temp_priority or 0
											) + card.ability.extra.priority
											break
										end
									end
								end
							end
						end)
					end,
				}))
			end,
			can_end_interaction = function()
				return #Multiverse.get_discard_view_selected() > 0
			end,
			select_limit = 1,
			display_text = Multiverse.parse_vars(localize("k_mul_foresight"), { card.ability.extra.priority }),
		}, card)
		return "exhaust"
	end,
	can_use_skill = function(self, card)
		return #G.discard.cards > 0
	end,
})
