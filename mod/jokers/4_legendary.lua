Multiverse.UsableJoker({
	key = "thunderedge",
	atlas = "contributors",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config = {
		extra = {
			tp_cost = 20,
			thaum_energy_cost = 20,
			transmute_progress = 0
		},
	},
	rarity = 4,
	cost = 20,
	blueprint_compat = false,
	attributes = { "usable", "tp", "thaumaturgy_energy", "tag", "transmutable" },
	transmute_req = Multiverse.set_transmute_requirements(15),
	transmutes_into = "j_mul_thunderedge_awakened",
	mul_grail = { "c_strength", "c_lovers", "c_sun", "c_moon", "c_star", "c_world" },
	mul_tree_of_eden = { "j_smeared" },
	loc_vars = function(self, info_queue, card)
		Multiverse.transmute_info_queue(card, info_queue)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_thunderedge_ability",
			vars = {
				card.ability.extra.tp_cost,
				card.ability.extra.thaum_energy_cost,
			},
		})
		info_queue[#info_queue + 1] = G.P_TAGS["tag_mul_dimensional"]
	end,
	can_use = function(self, card)
		return G.GAME.mul_TP >= card.ability.extra.tp_cost
			and G.GAME.mul_thaumaturgy_energy >= card.ability.extra.thaum_energy_cost
	end,
	use = function(self, card)
		Multiverse.effect_animation(card, function()
			Multiverse.ease_TP(-card.ability.extra.tp_cost)
			Multiverse.ease_thaumaturgy_energy(-card.ability.extra.thaum_energy_cost)
			add_tag(Tag("tag_mul_dimensional", false, "Small"))
		end)
	end,
	calculate = function (self, card, context)
		if context.before and next(context.poker_hands["mul_storm"]) then
			Multiverse.increment_transmute_progress(card, 1)
		end
	end
})

function Multiverse.calculate_singularity_values()
	local chips = 0
	local xmult = 1
	local right_hand_found = false
	local left_hand_found = false
	if G.hand then
		for _, card in ipairs(G.hand.cards) do
			if SMODS.has_enhancement(card, "m_mul_right_hand") then
				right_hand_found = true
				chips = Multiverse.calculate_right_hand_chips(card)
			end
			if SMODS.has_enhancement(card, "m_mul_left_hand") then
				left_hand_found = true
				xmult = Multiverse.calculate_left_hand_xmult(card)
			end
		end
	end
	return { chips, xmult }, (right_hand_found and left_hand_found)
end

Multiverse.UsableJoker({
	key = "thunderedge_awakened",
	atlas = "contributors",
	pos = { x = 0, y = 1 },
	soul_pos = { x = 1, y = 1 },
	config = {
		extra = { tp_cost = 25 },
	},
	rarity = "mul_transmuted",
	cost = 50,
	blueprint_compat = false,
	attributes = { "usable" },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_left_hand"]
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_right_hand"]
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_intangible"]
		local vars, _ = Multiverse.calculate_singularity_values()
		table.insert(vars, 1, card.ability.extra.tp_cost)
		info_queue[#info_queue + 1] = {
			set = "Other",
			key = "mul_thunderedge_awakened_ability",
			vars = vars,
		}
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_singularity"]
	end,
	can_use = function(self, card)
		local _, found = Multiverse.calculate_singularity_values()
		return G.GAME.mul_TP >= card.ability.extra.tp_cost and found
	end,
	use = function(self, card)
		Multiverse.effect_animation(card, function()
			Multiverse.ease_TP(-card.ability.extra.tp_cost)
			local singularity_vals = Multiverse.calculate_singularity_values()
			local cards_to_destroy = Multiverse.filter(G.hand.cards, function(item)
				return not (
					SMODS.has_enhancement(item, "m_mul_right_hand") or SMODS.has_enhancement(item, "m_mul_left_hand")
				)
			end)
			SMODS.destroy_cards(cards_to_destroy)
			G.E_MANAGER:add_event(Event({
				func = function()
					local singularity_card = SMODS.add_card({ key = "m_mul_singularity", no_edition = true })
					singularity_card.ability.extra.chips = singularity_vals[1]
					singularity_card.ability.extra.xmult = singularity_vals[2]
					G.STATE = G.STATES.DRAW_TO_HAND
					G.STATE_COMPLETE = false
					G.E_MANAGER:add_event(Event({
						func = function()
							G.STATE_COMPLETE = true
							G.STATE = G.STATES.SELECTING_HAND
							return true
						end
					}))
					return true
				end,
			}))
		end)
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local l_card = SMODS.create_card({ key = "m_mul_left_hand", no_edition = true, area = G.hand })
			G.playing_card = (G.playing_card or 0) + 1
			l_card.playing_card = G.playing_card
			table.insert(G.playing_cards, l_card)
			local r_card = SMODS.create_card({ key = "m_mul_right_hand", no_edition = true, area = G.hand })
			G.playing_card = (G.playing_card or 0) + 1
			r_card.playing_card = G.playing_card
			table.insert(G.playing_cards, r_card)
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand:emplace(l_card, "front")
					G.hand:emplace(r_card)
					l_card:start_materialize()
					r_card:start_materialize(nil, true)
					G.GAME.blind:debuff_card(l_card)
					G.GAME.blind:debuff_card(r_card)
					G.hand:sort()
					card:juice_up()
					SMODS.calculate_context({ playing_card_added = true, cards = { l_card, r_card } })
					save_run()
					return true
				end,
			}))
			return {
				message = localize("k_mul_manifested")
			}
		end
	end,
})

SMODS.Joker({
	key = "proto",
	atlas = "contributors",
	pos = { x = 2, y = 0 },
	soul_pos = { x = 3, y = 0 },
	config = {
		extra = {
			xmult = 1,
			xmult_inc = 0.1,
		},
	},
	rarity = 4,
	cost = 20,
	attributes = { "xmult", "scaling" },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_inc,
				card.ability.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local seen = {}
			for _, c in ipairs(context.scoring_hand) do
				if not seen[c:get_id()] then
					seen[c:get_id()] = true
				end
			end
			local amt = Multiverse.len(seen)
			for _ = 1, amt do
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "xmult",
					scalar_value = "xmult_inc",
				})
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})

SMODS.Joker({
	key = "sleepy",
	atlas = "contributors",
	pos = { x = 4, y = 0 },
	soul_pos = { x = 5, y = 0 },
	rarity = 4,
	cost = 20,
	blueprint_compat = false,
	attributes = { "balance" },
	calculate = function(self, card, context)
		if context.initial_scoring_step or context.final_scoring_step then
			return {
				balance = true,
			}
		end
	end,
})
