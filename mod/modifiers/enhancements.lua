SMODS.Enhancement({
	key = "calling_card",
	atlas = "calling_card",
	pos = { x = 0, y = 0 },
	config = { extra = { xmult = 0.75 } },
	replace_base_card = true,
	weight = 0,
	in_pool = function(self, args)
		return false
	end,
	update = function(self, card, dt)
		G.GAME.mul_call_card_anim_state = G.GAME.mul_call_card_anim_state or 0
		card.config.center.pos.x = math.floor(Multiverse.clamp(G.GAME.mul_call_card_anim_state, 0, 5))
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, 1 + card.ability.extra.xmult * (G.GAME.num_bosses_defeated or 0) } }
	end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			return {
				xmult = 1 + card.ability.extra.xmult * (G.GAME.num_bosses_defeated or 0),
			}
		end
	end,
})

SMODS.Enhancement({
	key = "netherite",
	atlas = "placeholder_modifiers",
	pos = { x = 0, y = 0 },
	config = { h_dollars = 5, extra = { xmult = 0.01 } },
	weight = 0,
	loc_vars = function(self, info_queue, card)
		local total = 0
		if G.GAME.dollars then
			total = total + G.GAME.dollars
		end
		if G.GAME.dollar_buffer then
			total = total + G.GAME.dollar_buffer
		end
		return { vars = { card.ability.extra.xmult, card.ability.h_dollars, 1 + total * card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.hand then
			return {
				xmult = 1 + card.ability.extra.xmult * (G.GAME.dollars + G.GAME.dollar_buffer),
			}
		end
	end,
})

SMODS.Enhancement({
	key = "normal",
	atlas = "placeholder_modifiers",
	pos = { x = 0, y = 0 },
	config = { bonus = 22 },
	weight = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.bonus } }
	end,
})

SMODS.Enhancement({
	key = "motivated",
	atlas = "placeholder_modifiers",
	pos = { x = 0, y = 0 },
	config = { extra = { retriggers = 1, odds = 4 } },
	weight = 5,
	loc_vars = function(self, info_queue, card)
		local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "mul_motivated")
		return { vars = { card.ability.extra.retriggers, num, denom } }
	end,
	calculate = function(self, card, context)
		if context.repetition then
			return {
				repetitions = card.ability.extra.retriggers,
			}
		end
		if context.after and SMODS.pseudorandom_probability(card, "mul_motivated", 1, card.ability.extra.odds) then
			card:set_ability("c_base", nil, true)
		end
	end,
})

SMODS.Enhancement({
	key = "waldo",
	atlas = "placeholder_modifiers",
	pos = { x = 0, y = 0 },
	config = { extra = { retrigger_inc = 1, cards_per_retrigger = 5 } },
	weight = 0,
	always_scores = true,
	no_rank = true,
	no_suit = true,
	replace_base_card = true,
	in_pool = function(self, args)
		return false
	end,
	loc_vars = function(self, info_queue, card)
		local num_triggers = 1
		if G.playing_cards then
			num_triggers = math.max(math.floor(#G.playing_cards / card.ability.extra.cards_per_retrigger), 1)
		end
		return { vars = { card.ability.extra.retrigger_inc, card.ability.extra.cards_per_retrigger, num_triggers } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			return {
				repetitions = card.ability.extra.retrigger_inc
					* math.max(math.floor(#G.playing_cards / card.ability.extra.cards_per_retrigger), 1),
			}
		end
	end,
})

SMODS.Enhancement({
	key = "sus_yellow",
	atlas = "placeholder_modifiers",
	pos = { x = 0, y = 0 },
	config = { extra = { count = 0, money = 1, max_count = 3 } },
	weight = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.max_count, card.ability.extra.count } }
	end,
	calculate = function(self, card, context)
		if context.discard and context.other_card == card and not context.other_card.debuff then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
			card.ability.extra.count = card.ability.extra.count + 1
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
				remove = card.ability.extra.count >= card.ability.extra.max_count and true or false,
			}
		end
	end,
})
