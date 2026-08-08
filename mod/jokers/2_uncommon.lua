SMODS.Joker({
	key = "cataclysm",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	config = { extra = { mult = 19 } },
	rarity = 2,
	cost = 6,
	attributes = { "mult", "hands" },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if G.GAME.current_round.hands_left == 0 then
				return {
					mult = card.ability.extra.mult,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "magic_school_bus",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	config = { extra = { mult = 0, mult_inc = 1 } },
	rarity = 2,
	perishable_compat = false,
	cost = 6,
	attributes = { "mult", "scaling", "reset" },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_inc,
				card.ability.extra.mult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and context.main_eval and not context.game_over then
			local has_face_card = false
			for _, playing_card in ipairs(G.hand.cards) do
				if playing_card:is_face(true) then
					G.E_MANAGER:add_event(Event({
						func = function()
							playing_card:juice_up()
							return true
						end,
					}))
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "mult",
						scalar_value = "mult_inc",
					})
					has_face_card = true
				end
			end
			if not has_face_card then
				SMODS.reset_card(card, { ref_value = "mult", reset_message = localize("k_mul_missed_bus") })
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
	end,
})

SMODS.Joker({
	key = "summoned_skull",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	config = { extra = { xmult = 2.5 } },
	rarity = 2,
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	attributes = { "xmult", "destroy_card" },
	calculate = function(self, card, context)
		if context.buying_card and context.card == card and G.jokers and not context.blueprint then
			local pool = {}
			for _, c in ipairs(G.jokers.cards) do
				if c ~= card then
					pool[#pool + 1] = c
				end
			end
			local joker_to_destroy = pseudorandom_element(pool, "mul_summoned_skull")
			SMODS.destroy_cards(joker_to_destroy)
		end
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
})

SMODS.Joker({
	key = "fifty_fifty",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	config = { extra = { xmult = 3, mult = 3, odds = 2 } },
	rarity = 2,
	cost = 6,
	attributes = { "xmult", "chance", "mult" },
	loc_vars = function(self, info_queue, card)
		local num, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "mul_fifty_fifty")
		return { vars = { num, denom, card.ability.extra.xmult, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if SMODS.pseudorandom_probability(card, "mul_fifty_fifty", 1, card.ability.extra.odds) then
				return {
					xmult = card.ability.extra.xmult,
					message = localize("k_mul_won_fifty_fifty"),
				}
			else
				return {
					mult = card.ability.extra.mult,
					message = localize("k_mul_lost_fifty_fifty"),
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "victory_royale",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	config = { immutable = { req = 100, current = 0, increment = 1 } },
	rarity = 2,
	cost = 7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return { vars = { card.ability.immutable.req, card.ability.immutable.req - card.ability.immutable.current } }
	end,
	attributes = { "spectral", "generation" },
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if card.ability.immutable.current >= card.ability.immutable.req then
				G.GAME.consumeable_buffer = (G.GAME.consumeable_buffer or 0) + 1
				card.ability.immutable.current = 0
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.add_card({
							set = "Spectral",
							edition = "e_negative",
							key_append = "mul_victory_royale",
						})
						G.GAME.consumeable_buffer = 0
						return true
					end,
				}))
				return {
					message = localize("k_plus_spectral"),
					colour = G.C.SECONDARY_SET.Spectral,
				}
			else
				card.ability.immutable.current = card.ability.immutable.current + card.ability.immutable.increment
			end
		end
	end,
})

SMODS.Joker({
	key = "hammer_bro",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	transmute_req = Multiverse.set_transmute_requirements(150),
	config = {
		extra = {
			mult = 5,
			xmult = 1.25,
			transmute_progress = 0,
		},
	},
	rarity = 2,
	cost = 7,
	attributes = { "xmult", "chance", "mult", "transmutable" },
	loc_vars = function(self, info_queue, card)
		Multiverse.transmute_info_queue(card, info_queue)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if not context.blueprint then
				Multiverse.increment_transmute_progress(card, 1)
			end
			if pseudorandom("hammer_bro", 1, 2) == 1 then
				return { xmult = card.ability.extra.xmult }
			else
				return { mult = card.ability.extra.mult }
			end
		end
	end,
	transmutes_into = "j_mul_gerson",
	mul_grail = { "c_deja_vu", "c_mul_chair" },
	mul_tree_of_eden = { "j_hanging_chad", "j_hack", "j_sock_and_buskin", "j_selzer" },
})

SMODS.Joker({
	key = "arms_dealer",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	transmute_req = Multiverse.set_transmute_requirements(250),
	config = { extra = { transmute_progress = 0 } },
	rarity = 2,
	cost = 7,
	loc_vars = function(self, info_queue, card)
		Multiverse.transmute_info_queue(card, info_queue)
	end,
	attributes = { "destroy_card", "transmutable" },
	calculate = function(self, card, context)
		if not context.blueprint and context.money_altered and context.from_shop and context.amount < 0 then
			Multiverse.increment_transmute_progress(card, -context.amount)
		end
		if context.before and #G.hand.cards > 0 then
			SMODS.destroy_cards(pseudorandom_element(G.hand.cards, "mul_arms_dealer"))
			return {
				message = localize("k_mul_boom"),
			}
		end
	end,
	transmutes_into = "j_mul_heavy",
	mul_grail = { "c_immolate", "c_hermit", "c_temperance" },
	mul_tree_of_eden = { "j_golden", "j_cloud_9", "j_satellite", "j_todo_list", "j_mul_red_bloon", "j_mul_slime" },
})

SMODS.Joker({
	key = "is",
	atlas = "placeholder",
	pos = { x = 1, y = 0 },
	rarity = 2,
	cost = 7,
	loc_vars = function(self, info_queue, card)
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
	attributes = { "copying" },
	calculate = function(self, card, context)
		
	end,
})
