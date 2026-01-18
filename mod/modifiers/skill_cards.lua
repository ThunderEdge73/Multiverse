Multiverse.SkillCard({
	key = "test",
	tp_cost = 10,
	use_skill = function(self, card)
		Multiverse.effect_animation(card, function()
			print("Didnt crash")
		end)

        return "exhaust"
	end,
	loc_txt = {
		name = "Test Skill",
		text = {
            "Sends a debug message",
			"Exhausts when used",
		},
	},
})