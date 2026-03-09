function Multiverse.show_blind_instructions(key)
	if G.mul_blind_instructions then
		G.mul_blind_instructions:remove()
		G.mul_blind_instructions = nil
	end
	G.mul_blind_instructions = UIBox({
		definition = Multiverse.blind_instructions_HUD_def(key),
		config = { align = "cri", offset = { x = 5.3, y = 0.5 }, major = G.ROOM_ATTACH, instance_type = "CARD" },
	})
	ease_value(G.mul_blind_instructions.config.offset, "x", -4, nil, "REAL", true, 0.125, "inquad")
	G.mul_blind_instructions:recalculate()
end

function Multiverse.init_blinds()
	---@type number
	G.GAME.mul_undyne_damage_mult = 1

	Multiverse.in_undyne = false
	Multiverse.undyne_spears = {}
	Multiverse.in_limbo = nil

	if G.GAME.challenge == "c_mul_monsoon" then
		G.GAME.mul_undyne_damage_mult = 2
	end
	if
		G.GAME.blind
		and G.GAME.facing_blind
		and not G.GAME.blind.disabled
		and G.GAME.blind.config.blind.mul_minigame
	then
		G.E_MANAGER:add_event(Event({
			func = function()
				Multiverse.show_blind_instructions(G.GAME.blind.config.blind.mul_minigame)
				return true
			end,
		}))
	end
end

function Multiverse.hide_blind_instructions()
	if G.mul_blind_instructions then
		ease_value(G.mul_blind_instructions.config.offset, "x", 4, nil, "REAL", true, 0.125, "outquad")
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 1,
			blocking = false,
			blockable = false,
			func = function()
				G.mul_blind_instructions:remove()
				G.mul_blind_instructions = nil
				return true
			end,
		}))
	end
end

function Multiverse.limbo_set_effect()
	Multiverse.dark_bg_active = true
	Multiverse.limbo_finished = false
	ease_value(Multiverse, "dark_bg_percent", -1, nil, "REAL", true, 0.5)
	Multiverse.in_limbo = "pre_start"
	if pseudorandom("mul_limbo", 1, 1000) < 8 then
		Multiverse.secret_limbo = true
		Multiverse.HIDDEN_KEY_COLOR = { 1, 1, 1, 1 }
	else
		Multiverse.secret_limbo = false
		Multiverse.HIDDEN_KEY_COLOR = { 224 / 255, 85 / 255, 32 / 255, 1 }
	end
	Multiverse.add_limbo_keys()
	Multiverse.limbo_keys_intro()
	G.E_MANAGER:add_event(Event({
		trigger = "immediate",
		func = function()
			return Multiverse.limbo_finished
		end,
	}))
end

SMODS.Blind({
	key = "limbo",
	passives = {
		"psv_mul_memorization",
		"psv_mul_unsightreadable",
	},
	atlas = "multiverse_blinds",
	mul_minigame = "limbo",
	pos = { x = 0, y = 0 },
	boss_colour = HEX("F2994B"),
	boss = { min = 3 },
	mult = 2,
	set_blind = function(self)
		Multiverse.show_blind_instructions("limbo")
	end,
	calculate = function(self, blind, context)
		if context.press_play and not blind.disabled and G.GAME.current_round.hands_played == 0 then
			Multiverse.limbo_set_effect()
		end
	end,
	disable = function(self)
		Multiverse.hide_blind_instructions()
	end,
	defeat = function(self)
		G.GAME.failed_limbo = false
	end,
})

function Multiverse.undying_press_play_effect(index)
	Multiverse.undyne_spears = {}
	Multiverse.in_undyne = true
	Multiverse.dark_bg_active = true
	Multiverse.shield_dir = "up"
	ease_value(Multiverse, "dark_bg_percent", -1, nil, "REAL", true, 0.5)
	Multiverse.start_undyne_attack(nil, index)
	G.E_MANAGER:add_event(Event({
		trigger = "immediate",
		func = function()
			return not Multiverse.in_undyne
		end,
	}))
end

SMODS.Blind({
	key = "undying",
	passives = {
		"psv_mul_determination",
		"psv_mul_justice",
	},
	mul_minigame = "undying",
	atlas = "multiverse_blinds",
	pos = { x = 0, y = 1 },
	boss_colour = lighten(G.C.BLACK, 0.1),
	boss = { min = 1 },
	mult = 2,
	press_play = function(self)
		Multiverse.undying_press_play_effect()
	end,
	set_blind = function(self)
		Multiverse.show_blind_instructions("undying")
	end,
	defeat = function (self)
		Multiverse.apply_to_playing_cards(function (playing_card)
			SMODS.debuff_card(playing_card, false, "mul_undying")
		end)
	end,
	disable = function(self)
		if G.GAME.chips < to_big(0) then
			G.GAME.chips = to_big(0)
		end
		Multiverse.apply_to_playing_cards(function (playing_card)
			SMODS.debuff_card(playing_card, false, "mul_undying")
		end)
		Multiverse.hide_blind_instructions()
	end,
})

SMODS.Blind({
	key = "time_eater",
	passives = {
		"psv_mul_time_warp",
		"psv_mul_draw_reduction",
	},
	atlas = "blind_placeholder",
	pos = { x = 0, y = 0 },
	boss_colour = lighten(G.C.PURPLE, 0.1),
	boss = { min = 5 },
	mult = 2,
})
