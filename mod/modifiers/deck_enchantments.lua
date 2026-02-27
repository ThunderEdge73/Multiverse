Multiverse.DeckEnchantment({
	key = "dark_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.BLUE)
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		G.jokers:change_size(delta)
		ease_hands_played(-delta)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - delta
	end,
	deck_incompat = {
		"b_black",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return math.min(G.GAME.round_resets.hands, G.GAME.current_round.hands_left) > args.level_amt
	end,
})

Multiverse.DeckEnchantment({
	key = "flame_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.BLUE)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 2
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		ease_discard(delta * 2)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + delta * 2
		ease_hands_played(-delta)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - delta
	end,
	deck_incompat = {
		"b_red",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return math.min(G.GAME.round_resets.hands, G.GAME.current_round.hands_left) > args.level_amt
	end,
})

Multiverse.DeckEnchantment({
	key = "aqua_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.BLUE)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 2
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		ease_hands_played(delta * 2)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + delta * 2
		ease_discard(-delta)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - delta
	end,
	deck_incompat = {
		"b_blue",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return math.min(G.GAME.round_resets.discards, G.GAME.current_round.discards_left) >= args.level_amt
	end,
})

Multiverse.DeckEnchantment({
	key = "cosmic_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		G.consumeables:change_size(-delta)
	end,
	deck_incompat = {
		"b_nebula",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return G.consumeables.config.card_limit >= args.level_amt
	end,
	calculate = function(self, enchantment, context)
		if context.using_consumeable and context.consumeable.ability.set == "Planet" then
			local hand = Multiverse.get_most_played_hand()
			return {
				level_up = enchantment.level,
				level_up_hand = hand,
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "druidic_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.MONEY)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.MONEY)
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 3
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) + delta
		G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + delta
		G.GAME.inflation = G.GAME.inflation + delta * 3
		for _, v in pairs(G.I.CARD) do
			if v.set_cost then
				v:set_cost()
			end
		end
	end,
	deck_incompat = {
		"b_green",
	},
	enchantment_type = "neutral",
})

Multiverse.DeckEnchantment({
	key = "artistic_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 3
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		G.hand:change_size(delta * 3)
		G.jokers:change_size(-delta)
	end,
	deck_incompat = {
		"b_painted",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return G.jokers.config.card_limit >= args.level_amt
	end,
})

Multiverse.DeckEnchantment({
	key = "light_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.MONEY)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 6
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		G.hand:change_size(-delta)
	end,
	deck_incompat = {
		"b_yellow",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return G.jokers.config.card_limit >= args.level_amt
	end,
	calc_dollar_bonus = function(self, enchantment)
		return enchantment.level * 6
	end,
})

Multiverse.DeckEnchantment({
	key = "arcane_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.MONEY)
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 2
		end
		ret.colours = colours
		info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, final_level)
		G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + delta * 2
		G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + delta * 2)
	end,
	deck_incompat = {
		"b_magic",
	},
	enchantment_type = "neutral",
	calculate = function(self, enchantment, context)
		if context.open_booster and context.booster.kind == "Arcana" then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + enchantment.level
			G.E_MANAGER:add_event(Event({
				func = function()
					for i = 1, enchantment.level do
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.add_card({
									key = "c_fool",
									edition = "e_negative",
								})

								G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
								return true
							end,
						}))
						SMODS.calculate_effect({
							message = localize("k_plus_tarot"),
							colour = G.C.PURPLE,
						}, G.deck.cards[1] or G.deck)
					end
					return true
				end,
			}))
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "supernatural_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.WHITE)
		Multiverse.handle_deck_enchantment_loc_colours(
			self,
			enchantment,
			colours,
			G.C.PURPLE,
			lighten(G.C.UI.TEXT_INACTIVE, 0.3)
		)
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = 1 + i * 0.5
		end
		ret.colours = colours
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return {
			vars = ret,
		}
	end,
	deck_incompat = {
		"b_ghost",
	},
	enchantment_type = "neutral",
	calculate = function(self, enchantment, context)
		if context.setting_blind then
			return {
				message = localize({
					type = "variable",
					key = "a_mul_x_blind_size",
					vars = { 1 + enchantment.level * 0.5 },
				}),
				func = function()
					Multiverse.change_blind_size(function(chips)
						return chips * (1 + enchantment.level * 0.5)
					end)
				end,
			}
		end
		if context.end_of_round and context.main_eval and not context.game_over and context.beat_boss then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + enchantment.level
			G.E_MANAGER:add_event(Event({
				func = function()
					for i = 1, enchantment.level do
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.add_card({
									set = "Spectral",
									edition = "e_negative",
								})

								G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
								return true
							end,
						}))
						SMODS.calculate_effect({
							message = localize("k_plus_spectral"),
							colour = G.C.SECONDARY_SET.Spectral,
						}, G.deck.cards[1] or G.deck)
					end
					return true
				end,
			}))
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "illusory_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.MONEY)
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 2
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	deck_incompat = {
		"b_anaglyph",
	},
	enchantment_type = "neutral",
	calculate = function(self, enchantment, context)
		if context.end_of_round and context.main_eval and not context.game_over and context.beat_boss then
			for i = 1, enchantment.level do
				G.E_MANAGER:add_event(Event({
					func = function()
						Multiverse.create_random_tag()
						return true
					end,
				}))
			end
		end
	end,
	calc_dollar_bonus = function(self, enchantment)
		return enchantment.level * -2
	end,
})

Multiverse.DeckEnchantment({
	key = "plasma_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.WHITE)
		Multiverse.handle_deck_enchantment_loc_colours(
			self,
			enchantment,
			colours,
			G.C.PURPLE,
			lighten(G.C.UI.TEXT_INACTIVE, 0.3)
		)
		for i = 1, self.max_level do
			ret[#ret + 1] = 1 + i * 0.5
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	deck_incompat = {
		"b_plasma",
	},
	enchantment_type = "neutral",
	calculate = function(self, enchantment, context)
		if context.before then
			return {
				message = localize({
					type = "variable",
					key = "a_mul_x_blind_size",
					vars = { 1 + enchantment.level * 0.5 },
				}),
				func = function()
					Multiverse.change_blind_size(function(chips)
						return chips * (1 + enchantment.level * 0.5)
					end)
				end,
			}
		end
		if context.modify_hand then
			mult = mod_mult(mult * (enchantment.level + 1))
			hand_chips = mod_chips(hand_chips * (enchantment.level + 1))
			update_hand_text({ sound = "chips2", delay = 0 }, { chips = hand_chips, mult = mult })
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "decayed_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		for i = 1, self.max_level do
			ret[#ret + 1] = i
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	deck_incompat = {
		"b_abandoned",
	},
	enchantment_type = "neutral",
	calculate = function(self, enchantment, context)
		if context.end_of_round and context.main_eval and not context.game_over then
			local pool = {}
			Multiverse.apply_to_playing_cards(function(playing_card)
				if playing_card:is_face() then
					pool[#pool + 1] = playing_card
				end
			end)
			local targets = Multiverse.get_unique_pseudorandom_elements(pool, enchantment.level, "decayed_destruction")
			if #targets > 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.destroy_cards(targets)
						SMODS.calculate_effect({
							message = localize("k_mul_destroyed"),
						}, G.deck.cards[1] or G.deck)
						return true
					end,
				}))
			end
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "fortune",
	max_level = 3,
	config = { luck_bonus = 15 },
	loc_vars = function(self, info_queue, enchantment)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_ench_luck_info"]
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, Multiverse.C.DECK_ENCHANTMENT)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.luck_bonus
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	enchantment_type = "positive",
	on_change_level = function(self, delta, final_level)
		G.GAME.mul_enchantment_luck = G.GAME.mul_enchantment_luck + delta * self.config.luck_bonus
	end,
})

Multiverse.DeckEnchantment({
	key = "sharpness",
	max_level = 5,
	config = { xmult = 0.2 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.xmult,
				1 + enchantment.ability.xmult * enchantment.level
			}
		}
	end,
	enchantment_type = "positive",
	calculate = function (self, enchantment, context)
		if context.individual and context.cardarea == G.play then
			return {
				xmult = 1 + enchantment.ability.xmult * enchantment.level
			}
		end
	end
})

Multiverse.DeckEnchantment({
	key = "density",
	max_level = 5,
	config = { chips = 75 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.chips,
				enchantment.ability.chips * enchantment.level
			}
		}
	end,
	enchantment_type = "positive",
	calculate = function (self, enchantment, context)
		if context.initial_scoring_step then
			return {
				chips = enchantment.ability.chips * enchantment.level
			}
		end
	end
})

Multiverse.DeckEnchantment({
	key = "trib_blessing",
	config = { retriggers = 2 },
	max_level = 1,
	enchantment_type = "positive",
	legendary = true,
	calculate = function(self, enchantment, context)
		if
			context.repetition
			and context.cardarea == G.play
			and (context.other_card:get_id() == 12 or context.other_card:get_id() == 13)
		then
			return {
				repetitions = enchantment.ability.retriggers,
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "perkeo_blessing",
	config = { xmult = 3 },
	max_level = 1,
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				enchantment.ability.xmult,
			},
		}
	end,
	enchantment_type = "positive",
	legendary = true,
	calculate = function(self, enchantment, context)
		if context.other_consumeable then
			return {
				x_mult = enchantment.ability.xmult,
				message_card = context.other_consumeable,
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "canio_blessing",
	config = { xmult_inc = 1, xmult = 1 },
	max_level = 1,
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				enchantment.ability.xmult_inc,
				enchantment.ability.xmult,
			},
		}
	end,
	enchantment_type = "positive",
	legendary = true,
	calculate = function(self, enchantment, context)
		if context.destroy_card and context.cardarea == G.play then
			if #context.cardarea.cards == 1 and context.destroy_card:is_face() then
				enchantment.ability.xmult = enchantment.ability.xmult + enchantment.ability.xmult_inc
				return {
					remove = true,
					message = localize("k_upgrade_ex"),
					message_card = G.deck.cards[1] or G.deck,
				}
			end
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "yorick_blessing",
	config = { xmult = 0.25 },
	max_level = 1,
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				enchantment.ability.xmult,
			},
		}
	end,
	enchantment_type = "positive",
	legendary = true,
	calculate = function(self, enchantment, context)
		if context.discard then
			context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult
				+ enchantment.ability.xmult
			return {
				message = localize("k_upgrade_ex"),
				message_card = context.other_card,
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "chicot_blessing",
	max_level = 1,
	enchantment_type = "positive",
	legendary = true,
	calculate = function(self, enchantment, context)
		if context.debuff_card then
			return {
				prevent_debuff = true,
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "overflow",
	max_level = math.huge,
	config = {
		xmult = 0.1,
	},
	enchantment_type = "positive",
	loc_vars = function(self, info_queue, enchantment)
		return { vars = { enchantment.ability.xmult, 1 + enchantment.level * enchantment.ability.xmult } }
	end,
	in_pool = function(self, args)
		return false
	end,
	base_weight = 0,
	calculate = function(self, enchantment, context)
		if context.joker_main then
			return {
				xmult = 1 + enchantment.level * enchantment.ability.xmult,
			}
		end
	end,
})
