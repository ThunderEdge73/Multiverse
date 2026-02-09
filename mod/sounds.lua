SMODS.Sound({
	key = "gerson_laugh",
	path = "gerson_sfx.ogg",
})

SMODS.Sound({
	key = "prophecy_music",
	path = "Creo_Prophecy.ogg",
	select_music_track = function(self)
		if G.jokers and Multiverse.config.music["Prophecy"] then
			for _, joker in ipairs(G.jokers.cards) do
				if joker.ability.mul_transmutable then
					return 2
				end
			end
		end
	end,
	sync = {
		["music1"] = true,
		["music2"] = true,
		["music3"] = true,
		["music4"] = true,
		["music5"] = true,
	},
	volume = 0.5,
	pitch = 1,
})

SMODS.Sound({
	key = "pigstep_music",
	path = "LenaRaine_Pigstep.ogg",
	select_music_track = function(self)
		if G.jokers and Multiverse.config.music["Pigstep"] then
			if next(SMODS.find_card("j_mul_steve")) then
				return 3
			end
		end
	end,
	sync = false,
	volume = 0.6,
	pitch = 1,
})

SMODS.Sound({
	key = "lifewillchange_music",
	path = "P5_LifeWillChange.ogg",
	select_music_track = function(self)
		if G.jokers and Multiverse.config.music["Life Will Change"] then
			if next(SMODS.find_card("j_mul_ren_amamiya")) then
				return 3
			end
		end
	end,
	sync = false,
	volume = 0.6,
	pitch = 1,
})

SMODS.Sound({
	key = "hammerofjustice_music",
	path = "TobyFox_HammerOfJustice.ogg",
	select_music_track = function(self)
		if G.jokers and Multiverse.config.music["Hammer of Justice"] then
			if next(SMODS.find_card("j_mul_gerson")) then
				return 3
			end
		end
	end,
	sync = false,
	volume = 0.9,
	pitch = 1,
})

SMODS.Sound({
	key = "deltarune_explosion",
	path = "deltarune_explosion.ogg",
})

SMODS.Sound({
	key = "sneaky_snitch_music",
	path = "KevinMacleod_SneakySnitch.ogg",
	select_music_track = function(self)
		if G.jokers and Multiverse.config.music["Sneaky Snitch"] then
			if next(SMODS.find_card("j_mul_waldo")) then
				return 3
			end
		end
	end,
	sync = false,
	volume = 0.7,
	pitch = 1,
})

SMODS.Sound({
	key = "isolation_limbo",
	path = "NightHawk22_Isolation(LimboKeys).ogg",
})

SMODS.Sound({
	key = "silent_music",
	path = "silence.ogg",
	select_music_track = function(self)
		for _, vid in pairs(Multiverse.all_videos) do
			if vid.is_visible then
				return 42069
			end
		end
		if Multiverse.in_limbo and Multiverse.config.music["Isolation"] then
			return 69420
		end
	end,
	sync = false,
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
			and Multiverse.config.music["Battle Against a True Hero"]
		then
			return 4
		end
	end,
	sync = false,
	volume = 0.7,
	pitch = 1,
})

SMODS.Sound({
	key = "seek_music",
	path = "AmongUs_Seek.ogg",
	select_music_track = function(self)
		if G.jokers and Multiverse.config.music["Seek"] then
			if next(SMODS.find_card("j_mul_impostor")) then
				return 3
			end
		end
	end,
	sync = false,
	volume = 0.7,
	pitch = 1,
})

SMODS.Sound({
	key = "TF2_main_theme_music",
	path = "TF2_MainTheme.ogg",
	select_music_track = function(self)
		if G.jokers and Multiverse.config.music["Main Theme (TF2)"] then
			if next(SMODS.find_card("j_mul_heavy")) then
				return 3
			end
		end
	end,
	sync = false,
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