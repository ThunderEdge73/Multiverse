SMODS.Keybind({
	key_pressed = "p",
	event = "pressed",
	action = function(self)
		if G.mul_TP_meter then
			G.mul_TP_meter_above = UIBox({
				definition = Multiverse.create_TP_ui(),
				config = { align = "tri", offset = { x = 1.3, y = -0.55 }, major = G.ROOM_ATTACH },
			})
		end
	end,
})

SMODS.Keybind({
	key_pressed = "p",
	event = "released",
	action = function(self)
		if G.mul_TP_meter_above then
			G.mul_TP_meter_above:remove()
			G.mul_TP_meter_above = nil
		end
	end,
})

SMODS.Keybind({
	key_pressed = "i",
	event = "pressed",
	action = function(self)
		if
			G.mul_blind_instructions
			and G.GAME.blind
			and G.GAME.facing_blind
			and not G.GAME.blind.disabled
			and G.GAME.blind.config.blind.mul_minigame
		then
			G.mul_blind_instructions_above = UIBox({
				definition = Multiverse.blind_instructions_HUD_def(G.GAME.blind.config.blind.mul_minigame),
				config = { align = "cri", offset = { x = 1.3, y = 0.5 }, major = G.ROOM_ATTACH },
			})
		end
	end,
})

SMODS.Keybind({
	key_pressed = "i",
	event = "released",
	action = function(self)
		if G.mul_blind_instructions_above then
            G.mul_blind_instructions_above:remove()
            mul_blind_instructions_above = nil
		end
	end,
})
