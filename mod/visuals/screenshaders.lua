SMODS.ScreenShader({
	key = "transmute_effect",
	path = "transmute_effect.fs",
	send_vars = function(self)
		return {
			stage = Multiverse.transmute_card_stage,
            pos = Multiverse.get_true_coords(Multiverse.transmuting_card),
            time = G.TIMERS.REAL
		}
	end,
	should_apply = function(self)
		return Multiverse.transmuting_card ~= nil
	end,
})
