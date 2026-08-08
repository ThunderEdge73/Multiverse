SMODS.Joker({
	key = "villager",
	atlas = "placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = {
			mult = 15,
			money_loss = 1,
		},
	},
	rarity = 1,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.money_loss,
			},
		}
	end,
	attributes = { "mult", "economy" },
	calculate = function(self, card, context)
		if context.joker_main then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.money_loss
			return {
				dollars = -card.ability.extra.money_loss,
				mult = card.ability.extra.mult,
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							G.GAME.dollar_buffer = 0
							return true
						end,
					}))
				end,
			}
		end
	end,
})

SMODS.Joker({
	key = "red_bloon",
	atlas = "placeholder",
	pos = { x = 0, y = 0 },
	config = { extra = { money = 1 }, immutable = { rounds_held = 0, total_rounds = 3 } },
	eternal_compat = false,
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money,
				card.ability.immutable.total_rounds - card.ability.immutable.rounds_held,
				card.ability.immutable.total_rounds,
			},
		}
	end,
	attributes = { "economy" },
	calculate = function(self, card, context)
		G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
		if context.individual and context.cardarea == G.play then
			return {
				dollars = card.ability.extra.money,
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							G.GAME.dollar_buffer = 0
							return true
						end,
					}))
				end,
			}
		end
		if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
			card.ability.immutable.rounds_held = card.ability.immutable.rounds_held + 1
			if card.ability.immutable.rounds_held >= 3 then
				SMODS.destroy_cards(card)
				return { message = localize("k_mul_popped") }
			else
				return { message = card.ability.immutable.rounds_held .. "/" .. card.ability.immutable.total_rounds }
			end
		end
	end,
})

SMODS.Joker({
	key = "foddian_struggle",
	atlas = "placeholder",
	pos = { x = 0, y = 0 },
	config = { extra = { mult = 0, mult_inc = 2 } },
	rarity = 1,
	cost = 6,
	attributes = { "scaling", "mult", "reset" },
	loc_vars = function(self, info_queue, card)
		local suit = G.GAME.current_round.mul_foddian_suit or "Hearts"
		return {
			vars = {
				localize(suit, "suits_plural"),
				card.ability.extra.mult_inc,
				card.ability.extra.mult,
				colours = { G.C.SUITS[suit] },
			},
		}
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			local was_reset = false
			for _, c in ipairs(context.full_hand) do
				if c:is_suit(G.GAME.current_round.mul_foddian_suit) then
					SMODS.reset_card(card, { ref_value = "mult" })
					was_reset = true
				end
			end
			if not was_reset then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "mult",
					scalar_value = "mult_inc",
				})
			end
		end
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult = card.ability.extra.mult,
			}
		end
	end,
})

function Multiverse.set_foddian_suit()
	G.GAME.current_round.mul_foddian_suit = "Hearts"
	local valid = {}
	for _, c in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(c) then
			table.insert(valid, c)
		end
	end
	local foddian_card = pseudorandom_element(valid, "mul_foddian" .. G.GAME.round_resets.ante)
	if foddian_card then
		G.GAME.current_round.mul_foddian_suit = foddian_card.base.suit
	end
end

SMODS.Joker({
	key = "slime",
	atlas = "placeholder",
	pos = { x = 0, y = 0 },
	config = { extra = { dollars = 2 }, immutable = { min_cards = 5 } },
	rarity = 1,
	cost = 6,
	attributes = { "economy" },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.immutable.min_cards, card.ability.extra.dollars } }
	end,
	calculate = function(self, card, context)
		if context.before and #context.scoring_hand >= card.ability.extra.min_cards then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
			return {
				dollars = card.ability.extra.dollars,
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							G.GAME.dollar_buffer = 0
							return true
						end,
					}))
				end,
			}
		end
	end,
})

SMODS.Joker({
	key = "jack_frost",
	atlas = "placeholder",
	pos = { x = 0, y = 0 },
	config = { extra = { rank = "Jack", transmute_progress = 0 } },
	transmute_req = Multiverse.set_transmute_requirements(10),
	rarity = 1,
	cost = 5,
	blueprint_compat = false,
	attributes = { "modify_card", "hands", "transmutable" },
	loc_vars = function(self, info_queue, card)
		Multiverse.transmute_info_queue(card, info_queue)
	end,
	calculate = function(self, card, context)
		if context.before and context.scoring_hand[1] and G.GAME.current_round.hands_played == 0 then
			assert(SMODS.change_base(context.scoring_hand[1], nil, "Jack"))
			context.scoring_hand[1]:juice_up()
			return {
				message = localize("k_mul_converted"),
			}
		end
		if context.remove_playing_cards then
			Multiverse.increment_transmute_progress(card, #context.removed)
		end
	end,
	transmutes_into = "j_mul_frozone",
	mul_grail = { "c_justice", "c_hanged_man", "c_immolate", "c_mul_lightsaber" },
	mul_tree_of_eden = { "j_trading" }, -- UPDATE LATER
})

SMODS.Joker({
	key = "dog",
	atlas = "placeholder",
	pos = { x = 0, y = 0 },
	config = { extra = { chips = 0, chip_inc = 5 } },
	transmute_req = Multiverse.set_transmute_requirements(10),
	rarity = 1,
	cost = 5,
	attributes = { "chips", "scaling", "destroy_cards" },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chip_inc,
				card.ability.extra.chips,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
			local cards = Multiverse.filter(G.consumeables.cards, function (item)
				return not SMODS.is_eternal(item, card)
			end)
			if #cards > 0 then
				SMODS.scale_card(card, {
					ref_value = "chips",
					scalar_table = { card.ability.extra.chip_inc * #cards },
					scalar_value = 1,
				})
				SMODS.destroy_cards(cards)
			end
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
	end,
})