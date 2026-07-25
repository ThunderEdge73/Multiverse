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
	key = "exhausts",
})

Multiverse.DummyCenter({
	key = "ultimate",
})

Multiverse.DummyCenter({
	key = "retain",
})

Multiverse.DummyCenter({
	key = "impervious",
})

Multiverse.DummyCenter({
	key = "impulse",
})

Multiverse.DummyCenter({
	key = "ethereal",
})

Multiverse.DummyCenter({
	key = "thaumaturgy_energy_info",
	loc_vars = function(self, info_queue, card)
		local key = "mul_thaumaturgy_gain_desc"
		if G.GAME.mul_thaumaturgy_energy_rate < 0 then
			key = "mul_thaumaturgy_loss_desc"
		end
		return {
			set = "Other",
			key = key,
			vars = {
				math.abs(G.GAME.mul_thaumaturgy_energy_rate),
			},
		}
	end,
})

Multiverse.DummyCenter({
	key = "tp_info",
	loc_vars = function(self, info_queue, card)
		local key = "mul_tp_desc"
		if not Multiverse.joke_TP_desc_triggered and math.random(1, 500) == 1 then
			key = "mul_tp_desc_joke1"
			Multiverse.joke_TP_desc_triggered = true
		elseif Multiverse.joke_TP_desc_triggered then
			key = "mul_tp_desc_joke2"
		end
		Multiverse.joke_TP_desc_triggered = false
		return {
			set = "Other",
			key = key,
			vars = {
				G.GAME.mul_tp_min_gain,
				G.GAME.mul_tp_max_gain,
			},
		}
	end,
})

Multiverse.DummyCenter({
	key = "emptied",
})

Multiverse.DummyCenter({
	key = "sneaky",
})

Multiverse.DummyCenter({
	key = "priority",
})

Multiverse.DummyCenter({
	key = "innate",
})

Multiverse.DummyCenter({
	key = "buried",
})
