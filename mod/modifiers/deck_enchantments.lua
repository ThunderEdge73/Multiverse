Multiverse.DeckEnchantment({
	key = "dark_affinity",
	max_level = 2,
	config = { slots = 1 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.BLUE)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.slots
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, enchantment)
		G.jokers:change_size(delta * enchantment.ability.slots)
		ease_hands_played(-delta * enchantment.ability.slots)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - delta * enchantment.ability.slots
	end,
	deck_incompat = {
		"b_black",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return math.min(G.GAME.round_resets.hands, G.GAME.current_round.hands_left) > args.level_amt
	end,
	group_id = "deck",
})

Multiverse.DeckEnchantment({
	key = "flame_affinity",
	max_level = 2,
	config = { hands = 1, discards = 2 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.BLUE)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.discards
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.hands
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, enchantment)
		ease_discard(delta * enchantment.ability.discards)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + delta * enchantment.ability.discards
		ease_hands_played(-delta * enchantment.ability.hands)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - delta * enchantment.ability.hands
	end,
	deck_incompat = {
		"b_red",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return math.min(G.GAME.round_resets.hands, G.GAME.current_round.hands_left) > args.level_amt
	end,
	group_id = "deck",
})

Multiverse.DeckEnchantment({
	key = "aqua_affinity",
	max_level = 2,
	config = { hands = 2, discards = 1 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.BLUE)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.hands
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.discards
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, enchantment)
		ease_hands_played(delta + enchantment.ability.hands)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + delta * enchantment.ability.hands
		ease_discard(-delta * enchantment.ability.discards)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - delta * enchantment.ability.discards
	end,
	deck_incompat = {
		"b_blue",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return math.min(G.GAME.round_resets.discards, G.GAME.current_round.discards_left) >= args.level_amt
	end,
	group_id = "deck",
})

Multiverse.DeckEnchantment({
	key = "cosmic_affinity",
	max_level = 2,
	config = { slots = 1 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.slots
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, enchantment)
		G.consumeables:change_size(-delta * enchantment.ability.slots)
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
	group_id = "deck",
})

Multiverse.DeckEnchantment({
	key = "druidic_affinity",
	max_level = 2,
	config = { hand_discard_bonus = 1, inflation = 2 },
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
	on_change_level = function(self, delta, enchantment)
		G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1)
			+ delta * enchantment.ability.hand_discard_bonus
		G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0)
			+ delta * enchantment.ability.hand_discard_bonus
		G.GAME.inflation = G.GAME.inflation + delta * enchantment.ability.inflation
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
	group_id = "deck",
})

Multiverse.DeckEnchantment({
	key = "artistic_affinity",
	max_level = 2,
	config = { slots = 1, hand_size = 3 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.RED)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.hand_size
		end
		for i = 1, self.max_level do
			ret[#ret + 1] = i * enchantment.ability.slots
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	on_change_level = function(self, delta, enchantment)
		G.hand:change_size(delta * enchantment.ability.hand_size)
		G.jokers:change_size(-delta * enchantment.ability.slots)
	end,
	deck_incompat = {
		"b_painted",
	},
	enchantment_type = "neutral",
	in_pool = function(self, args)
		return G.jokers.config.card_limit >= args.level_amt
	end,
	group_id = "deck",
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
	on_change_level = function(self, delta, enchantment)
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
	group_id = "deck",
})

Multiverse.DeckEnchantment({
	key = "stellar_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		for i = 1, self.max_level do
			ret[#ret + 1] = i * 2
		end
		ret.colours = colours
		info_queue[#info_queue + 1] = G.P_CENTERS.c_emperor
		info_queue[#info_queue + 1] = G.P_CENTERS.c_high_priestess
		return {
			vars = ret,
		}
	end,
	deck_incompat = {
		"b_zodiac",
	},
	enchantment_type = "neutral",
	group_id = "deck",
	calculate = function(self, enchantment, context)
		if context.starting_shop then
			G.E_MANAGER:add_event(Event({
				func = function()
					if enchantment.level == 1 then
						local card = SMODS.create_card({
							key = pseudorandom_element({ "c_emperor", "c_high_priestess" }, "mul_stellar_affinity"),
						})
						create_shop_card_ui(card)
						G.shop_jokers:emplace(card)
					else
						local card1 = SMODS.create_card({
							key = "c_emperor",
						})
						local card2 = SMODS.create_card({
							key = "c_high_priestess",
						})
						create_shop_card_ui(card1)
						G.shop_jokers:emplace(card1)
						create_shop_card_ui(card2)
						G.shop_jokers:emplace(card2)
					end
					return true
				end,
			}))
		end
	end,
	on_change_level = function(self, delta, enchantment)
		G.GAME.joker_rate = G.GAME.joker_rate / math.pow(2, delta)
	end,
})

Multiverse.DeckEnchantment({
	key = "chromatic_affinity",
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
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		return {
			vars = ret,
		}
	end,
	deck_incompat = {
		"b_checkered",
	},
	enchantment_type = "neutral",
	group_id = "deck",
	calculate = function(self, enchantment, context)
		if context.discard and G.GAME.current_round.discards_used < enchantment.level then
			local c = context.other_card
			G.E_MANAGER:add_event(Event({
				func = function()
					c:juice_up()
					c:set_ability("m_wild")
				end,
			}))
			delay(0.45)
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "chaos_affinity",
	max_level = 2,
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.FILTER)
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	deck_incompat = {
		"b_erratic",
	},
	enchantment_type = "neutral",
	group_id = "deck",
	calculate = function(self, enchantment, context)
		if context.before and G.GAME.current_round.hands_played == 0 then
			local rank_pool = {}
			for key, def in pairs(SMODS.Ranks) do
				if not def.in_pool or (type(def.in_pool) == "function" and def:in_pool()) then
					rank_pool[#rank_pool + 1] = key
				end
			end
			local suit_pool = {}
			for key, def in pairs(SMODS.Suits) do
				if not def.in_pool or (type(def.in_pool) == "function" and def:in_pool()) then
					suit_pool[#suit_pool + 1] = key
				end
			end
			for _, c in ipairs(context.full_hand) do
				if enchantment.level == 1 then
					local change_rank = pseudorandom("mul_chaos_affinity_select", 1, 2) == 1
					if change_rank then
						local r = pseudorandom_element(rank_pool, "mul_chaos_affinity")
						assert(SMODS.change_base(c, nil, r))
					else
						local s = pseudorandom_element(suit_pool, "mul_chaos_affinity")
						assert(SMODS.change_base(c, s))
					end
				else
					local r = pseudorandom_element(rank_pool, "mul_chaos_affinity")
					local s = pseudorandom_element(suit_pool, "mul_chaos_affinity")
					assert(SMODS.change_base(c, s, r))
				end
				c:juice_up()
			end
		end
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
	on_change_level = function(self, delta, enchantment)
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
	group_id = "deck",
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
				x_blind_size = 1 + enchantment.level * 0.5,
				colour = G.C.PURPLE,
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
	group_id = "deck",
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
			for _ = 1, enchantment.level do
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
	group_id = "deck",
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
				x_blind_size = 1 + enchantment.level * 0.5,
				colour = G.C.PURPLE,
			}
		end
		if context.modify_hand then
			mult = mod_mult(mult * (enchantment.level + 1))
			hand_chips = mod_chips(hand_chips * (enchantment.level + 1))
			update_hand_text({ sound = "chips2", delay = 0 }, { chips = hand_chips, mult = mult })
		end
	end,
	group_id = "deck",
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
	group_id = "deck",
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
	on_change_level = function(self, delta, enchantment)
		G.GAME.mul_enchantment_luck = G.GAME.mul_enchantment_luck + delta * self.config.luck_bonus
	end,
	group_id = "lucky",
})

Multiverse.DeckEnchantment({
	key = "protection",
	max_level = 5,
	config = { chips = 10 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.chips,
				enchantment.ability.chips * enchantment.level,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.individual and context.cardarea == G.play then
			return {
				chips = enchantment.ability.chips * enchantment.level,
			}
		end
	end,
	group_id = "prot",
})

Multiverse.DeckEnchantment({
	key = "proj_protection",
	max_level = 5,
	config = { chips = 40 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.chips,
				enchantment.ability.chips * enchantment.level,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if
			context.individual
			and context.cardarea == G.play
			and #context.scoring_hand % 2 == 1
			and context.other_card == context.scoring_hand[math.ceil(#context.scoring_hand / 2)]
		then
			return {
				chips = enchantment.ability.chips * enchantment.level,
			}
		end
	end,
	group_id = "prot",
})

Multiverse.DeckEnchantment({
	key = "blast_protection",
	max_level = 5,
	config = { chips = 30 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.chips,
				enchantment.ability.chips * enchantment.level,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if
			context.individual
			and context.cardarea == G.play
			and G.GAME.current_round.hands_played == 0
		then
			return {
				chips = enchantment.ability.chips * enchantment.level,
			}
		end
	end,
	group_id = "prot",
})

Multiverse.DeckEnchantment({
	key = "fire_protection",
	max_level = 5,
	config = { chips = 2, current = 0 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.chips,
				enchantment.ability.chips * enchantment.level,
				enchantment.ability.current,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.pre_discard then
			enchantment.ability.current = enchantment.ability.current + enchantment.ability.chips * enchantment.level
			return {
				message = localize("k_upgrade_ex"),
			}
		end
		if context.individual and context.cardarea == G.play then
			return {
				chips = enchantment.ability.current,
			}
		end
		if context.end_of_round and context.main_eval and not context.game_over then
			enchantment.ability.current = 0
			return {
				message = localize("k_reset"),
			}
		end
	end,
	group_id = "prot",
})

Multiverse.DeckEnchantment({
	key = "sharpness",
	max_level = 5,
	config = { xmult = 0.25 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.xmult,
				1 + enchantment.ability.xmult * enchantment.level,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.individual and context.cardarea == G.play then
			return {
				xmult = 1 + enchantment.ability.xmult * enchantment.level,
			}
		end
	end,
	group_id = "damage",
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
				enchantment.ability.chips * enchantment.level,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.initial_scoring_step then
			return {
				chips = enchantment.ability.chips * enchantment.level,
			}
		end
	end,
	group_id = "damage",
})

Multiverse.DeckEnchantment({
	key = "looting",
	max_level = 4,
	config = { odds = 0.5 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(
			self,
			enchantment,
			colours,
			G.C.GREEN,
			lighten(G.C.UI.TEXT_INACTIVE, 0.3)
		)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.WHITE)
		for i = 1, self.max_level do
			ret[#ret + 1] = 1 + i * enchantment.ability.odds
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.mod_probability then
			return {
				numerator = context.numerator * (1 + enchantment.level * enchantment.ability.odds),
			}
		end
	end,
	group_id = "lucky",
})

Multiverse.DeckEnchantment({
	key = "power",
	max_level = 5,
	config = { retriggers = 1 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.level * enchantment.ability.retriggers,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if
			context.repetition
			and context.cardarea == G.play
			and context.other_card == context.scoring_hand[#context.scoring_hand]
		then
			return {
				repetitions = enchantment.level * enchantment.ability.retriggers,
			}
		end
	end,
	group_id = "damage",
})

Multiverse.DeckEnchantment({
	key = "breach",
	max_level = 4,
	config = { mult = 0.1 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(
			self,
			enchantment,
			colours,
			G.C.PURPLE,
			lighten(G.C.UI.TEXT_INACTIVE, 0.3)
		)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.WHITE)
		for i = 1, self.max_level do
			ret[#ret + 1] = 1 - i * enchantment.ability.mult
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.setting_blind then
			return {
				x_blind_size = (1 - enchantment.level * enchantment.ability.mult),
				colour = G.C.PURPLE,
			}
		end
	end,
	group_id = "damage",
})

Multiverse.DeckEnchantment({
	key = "smite",
	max_level = 5,
	config = { xmult = 0.5 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.xmult,
				1 + enchantment.ability.xmult * enchantment.level,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if G.GAME.current_round.hands_left == 0 and context.individual and context.cardarea == G.play then
			return {
				xmult = 1 + enchantment.ability.xmult * enchantment.level,
			}
		end
	end,
	group_id = "damage",
})

Multiverse.DeckEnchantment({
	key = "mending",
	max_level = 1,
	config = { odds = 4 },
	loc_vars = function(self, info_queue, enchantment)
		local num, denom = SMODS.get_probability_vars(enchantment, 1, enchantment.ability.odds, "mul_mending")
		return {
			vars = {
				num,
				denom,
			},
		}
	end,
	enchantment_type = "positive",
	calc_scaling = function(self, enchantment, other_card, scaling_value, scalar_value, args)
		if
			args.operation == "+"
			and other_card.ability.set == "Joker"
			and SMODS.pseudorandom_probability(enchantment, "mul_mending", 1, enchantment.ability.odds)
			and scalar_value > 0
		then
			return {
				override_scalar_value = {
					value = scalar_value * 2,
				},
			}
		end
	end,
	group_id = "mending_infinity",
})

Multiverse.DeckEnchantment({
	key = "unbreaking",
	max_level = 4,
	config = { odds = 7 },
	loc_vars = function(self, info_queue, enchantment)
		local _, denom = SMODS.get_probability_vars(enchantment, 1, enchantment.ability.odds, "mul_unbreaking")
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
			denom,
		}
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.GREEN)
		for i = 1, self.max_level do
			local num, _ = SMODS.get_probability_vars(enchantment, i, enchantment.ability.odds, "mul_unbreaking")
			ret[#ret + 1] = num
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	enchantment_type = "positive",
	calc_scaling = function(self, enchantment, other_card, scaling_value, scalar_value, args)
		if
			args.operation == "-"
			and other_card.ability.set == "Joker"
			and SMODS.pseudorandom_probability(
				enchantment,
				"mul_unbreaking",
				enchantment.level,
				enchantment.ability.odds
			)
			and scalar_value > 0
		then
			return {
				override_scalar_value = {
					value = 0,
				},
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "impaling",
	max_level = 5,
	config = { xmult = 0.05, current = 1 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
				enchantment.ability.xmult,
				enchantment.ability.xmult * enchantment.level,
				enchantment.ability.current,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.before then
			enchantment.ability.current = enchantment.ability.current + enchantment.ability.xmult * enchantment.level
			return {
				message = localize("k_upgrade_ex"),
			}
		end
		if context.individual and context.cardarea == G.play then
			return {
				xmult = enchantment.ability.current,
			}
		end
		if context.end_of_round and context.main_eval and not context.game_over then
			enchantment.ability.current = 1
			return {
				message = localize("k_reset"),
			}
		end
	end,
	group_id = "damage",
})

Multiverse.DeckEnchantment({
	key = "channeling",
	max_level = 1,
	config = { xmult = 0.1, current = 1 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				enchantment.ability.xmult,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.individual then
			if context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
				enchantment.ability.current = enchantment.ability.current + enchantment.ability.xmult
			end
			if context.cardarea == G.hand then
				return {
					xmult = enchantment.ability.current,
				}
			end
		end
		if context.after then
			enchantment.ability.current = 1
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "silk_touch",
	max_level = 1,
	config = { in_shop = false },
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.check_eternal and context.other_card.ability.set == "Joker" and G.GAME.blind.in_blind then
			return {
				no_destroy = { bypass_compat = true },
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "efficiency",
	max_level = 5,
	config = { mult = 0.01 },
	loc_vars = function(self, info_queue, enchantment)
		local colours = {}
		local ret = {
			(enchantment.level > 0 and " " or "") .. Multiverse.number_to_roman(enchantment.level),
		}
		Multiverse.handle_deck_enchantment_loc_colours(
			self,
			enchantment,
			colours,
			G.C.PURPLE,
			lighten(G.C.UI.TEXT_INACTIVE, 0.3)
		)
		Multiverse.handle_deck_enchantment_loc_colours(self, enchantment, colours, G.C.WHITE)
		for i = 1, self.max_level do
			ret[#ret + 1] = 1 - i * enchantment.ability.mult
		end
		ret.colours = colours
		return {
			vars = ret,
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.individual and context.cardarea == G.play then
			return {
				x_blind_size = (1 - enchantment.level * enchantment.ability.mult),
				colour = G.C.PURPLE,
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "infinity",
	max_level = 1,
	config = { exchanged = 1 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				enchantment.ability.exchanged,
			},
		}
	end,
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if context.after and G.GAME.current_round.discards_left > 0 then
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_hands_played(enchantment.ability.exchanged)
					ease_discard(-enchantment.ability.exchanged, nil, true)
					return true
				end,
			}))
		end
	end,
	group_id = "mending_infinity",
})

Multiverse.DeckEnchantment({
	key = "loyalty",
	max_level = 3,
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
	enchantment_type = "positive",
	calculate = function(self, enchantment, context)
		if
			context.stay_flipped
			and context.from_area == G.play
			and G.GAME.current_round.hands_played < enchantment.level
		then
			return {
				modify = { to_area = G.hand },
			}
		end
	end,
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
	key = "emptiness",
	max_level = 1,
	enchantment_type = "negative",
	config = { triggered = false },
	calculate = function(self, enchantment, context)
		if context.ante_change then
			enchantment.ability.triggered = false
		end
	end,
	on_change_level = function(self, delta, enchantment)
		if delta > 0 then
			enchantment.ability.triggered = G.GAME.mul_consumable_used_this_ante
		end
	end,
})

function Multiverse.emptiness_active()
	return Multiverse.has_deck_enchantment("de_mul_emptiness")
		and not G.GAME.mul_deck_enchantments["de_mul_emptiness"].ability.triggered
end

Multiverse.DeckEnchantment({
	key = "vanishing",
	max_level = 1,
	enchantment_type = "negative",
})

Multiverse.DeckEnchantment({
	key = "binding",
	max_level = 1,
	enchantment_type = "negative",
	calculate = function(self, enchantment, context)
		if context.check_eternal and (context.trigger or {}).from_sell then
			return {
				no_destroy = { override_compat = true },
			}
		end
	end,
})

Multiverse.DeckEnchantment({
	key = "apathy",
	max_level = math.huge,
	enchantment_type = "negative",
	config = { chips = -25 },
	loc_vars = function(self, info_queue, enchantment)
		return {
			vars = {
				math.abs(enchantment.ability.chips),
				math.abs(enchantment.ability.chips * enchantment.level),
			},
		}
	end,
	calculate = function(self, enchantment, context)
		if context.joker_main then
			return {
				chips = enchantment.level * enchantment.ability.chips,
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
	calculate = function(self, enchantment, context)
		if context.joker_main then
			return {
				xmult = 1 + enchantment.level * enchantment.ability.xmult,
			}
		end
	end,
})
