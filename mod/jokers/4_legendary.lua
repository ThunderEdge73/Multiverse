Multiverse.UsableJoker({
	key = "thunderedge",
	atlas = "contributors",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config = {
		extra = {
			tp_cost = 20,
			thaum_energy_cost = 20,
		},
	},
	rarity = 4,
	cost = 20,
	loc_vars = function(self, info_queue, card)
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
	calculate = function(self, card, context)
		if context.mul_TP_altered and context.amount < 0 then
			local num = math.floor(-context.amount / 2)
			G.E_MANAGER:add_event(Event({
				func = function()
					Multiverse.ease_TP(num)
					return true
				end,
			}))
		end
		if context.mul_thaumaturgy_energy_altered and context.amount < 0 then
			local num = math.floor(-context.amount / 2)
			G.E_MANAGER:add_event(Event({
				func = function()
					Multiverse.ease_thaumaturgy_energy(num)
					return true
				end,
			}))
		end
	end,
	can_use_ability = function(self, card)
		return G.GAME.mul_TP >= card.ability.extra.tp_cost
			and G.GAME.mul_thaumaturgy_energy >= card.ability.extra.thaum_energy_cost
	end,
	use_ability = function(self, card)
		Multiverse.effect_animation(card, function()
			Multiverse.ease_TP(-card.ability.extra.tp_cost)
			Multiverse.ease_thaumaturgy_energy(-card.ability.extra.thaum_energy_cost)
			add_tag(Tag("tag_mul_dimensional", false, "Small"))
		end)
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
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_inc,
				card.ability.extra.xmult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if not context.blueprint then
				local seen = {}
				for _, c in ipairs(context.full_hand) do
					if not seen[c:get_id()] then
						seen[c:get_id()] = true
					end
				end
				local amt = Multiverse.len(seen)
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "xmult",
					scalar_value = "xmult_inc",
				})
			end
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
})
