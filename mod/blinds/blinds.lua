function Multiverse.show_blind_instructions(key)
	G.mul_INSTRUCTIONS_HUD = UIBox({
		definition = Multiverse.blind_instructions_HUD_def(key),
		config = { align = "cri", offset = { x = 5.3, y = 0.5 }, major = G.ROOM_ATTACH },
	})
	ease_value(G.mul_INSTRUCTIONS_HUD.config.offset, "x", -4, nil, nil, true, 0.6, "quad")
	G.mul_INSTRUCTIONS_HUD:recalculate()
end

function Multiverse.init_blinds()
	---@type number
	G.GAME.mul_undyne_damage_mult = 1
	if G.GAME.challenge == "c_mul_monsoon" then
		G.GAME.mul_undyne_damage_mult = 2
	end
	if G.GAME.blind and G.GAME.facing_blind then
		if G.GAME.blind.config.blind.key == "bl_mul_undying" and not G.GAME.blind.disabled then
			Multiverse.show_blind_instructions("undying")
		end
		if G.GAME.blind.config.blind.key == "bl_mul_limbo" and not G.GAME.blind.disabled then
			Multiverse.show_blind_instructions("limbo")
		end
	end
end

function Multiverse.hide_blind_instructions()
	if G.mul_INSTRUCTIONS_HUD then
		ease_value(G.mul_INSTRUCTIONS_HUD.config.offset, "x", 4, nil, nil, true, 0.6, "quad")
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 1,
			blocking = false,
			blockable = false,
			func = function()
				G.mul_INSTRUCTIONS_HUD:remove()
				G.mul_INSTRUCTIONS_HUD = nil
				return true
			end,
		}))
	end
end

SMODS.Blind({
	key = "limbo",
	dependencies = { "blindexpander" },
	passives = {
		"psv_mul_memorization",
		"psv_mul_unsightreadable",
	},
	atlas = "multiverse_blinds",
	pos = { x = 0, y = 0 },
	boss_colour = HEX("F2994B"),
	boss = { min = 3 },
	mult = 2,
	set_blind = function(self)
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

SMODS.Blind({
	key = "undying",
	dependencies = { "blindexpander" },
	passives = {
		"psv_mul_determination",
		"psv_mul_justice",
	},
	atlas = "multiverse_blinds",
	pos = { x = 0, y = 1 },
	boss_colour = lighten(G.C.BLACK, 0.1),
	boss = { min = 1 },
	mult = 2,
	press_play = function(self)
		if not G.GAME.blind.disabled then
			Multiverse.undyne_spears = {}
			Multiverse.done_attacking = false
			Multiverse.in_undyne = true
			local num_attacks = Multiverse.start_undyne_attack()
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
