SMODS.Sound({
	key = "gerson_laugh",
	path = "gerson_sfx.ogg",
})

SMODS.Sound({
	key = "deltarune_explosion",
	path = "deltarune_explosion.ogg",
})

SMODS.Sound({
	key = "isolation_limbo",
	path = "NightHawk22_Isolation(LimboKeys).ogg",
})

SMODS.Sound({
	key = "silent_music",
	path = "silence.ogg",
	select_music_track = function(self)
		if (Multiverse.in_limbo and Multiverse.config.music["Isolation"]) or Multiverse.very_important_thing then
			return 69420
		end
	end,
	sync = setmetatable({}, {
		__index = function(_, _)
			return true
		end,
	}),
	volume = 0,
})

SMODS.Sound({
	key = "take_damage",
	path = "snd_hurt1.ogg",
})

SMODS.Sound({
	key = "block_spear",
	path = "snd_tempbell.ogg",
})

SMODS.Sound({
	key = "BAATH_music",
	path = "TobyFox_BAATH.ogg",
	select_music_track = function(self)
		if
			G.GAME.blind
			and G.GAME.blind.config.blind.key == "bl_mul_undying"
			and not G.GAME.blind.disabled
		then
			return 4
		end
	end,
	volume = 0.7,
	pitch = 1,
})

SMODS.Sound({
	key = "transmute1",
	path = "transmute1.ogg",
})

SMODS.Sound({
	key = "transmute2",
	path = "transmute2.ogg",
})

SMODS.Sound({
	key = "transmute3",
	path = "transmute3.ogg",
})

SMODS.Sound({
	key = "transmute_final",
	path = "transmute_final.ogg",
})

SMODS.Sound({
	key = "dimension_pack_music",
	path = "dimensional_pack.ogg",
	select_music_track = function(self)
		if
			G.booster_pack
			and not G.booster_pack.REMOVED
			and SMODS.OPENED_BOOSTER
			and (
				SMODS.OPENED_BOOSTER.config.center.kind == "mul_dimension"
				or SMODS.OPENED_BOOSTER.config.center.kind == "mul_skill"
			)
		then
			return 1
		end
	end,
	pitch = 1,
	sync = {
		music1 = true,
		music2 = true,
		music3 = true,
		music4 = true,
		music5 = true,
	},
})

SMODS.Sound({
	key = "exhaust",
	path = "exhaust.ogg",
})
