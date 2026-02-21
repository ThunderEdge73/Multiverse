SMODS.ScreenShader({
	key = "transmute_effect",
	path = "transmute_effect.fs",
	send_vars = function(self)
		return {
			stage = Multiverse.transmute_card_stage,
			pos = Multiverse.get_true_coords(Multiverse.transmuting_card),
			time = G.TIMERS.REAL,
		}
	end,
	should_apply = function(self)
		return Multiverse.transmuting_card ~= nil
	end,
})

Multiverse.screen_slashes = {}
SMODS.ScreenShader({
	key = "slashes",
	path = "slashed.fs",
	send_vars = function(self)
		return {
			slashes = { array = Multiverse.screen_slashes },
			blue_phases = { array = Multiverse.blue_color_amts },
			bottom_right = { love.graphics.getWidth(), love.graphics.getHeight() },
			progress = Multiverse.slash_stage,
			card_pos = Multiverse.slash_pos or Multiverse.get_true_coords(Multiverse.slash_card),
			game_scale = G.TILESIZE * G.TILESCALE,
			card_w = G.CARD_W,
		}
	end,
	should_apply = function(self)
		return Multiverse.slashes_active
	end,
})

function Multiverse.start_slashes(card)
	Multiverse.screen_slashes = {}
	Multiverse.blue_color_amts = {}
	Multiverse.slash_stage = 0
	Multiverse.slash_card = card
	for _ = 1, 10 do
		Multiverse.screen_slashes[#Multiverse.screen_slashes + 1] = {
			math.random(),
			math.random(),
			math.random(),
			math.random(),
		}
		Multiverse.blue_color_amts[#Multiverse.blue_color_amts + 1] = 0
	end
	Multiverse.slashes_active = true
	for i = 1, 10 do
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.3,
			func = function()
				ease_value(Multiverse, "slash_stage", 1, nil, nil, true, 0.2)
				ease_value(Multiverse.blue_color_amts, i, 1, nil, nil, true, 1.4)
				play_sound("slice1", 0.96 + math.random() * 0.08, 1.1)
				return true
			end,
		}))
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 2.1,
		func = function()
			Multiverse.slash_pos = Multiverse.get_true_coords(Multiverse.slash_card)
			ease_value(Multiverse, "slash_stage", 1, nil, nil, true, 2)
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 2.1,
		blocking = false,
		func = function()
			Multiverse.slash_pos = nil
			Multiverse.slashes_active = false
			return true
		end,
	}))
end

Multiverse.dark_bg_percent = 1
Multiverse.dark_bg_active = false
SMODS.ScreenShader({
	key = "dark_bg",
	path = "dark_bg.fs",
	send_vars = function(self)
		return {
			radius = math.sqrt(love.graphics.getWidth() ^ 2 + love.graphics.getHeight() ^ 2) * Multiverse.dark_bg_percent,
			center = {love.graphics.getWidth() / 2, love.graphics.getHeight() / 2},
		}
	end,
	should_apply = function(self)
		return Multiverse.dark_bg_active
	end,
})