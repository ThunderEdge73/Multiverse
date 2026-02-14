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
			slash1 = Multiverse.screen_slashes[1],
			slash2 = Multiverse.screen_slashes[2],
			slash3 = Multiverse.screen_slashes[3],
			slash4 = Multiverse.screen_slashes[4],
			slash5 = Multiverse.screen_slashes[5],
			slash6 = Multiverse.screen_slashes[6],
			slash7 = Multiverse.screen_slashes[7],
			slash8 = Multiverse.screen_slashes[8],
			bottom_right = { love.graphics.getWidth(), love.graphics.getHeight() },
			progress = Multiverse.slash_stage,
		}
	end,
	should_apply = function(self)
		return Multiverse.slashes_active
	end,
})

function Multiverse.start_slashes()
	Multiverse.screen_slashes = {}
	Multiverse.slash_stage = 0
	for _ = 1, 8 do
		Multiverse.screen_slashes[#Multiverse.screen_slashes + 1] = {
			math.random(),
			math.random(),
			math.random(),
			math.random(),
		}
	end
	Multiverse.slashes_active = true
	for _ = 1, 8 do
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.5,
			func = function()
				ease_value(Multiverse, "slash_stage", 1, nil, nil, true, 0.3)
				play_sound("slice1", 0.96 + math.random() * 0.08, 1.1)
				return true
			end,
		}))
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 2.5,
		func = function()
			ease_value(Multiverse, "slash_stage", 1, nil, nil, true, 2)
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 2.1,
		func = function()
			Multiverse.slashes_active = false
			return true
		end,
	}))
end
