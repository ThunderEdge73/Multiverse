SMODS.Shader({
	key = "hyperdimensional",
	path = "hyperdimensional.fs",
})

SMODS.Edition({
	key = "hyperdimensional",
	shader = "hyperdimensional",
	config = {
		card_limit = 1,
		extra = {
			thaum_energy = 8,
			tp = 6,
		},
	},
	extra_cost = 6,
	weight = 4,
	in_shop = true,
	in_pool = function(self, args)
		if args and args.source == "sta" then
			return false
		end
		if G.jokers then
			for _, j in ipairs(G.jokers.cards) do
				if j:is_rarity("mul_transmuted") or j.ability.mul_transmutable then
					return true
				end
			end
		end
		return false
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.edition.card_limit, card.edition.extra.tp, card.edition.extra.thaum_energy } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and not context.game_over and context.main_eval then
			Wallet.mod_buffer("mul_tp", card.edition.extra.tp)
			Wallet.mod_buffer("mul_thaumaturgy_energy", card.edition.extra.thaum_energy)
			return {
				mul_thaumaturgy_energy = card.edition.extra.thaum_energy,
				mul_tp = card.edition.extra.tp,
				func = function()
					Wallet.reset_buffers("mul_tp", "mul_thaumaturgy_energy")
				end
			}
		end
	end,
})

SMODS.Shader({
	key = "almighty",
	path = "almighty.fs",
})

SMODS.Edition({
	key = "almighty",
	shader = "almighty",
	extra_cost = 6,
	weight = 3,
	in_shop = false,
	config = { extra = { xscore = 1.1 } },
	calculate = function(self, card, context)
		if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
			return {
				xscore = card.edition.extra.xscore,
			}
		end
		if context.debuff_card == card then
			return {
				prevent_debuff = true,
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.edition.extra.xscore,
			},
		}
	end,
})
