function Multiverse.blind_instructions_HUD_def(key)
	return {
		n = G.UIT.ROOT,
		config = {
			padding = 0.05,
			colour = lighten(G.C.JOKER_GREY, 0.5),
			align = "cm",
			r = 0.1,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = { padding = 0.05, colour = G.C.L_BLACK, align = "cm", r = 0.1, emboss = 0.05 },
				nodes = Multiverse.create_localized_rows("Other", "mul_" .. key .. "_inst"),
			},
		},
	}
end

function Multiverse.show_blind_instructions(key)
	if G.mul_blind_instructions then
		G.mul_blind_instructions:remove()
		G.mul_blind_instructions = nil
	end
	G.mul_blind_instructions = UIBox({
		definition = Multiverse.blind_instructions_HUD_def(key),
		config = { align = "cr", offset = { x = 0.1, y = 0 }, major = G.blind_passive, instance_type = "CARD" },
	})
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
end

function Multiverse.hide_blind_instructions()
	if G.mul_blind_instructions then
		G.mul_blind_instructions:remove()
		G.mul_blind_instructions = nil
	end
end

local blind_hover_hook = Blind.hover
function Blind:hover()
	blind_hover_hook(self)
	if G.blind_passive and Multiverse.HOVER_HINT_KEY then
		Multiverse.show_blind_instructions(Multiverse.HOVER_HINT_KEY)
	end
end

local stop_blind_hover_hook = Blind.stop_hover
function Blind:stop_hover()
	stop_blind_hover_hook(self)
	Multiverse.hide_blind_instructions()
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
		Multiverse.HOVER_HINT_KEY = "limbo"
	end,
	calculate = function(self, blind, context)
		if context.press_play and not blind.disabled and G.GAME.current_round.hands_played == 0 then
			Multiverse.limbo_set_effect()
		end
	end,
	defeat = function(self)
		G.GAME.failed_limbo = false
		Multiverse.HOVER_HINT_KEY = nil
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
		Multiverse.HOVER_HINT_KEY = "undying"
	end,
	defeat = function(self)
		Multiverse.apply_to_playing_cards(function(playing_card)
			SMODS.debuff_card(playing_card, false, "mul_undying")
		end)
		Multiverse.HOVER_HINT_KEY = nil
	end,
	disable = function(self)
		if G.GAME.chips < to_big(0) then
			G.GAME.chips = to_big(0)
		end
		Multiverse.apply_to_playing_cards(function(playing_card)
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
