function Multiverse.show_blind_instructions(key)
	if G.mul_blind_instructions then
		G.mul_blind_instructions:remove()
		G.mul_blind_instructions = nil
	end
	G.mul_blind_instructions = UIBox({
		definition = Multiverse.blind_instructions_HUD_def(key),
		config = { align = "cri", offset = { x = 5.3, y = 0.5 }, major = G.ROOM_ATTACH, instance_type = "NODE" },
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
	Multiverse.show_blind_instructions("limbo")
	Multiverse.in_limbo = "pre_start"
	if pseudorandom("mul_limbo", 1, 1000) < 8 then
		Multiverse.secret_limbo = true
		Multiverse.HIDDEN_KEY_COLOR = { 1, 1, 1, 1 }
	else
		Multiverse.secret_limbo = false
		Multiverse.HIDDEN_KEY_COLOR = { 224 / 255, 85 / 255, 32 / 255, 1 }
	end
	Multiverse.add_limbo_keys()
	ease_background_colour_blind(G.STATES.BLIND_SELECT)
	attention_text({
		scale = 0.7,
		text = localize({ type = "variable", key = "a_mul_limbo_popup", vars = { 10 } }),
		hold = G.SPEEDFACTOR * 2.4,
		align = "cm",
		offset = { x = 0, y = -1 },
		major = G.play,
	})
	delay(2 * G.SPEEDFACTOR)
	G.E_MANAGER:add_event(Event({
		func = function()
			Multiverse.limbo_keys_intro()
			return true
		end,
	}))
	delay(18.6 * G.SPEEDFACTOR)
end

SMODS.Blind({
	key = "limbo",
	dependencies = { "blindexpander" },
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
		Multiverse.limbo_set_effect()
	end,
	disable = function(self)
		if G.GAME.failed_limbo then
			Multiverse.change_blind_size(function(chips)
				return chips / 5
			end)
			for i = 1, #G.hand.cards do
				if G.hand.cards[i].facing == "back" then
					G.hand.cards[i]:flip()
				end
			end
			for _, playing_card in pairs(G.playing_cards) do
				playing_card.ability.wheel_flipped = nil
			end
		end
		Multiverse.hide_blind_instructions()
	end,
	calculate = function(self, blind, context)
		if not blind.disabled and G.GAME.failed_limbo then
			if
				context.stay_flipped
				and context.to_area == G.hand
				and G.GAME.current_round.hands_played == 0
				and G.GAME.current_round.discards_used == 0
			then
				return {
					stay_flipped = true,
				}
			end
		end
	end,
	defeat = function(self)
		G.GAME.failed_limbo = false
	end,
})

function Multiverse.undying_press_play_effect(index)
	Multiverse.undyne_spears = {}
	Multiverse.in_undyne = true
	local num_attacks = Multiverse.start_undyne_attack(nil, index)
	G.E_MANAGER:add_event(Event({
		trigger = "immediate",
		func = function()
			if
				Multiverse.undyne_spears[num_attacks]
				and not Multiverse.undyne_spears[num_attacks].active
				and Multiverse.in_undyne
			then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					blockable = false,
					blocking = false,
					delay = 0.5 * G.SPEEDFACTOR,
					func = function()
						Multiverse.in_undyne = false
						return true
					end,
				}))
			end
			return not Multiverse.in_undyne
		end,
	}))
end

SMODS.Blind({
	key = "undying",
	dependencies = { "blindexpander" },
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
		if not G.GAME.blind.disabled then
			Multiverse.undying_press_play_effect()
		end
	end,
	set_blind = function(self)
		Multiverse.show_blind_instructions("undying")
		if G.GAME.round_resets.ante > 8 then
			self.passives[#self.passives + 1] = "psv_mul_undying_extra"
		end
	end,
	disable = function(self)
		if G.GAME.chips < to_big(0) then
			G.GAME.chips = to_big(0)
		end
		Multiverse.hide_blind_instructions()
	end,
})

SMODS.Blind({
	key = "time_eater",
	dependencies = { "blindexpander" },
	passives = {
		"psv_mul_time_warp",
		"psv_mul_draw_reduction",
	},
	modifies_draw = true,
	atlas = "blind_placeholder",
	pos = { x = 0, y = 0 },
	boss_colour = lighten(G.C.PURPLE, 0.1),
	boss = { min = 5 },
	mult = 2,
	calculate = function(self, blind, context)
		if context.before then
			if #context.scoring_hand > 5 then
				G.GAME.mul_time_eater_count = 0
			end
		end
		if not blind.disabled then
			if context.drawing_cards and context.amount > 4 and blind.after_first_draw then
				return {
					cards_to_draw = 4,
				}
			end
		end
	end,
})

SMODS.Blind({
	key = "spire_shield",
	dollars = 8,
	dependencies = { "blindexpander" },
	passives = {
		"psv_mul_artifact",
		"psv_mul_bulky",
	},
	debuff = {
		mul_artifact = 1,
	},
	modifies_draw = true,
	atlas = "blind_placeholder",
	pos = { x = 0, y = 0 },
	boss_colour = mix_colours(G.C.BLUE, G.C.BLACK, 0.7),
	boss = { showdown = true },
	mult = 4,
	no_collection = true,
	disable = function(self)
		G.GAME.mul_disable_times = G.GAME.mul_disable_times + 1
		if G.GAME.mul_disable_times <= 1 then
			G.GAME.blind.disabled = false
		else
			Multiverse.change_blind_size(function(chips)
				return chips / 2
			end)
		end
	end,
	summon = "bl_mul_spire_spear",
	phase_refresh = true,
})

SMODS.Blind({
	key = "spire_spear",
	dollars = 8,
	dependencies = { "blindexpander" },
	passives = {
		"psv_mul_artifact",
		"psv_mul_surrounding",
	},
	debuff = {
		mul_artifact = 1,
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
	disable = function(self)
		G.GAME.mul_disable_times = G.GAME.mul_disable_times + 1
		if G.GAME.mul_disable_times <= 1 then
			G.GAME.blind.disabled = false
		end
	end,
	calculate = function(self, blind, context)
		if not blind.disabled and context.modify_scoring_hand and context.in_scoring then
			if
				context.other_card == context.scoring_hand[1]
				or context.other_card == context.scoring_hand[#context.scoring_hand]
			then
				return {
					remove_from_hand = true,
				}
			end
		end
	end,
	summon = "bl_mul_corrupt_heart",
	phase_refresh = true,
})

SMODS.Blind({
	key = "corrupt_heart",
	dollars = 8,
	dependencies = { "blindexpander" },
	passives = {
		"psv_mul_artifact",
		"psv_mul_invincible",
		"psv_mul_beat_of_death",
		"psv_mul_debilitate",
	},
	debuff = {
		mul_immutable = true,
		mul_artifact = 1,
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
	disable = function(self)
		Multiverse.apply_to_playing_cards(function(playing_card)
			SMODS.debuff_card(playing_card, false, "mul_corrupt_heart")
		end)
		Multiverse.apply_to_hand(function (playing_card)
			if playing_card.facing == "back" then
				playing_card:flip()
			end
		end)
	end,
	calculate = function(self, blind, context)
		if not blind.disabled then
			if context.individual and context.cardarea == G.play then
				return {
					chips = -20,
				}
			end
			if context.hand_drawn then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = function()
						local target = pseudorandom_element(G.hand.cards, "mul_corrupt_heart")
						if target then
							SMODS.debuff_card(target, true, "mul_corrupt_heart")
							target:juice_up()
							local pool = {}
							for _, c in ipairs(G.hand.cards) do
								if c ~= target then
									pool[#pool + 1] = c
								end
							end
							local target2 = pseudorandom_element(pool, "mul_corrupt_heart")
							if target2 then
								G.E_MANAGER:add_event(Event({
									trigger = "after",
									delay = 0.4,
									func = function()
										target2:flip()
										target2:juice_up()
										return true
									end,
								}))
							end
						end
						return true
					end,
				}))
			end
		end
	end,
	phase_refresh = true,
})
