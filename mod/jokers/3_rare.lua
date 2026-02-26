SMODS.Joker({
	key = "bloodbath",
	atlas = "placeholder",
	pos = { x = 2, y = 0 },
	config = { extra = { xmult = 1.9 } },
	rarity = 3,
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if G.GAME.current_round.hands_left == 0 then
				return {
					xmult = card.ability.extra.xmult,
				}
			end
		end
	end,
})

SMODS.Joker({
	key = "antimatter",
	atlas = "placeholder",
	pos = { x = 2, y = 0 },
	config = { extra = { mult = 1, dim1 = 1, dim2 = 1, rounds_held = 0 } },
	rarity = 3,
	perishable_compat = false,
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end
		if context.end_of_round and context.main_eval and not context.blueprint and not context.game_over then
			card.ability.extra.rounds_held = card.ability.extra.rounds_held + 1
			local msg
			if card.ability.extra.rounds_held == 1 then
				msg = localize("k_mul_antimatter_init")
			elseif card.ability.extra.rounds_held <= 3 then
				msg = localize("k_mul_antimatter_grow1")
			elseif card.ability.extra.rounds_held <= 6 then
				card.ability.extra.dim2 = 2
				msg = localize("k_mul_antimatter_grow2")
			elseif card.ability.extra.rounds_held <= 10 then
				card.ability.extra.dim2 = card.ability.extra.dim2 + 1
				msg = localize("k_mul_antimatter_grow3")
			else
				card.ability.extra.dim2 = card.ability.extra.dim2 + card.ability.extra.rounds_held - 9
				msg = localize("k_mul_antimatter_grow4")
			end
			card.ability.extra.dim1 = card.ability.extra.dim1 + card.ability.extra.dim2
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "mult",
				scalar_value = "dim1",
			})
			return { message = msg }
		end
	end,
})

SMODS.Joker({
	key = "stand_user",
	atlas = "placeholder",
	pos = { x = 2, y = 0 },
	config = { extra = { ante_change = 1, in_boss = false } },
	rarity = 3,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { -card.ability.extra.ante_change } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if G.GAME.blind then
			card.ability.extra.in_boss = G.GAME.blind.boss
		end
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.extra.in_boss = context.blind.boss
		end
		if
			context.end_of_round
			and context.game_over
			and context.main_eval
			and card.ability.extra.in_boss
		then
			ease_ante(-card.ability.extra.ante_change)
			G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
			G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.extra.ante_change
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.destroy_cards(card)
					return true
				end,
			}))
			return {
				message = localize("k_saved_ex"),
				saved = "mul_stand_user",
				colour = G.C.RED,
			}
		end
	end,
})

SMODS.Joker({
	key = "dragon",
	atlas = "placeholder",
	pos = { x = 2, y = 0 },
	transmute_req = Multiverse.set_transmute_requirements(25),
	config = {
		extra = {
			xmult = 1,
			xmult_inc = 0.5,
			transmute_progress = 0,
		},
	},
	rarity = 3,
	cost = 8,
	loc_vars = function(self, info_queue, card)
		Multiverse.transmute_info_queue(card, info_queue)
		table.insert(info_queue, G.P_CENTERS.m_gold)
		table.insert(info_queue, G.P_CENTERS.m_steel)
		table.insert(info_queue, G.P_CENTERS.m_stone)
		return {
			vars = { card.ability.extra.xmult_inc, card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if not context.blueprint then
			if context.mul_dragon_transmute_check or context.playing_card_added then
				local amt = 1
				if context.cards then
					amt = 0
					for _, c in ipairs(context.cards) do
						if
							SMODS.has_enhancement(c, "m_stone")
							or SMODS.has_enhancement(c, "m_steel")
							or SMODS.has_enhancement(c, "m_gold")
						then
							amt = amt + 1
						end
					end
				end
				if amt > 0 then
					Multiverse.increment_transmute_progress(card, amt)
				end
			end
			if context.discard and context.other_card:get_id() == 13 then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "xmult",
					scalar_value = "xmult_inc",
				})
				return {
					remove = true,
				}
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
	pools = { ["mul_can_transmute"] = true },
	transmutes_into = "j_mul_steve",
	mul_grail = { "c_tower", "c_chariot", "c_devil" },
	mul_tree_of_eden = { "j_midas_mask", "j_marble" },
})

local set_ability_hook = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
	if
		self.playing_card
		and (center.key == "m_stone" or center.key == "m_steel" or center.key == "m_gold")
		and self.config.center_key ~= center.key
	then
		SMODS.calculate_context({ mul_dragon_transmute_check = true })
	end
	set_ability_hook(self, center, initial, delay_sprites)
end
