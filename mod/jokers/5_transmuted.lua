SMODS.Rarity({
	key = "transmuted",
	default_weight = 0,
	badge_colour = Multiverse.C.TRANSMUTED_GRADIENT,
	pools = {
		["Joker"] = true,
	},
})

SMODS.Joker({
	key = "ren_amamiya",
	atlas = "placeholder",
	pos = { x = 4, y = 0 },
	rarity = "mul_transmuted",
	blueprint_compat = false,
	cost = 40,
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, G.P_CENTERS.m_mul_calling_card)
		local tarots_held = { n = 0 }
		if G.consumeables then
			for _, c in ipairs(G.consumeables.cards) do
				if not tarots_held[c.config.center_key] and c.ability.set == "Tarot" then
					tarots_held[c.config.center_key] = 1
					tarots_held.n = tarots_held.n + 1
				end
			end
		end
		return { vars = { tarots_held.n } }
	end,
	attributes = { "retrigger", "tarot", "modify_card", "scaling" },
	calculate = function(self, card, context)
		if context.before then
			local changed_card = context.scoring_hand[1]
			if not SMODS.has_enhancement(changed_card, "m_mul_calling_card") then
				assert(SMODS.change_base(changed_card, "Hearts", "Ace"))
				G.E_MANAGER:add_event(Event({
					func = function()
						changed_card:mul_safe_dissolve(nil, false, 1.6)
						return true
					end,
				}))
				delay(1.75)
				changed_card:set_ability("m_mul_calling_card", false, true)
				G.E_MANAGER:add_event(Event({
					func = function()
						changed_card:start_materialize(nil, false, 1.6)
						return true
					end,
				}))
			end
		end
		if context.initial_scoring_step then
			local has_call_card = false
			for _, c in ipairs(G.hand.cards) do
				if c.config.center_key == "m_mul_calling_card" and c.facing == "front" then
					has_call_card = true
					break
				end
			end
			for _, c in ipairs(context.full_hand) do
				if (c.config.center_key == "m_mul_calling_card" and c.facing == "front") or has_call_card then
					has_call_card = true
					break
				end
			end
			if has_call_card then
				delay(0.9)
				G.E_MANAGER:add_event(Event({
					trigger = "ease",
					ref_table = G.GAME,
					ref_value = "mul_call_card_anim_state",
					ease_to = 6,
					delay = 1.2,
				}))
			end
		end
		if
			context.repetition
			and context.cardarea == G.play
			and SMODS.has_enhancement(context.other_card, "m_mul_calling_card")
		then
			local tarots_held = { n = 0 }
			if G.consumeables then
				for _, c in ipairs(G.consumeables.cards) do
					if not tarots_held[c.config.center_key] and c.ability.set == "Tarot" then
						tarots_held[c.config.center_key] = true
						tarots_held.n = tarots_held.n + 1
					end
				end
			end
			if tarots_held.n > 0 then
				return { repetitions = tarots_held.n }
			end
		end
		if context.after then
			local has_call_card = false
			for _, c in ipairs(G.hand.cards) do
				if c.config.center_key == "m_mul_calling_card" and c.facing == "front" then
					has_call_card = true
					break
				end
			end
			for _, c in ipairs(context.full_hand) do
				if (c.config.center_key == "m_mul_calling_card" and c.facing == "front") or has_call_card then
					has_call_card = true
					break
				end
			end
			if has_call_card then
				G.E_MANAGER:add_event(Event({
					trigger = "ease",
					ref_table = G.GAME,
					ref_value = "mul_call_card_anim_state",
					ease_to = 0,
					delay = 1.8,
				}))
				delay(0.5)
			end
		end
	end,
})

Multiverse.UsableJoker({
	key = "steve",
	atlas = "placeholder",
	pos = { x = 4, y = 0 },
	rarity = "mul_transmuted",
	blueprint_compat = false,
	cost = 40,
	attributes = { "usable", "hand_size", "modify_card", "scaling", "generation", "tp", "economy", "passive" },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, G.P_CENTERS.m_mul_netherite)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_steve_ability",
			vars = {
				card.ability.extra.tp_cost,
				card.ability.extra.dollar_cost,
				5,
				card.ability.extra.increment,
			},
		})
		return { vars = { card.ability.extra.hand_size } }
	end,
	config = { extra = { hand_size = 2, tp_cost = 20, dollar_cost = 10, increment = 1 } },
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_size)
	end,
	calculate = function(self, card, context)
		if context.before then
			local _card = SMODS.create_card({
				key = "m_mul_netherite",
				key_append = "j_steve",
				area = G.discard,
			})
			G.playing_card = (G.playing_card and G.playing_card + 1) or 1
			_card.playing_card = G.playing_card
			table.insert(G.playing_cards, _card)
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand:emplace(_card)
					_card:start_materialize()
					G.GAME.blind:debuff_card(_card)
					G.hand:sort()
					card:juice_up()
					SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
					save_run()
					return true
				end,
			}))
			return {
				message = localize("k_mul_mined"),
			}
		end
	end,
	use = function(self, card)
		Multiverse.effect_animation(card, function()
			card.ability.extra.hand_size = card.ability.extra.hand_size + card.ability.extra.increment
			card.ability.extra.dollar_cost = card.ability.extra.dollar_cost * 2
			G.hand:change_size(card.ability.extra.increment)
		end)
	end,
	can_use = function(self, card)
		local count = 0
		for _, c in ipairs(G.hand.highlighted) do
			if SMODS.has_enhancement(c, "m_mul_netherite") then
				count = count + 1
			end
		end
		return count >= 5
			and G.GAME.dollars >= card.ability.extra.dollar_cost + G.GAME.bankrupt_at
			and G.GAME.mul_TP >= card.ability.extra.tp_cost
	end,
})

SMODS.Joker({
	key = "gerson",
	atlas = "placeholder",
	pos = { x = 4, y = 0 },
	rarity = "mul_transmuted",
	blueprint_compat = false,
	cost = 40,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.joker_xmult, card.ability.extra.increment } }
	end,
	attributes = { "boss_blind", "xmult", "scaling" },
	config = { extra = { joker_xmult = 1, increment = 0.5 } },
	add_to_deck = function(self, card, from_debuff)
		if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
			card:juice_up(0.4, 0.4)
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.blind:disable()
					play_sound("mul_gerson_laugh", 1, 1)
					delay(0.4)
					G.E_MANAGER:add_event(Event({
						func = function()
							Multiverse.play_animation("gerson_disable", {
								anchor = {
									target = G.GAME.blind,
								},
							})
							return true
						end,
					}))
					return true
				end,
			}))
		end
	end,
	calculate = function(self, card, context)
		if context.setting_blind and context.blind.boss then
			card.ability.extra.joker_xmult = card.ability.extra.joker_xmult + card.ability.extra.increment
			card:juice_up(0.4, 0.4)
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.blind:disable()
					play_sound("mul_gerson_laugh", 1, 1)
					delay(0.4)
					G.E_MANAGER:add_event(Event({
						func = function()
							Multiverse.play_animation("gerson_disable", {
								anchor = {
									target = G.GAME.blind,
									x_offset = Multiverse.to_pixels(G.GAME.blind.VT.w),
								},
							})
							return true
						end,
					}))
					return true
				end,
			}))
			return nil, true
		end
		if context.other_joker and card.ability.extra.joker_xmult > 1 then
			return {
				xmult = card.ability.extra.joker_xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "waldo",
	atlas = "placeholder",
	pos = { x = 4, y = 0 },
	config = { extra = { xmult_inc = 0.5 } },
	rarity = "mul_transmuted",
	cost = 40,
	blueprint_compat = false,
	attributes = { "xmult", "scaling", "generation" },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_waldo"]
		local cards_in_deck = 0
		if G.playing_cards then
			cards_in_deck = #G.playing_cards
		end
		return { vars = { card.ability.extra.xmult_inc, (card.ability.extra.xmult_inc * cards_in_deck + 1) } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			Multiverse._CREATING_WALDO = true
			local c = SMODS.add_card({
				set = "Enhanced",
				area = G.deck,
				skip_materialize = true,
				enhancement = "m_mul_waldo",
			})
			Multiverse._CREATING_WALDO = false
			SMODS.calculate_context({ playing_card_added = true, cards = { c } })
		end
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and SMODS.has_enhancement(context.other_card, "m_mul_waldo")
		then
			return {
				xmult = card.ability.extra.xmult_inc * #G.playing_cards + 1,
			}
		end
	end,
})

Multiverse.UsableJoker({
	key = "heavy",
	atlas = "placeholder",
	pos = { x = 4, y = 0 },
	rarity = "mul_transmuted",
	blueprint_compat = false,
	cost = 40,
	attributes = { "hands", "retrigger", "scaling", "usable", "tp", "passive" },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_heavy_ability",
			vars = {
				card.ability.extra.tp_cost,
				card.ability.extra.hand_boost,
			},
		})
		local hands = G.GAME and G.GAME.current_round.hands_left or 0
		return {
			vars = {
				card.ability.extra.hands,
				card.ability.extra.retriggers,
				card.ability.extra.retriggers_per_hand,
				card.ability.extra.retriggers + card.ability.extra.retriggers_per_hand * hands,
			},
		}
	end,
	config = { extra = { retriggers = 6, retriggers_per_hand = 2, hands = 2, hand_boost = 4, tp_cost = 30 } },
	calculate = function(self, card, context)
		return Multiverse.handle_distributed_retriggers(
			context,
			card,
			card.ability.extra.retriggers
				+ (G.GAME.current_round.hands_left + 1) * card.ability.extra.retriggers_per_hand
		)
	end,
	use = function(self, card)
		Multiverse.effect_animation(card, function()
			Multiverse.ease_TP(-card.ability.extra.tp_cost, { immediate = true })
			ease_hands_played(card.ability.extra.hand_boost)
			SMODS.calculate_effect({
				message = localize("k_eaten_ex"),
			}, card)
		end)
	end,
	can_use = function(self, card)
		return G.GAME.mul_TP >= card.ability.extra.tp_cost
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
		ease_hands_played(card.ability.extra.hands)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
		ease_hands_played(-card.ability.extra.hands)
	end,
})

Multiverse.UsableJoker({
	key = "impostor",
	atlas = "placeholder",
	pos = { x = 4, y = 0 },
	rarity = "mul_transmuted",
	blueprint_compat = false,
	cost = 40,
	attributes = { "usable", "copying", "tp", "destroy_card" },
	config = { extra = { tp_gain = 10 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_impostor_ability",
			vars = {
				card.ability.extra.tp_gain,
			},
		})
		if card.area and card.area == G.jokers then
			local left_joker
			local right_joker
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					right_joker = G.jokers.cards[i + 1]
					left_joker = G.jokers.cards[i - 1]
				end
			end
			local left_compatible = left_joker and left_joker ~= card and left_joker.config.center.blueprint_compat
			local right_compatible = right_joker and right_joker ~= card and right_joker.config.center.blueprint_compat
			main_end = {
				{
					n = G.UIT.R,
					config = { align = "bm", minh = 0.4, padding = 0.05 },
					nodes = {
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = left_compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
									or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06,
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " "
											.. localize("k_" .. (left_compatible and "compatible" or "incompatible"))
											.. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = right_compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
									or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06,
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " "
											.. localize("k_" .. (right_compatible and "compatible" or "incompatible"))
											.. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
					},
				},
			}
			return { main_end = main_end }
		end
	end,
	calculate = function(self, card, context)
		local index = 1
		if context.end_of_round and context.main_eval and not context.game_over then
			card.ability.extra.used = false
		end
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				index = i
				break
			end
		end
		local left = SMODS.blueprint_effect(card, G.jokers.cards[index - 1], context) or {}
		local right = SMODS.blueprint_effect(card, G.jokers.cards[index + 1], context) or {}
		return SMODS.merge_effects({ left, right })
	end,
	can_use = function(self, card)
		return #Multiverse.filter(G.jokers.cards, function(item)
			return item ~= card and not SMODS.is_eternal(item, card)
		end) >= 1
	end,
	use = function(self, card)
		Multiverse.start_interaction({
			area = "jokers",
			can_end_interaction = function()
				return #G.jokers.highlighted == 1
					and not SMODS.is_eternal(G.jokers.highlighted[1], card)
					and G.jokers.highlighted[1] ~= card
			end,
			end_interaction = function()
				SMODS.destroy_cards(G.jokers.highlighted[1])
				Multiverse.ease_TP(card.ability.extra.tp_gain)
			end,
			display_text = localize("k_mul_murder"),
		})
	end,
})

Multiverse.UsableJoker({
	key = "frozone",
	atlas = "placeholder",
	pos = { x = 4, y = 0 },
	rarity = "mul_transmuted",
	blueprint_compat = false,
	cost = 40,
	attributes = { "modify_card", "usable", "tp", "passive" },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
		table.insert(info_queue, {
			set = "Other",
			key = "mul_frozone_ability",
			vars = {
				card.ability.extra.tp_cost,
				card.ability.extra.max_selected,
			},
		})
		return {
			vars = {
				card.ability.extra.xmult_inc,
			},
		}
	end,
	config = { extra = { xmult_inc = 0.05, tp_cost = 5, max_selected = 1, seal = "mul_frozen" } },
	use = function(self, card)
		local target = G.hand.highlighted[1]
		Multiverse.effect_animation(card, function()
			Multiverse.ease_TP(-card.ability.extra.tp_cost)
			target:set_seal(card.ability.extra.seal, nil, true)
			target:juice_up(0.3, 0.5)
			SMODS.calculate_effect({
				message = localize("k_mul_frozen"),
			}, card)
		end)
	end,
	can_use = function(self, card)
		return G.GAME.mul_TP >= card.ability.extra.tp_cost and #G.hand.highlighted == 1
	end,
})
