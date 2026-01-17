Multiverse.SkillCard({
	key = "test",
	tp_cost = 0,
	use_skill = function(self, card)
		Multiverse.effect_animation(card, function()
			print("Didnt crash")
		end)

        return "retain"
	end,
	loc_txt = {
		name = "Test Skill",
		text = {
            "Sends a debug message",
			"Discarded when used",
		},
	},
})