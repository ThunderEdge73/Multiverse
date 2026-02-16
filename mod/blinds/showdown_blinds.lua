-- SMODS.Blind({
--     key = "stormterror",
--     atlas = "placeholder_blind",
--     pos = { x = 0, y = 0 },
--     boss_colour = HEX("F2994B"),

-- })


SMODS.Blind({
	key = "spire_shield",
	dollars = 8,
	passives = {
		"psv_mul_artifact",
		"psv_mul_bulky",
	},
	modifies_draw = true,
	atlas = "blind_placeholder",
	pos = { x = 0, y = 0 },
	boss_colour = mix_colours(G.C.BLUE, G.C.BLACK, 0.7),
	boss = { showdown = true },
	mult = 2,
	no_collection = not Multiverse.config.debug,
	summon = "bl_mul_spire_spear",
	precedes_original = true,
	phase_refresh = true,
	summon_while_disabled = true,
})

SMODS.Blind({
	key = "spire_spear",
	dollars = 8,
	passives = {
		"psv_mul_artifact",
		"psv_mul_surrounding",
	},
	modifies_draw = true,
	atlas = "blind_placeholder",
	pos = { x = 0, y = 0 },
	boss_colour = mix_colours(G.C.BLUE, G.C.BLACK, 0.7),
	boss = { showdown = true },
	mult = 2,
	no_collection = true,
	in_pool = function(self)
		return false
	end,
	summon = "bl_mul_corrupt_heart",
	precedes_original = true,
	phase_refresh = true,
	summon_while_disabled = true,
})

SMODS.Blind({
	key = "corrupt_heart",
	dollars = 8,
	passives = {
		"psv_mul_artifact",
		"psv_mul_invincible",
		"psv_mul_beat_of_death",
		"psv_mul_debilitate",
	},
	debuff = {
		mul_immutable = true,
	},
	modifies_draw = true,
	atlas = "blind_placeholder",
	pos = { x = 0, y = 0 },
	boss_colour = mix_colours(G.C.BLUE, G.C.BLACK, 0.7),
	boss = { showdown = true },
	mult = 2,
	in_pool = function(self)
		return false
	end,
	phase_refresh = true,
})
