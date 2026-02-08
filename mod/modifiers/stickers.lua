SMODS.Sticker({
	key = "transmutable",
	atlas = "transmutable_sticker",
	pos = { x = 0, y = 0 },
	badge_colour = Multiverse.C.TRANSMUTED_GRADIENT,
	rate = 0,
	default_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.mul_thaumaturgy_energy_per_joker or 10 } }
	end,
	sets = { Joker = true },
	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and not context.game_over and context.main_eval then
			Multiverse.ease_thaumaturgy_energy(G.GAME.mul_thaumaturgy_energy_per_joker, { from_charge = true })
			return {
				message = localize({
					type = "variable",
					key = "a_mul_thaumaturgy_energy",
					vars = { G.GAME.mul_thaumaturgy_energy_per_joker },
				}),
				colour = Multiverse.C.TRANSMUTED_GRADIENT,
			}
		end
	end,
})

SMODS.Sticker({
	key = "traitorous",
	atlas = "temp_sticker",
	pos = { x = 0, y = 0 },
	badge_colour = HEX("BF244C"),
	default_compat = true,
	needs_enabled_flag = true,
	sets = { Joker = true },
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			if G.jokers.cards[1] then
				SMODS.destroy_cards(G.jokers.cards[1], true)
			end
		end
	end,
})
