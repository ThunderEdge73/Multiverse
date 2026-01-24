Multiverse.DummyCenters = {}
Multiverse.DummyCenter = SMODS.Center:extend({
	set = "mul_Dummy",
	obj_buffer = {},
	obj_table = Multiverse.DummyCenters,
	required_params = {
		"key",
	},
	class_prefix = "du",
	in_pool = function(self, args)
		return false
	end,
	no_collection = true,
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end
})

Multiverse.DummyCenter({
	key = "all_enchants",
	loc_vars = function(self, info_queue, card)
		if G.GAME.mul_deck_enchantments then
			for _, key in ipairs(Multiverse.DeckEnchantment.obj_buffer) do
				if Multiverse.DeckEnchantments[key]:get_level() > 0 then
					info_queue[#info_queue + 1] = Multiverse.DeckEnchantments[key]
				end
			end
		end
	end,
})

Multiverse.DummyCenter({
	key = "half",
	loc_vars = function(self, info_queue, card)
		num, denom = SMODS.get_probability_vars(nil, 1, 4, "mul_half_card_discard")
		return {
			vars = {
				0.5,
				num,
				denom,
			},
		}
	end,
})

Multiverse.DummyCenter({
	key = "half_left",
	loc_vars = function(self, info_queue, card)
		num, denom = SMODS.get_probability_vars(nil, 1, 4, "mul_half_card_discard")
		return {
			vars = {
				num,
				denom,
			},
		}
	end,
})

Multiverse.DummyCenter({
	key = "half_right",
	loc_vars = function(self, info_queue, card)
		num, denom = SMODS.get_probability_vars(nil, 1, 4, "mul_half_card_discard")
		return {
			vars = {
				num,
				denom,
			},
		}
	end,
})

Multiverse.DummyCenter({
	key = "exhausted",
})

Multiverse.DummyCenter({
	key = "skill_cost_num",
})

Multiverse.DummyCenter({
	key = "skill_cost_x",
})

Multiverse.DummyCenter({
	key = "exhaust",
})

Multiverse.DummyCenter({
	key = "ultimate",
})