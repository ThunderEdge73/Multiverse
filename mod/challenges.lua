SMODS.Challenge({
	key = "waterfall",
	rules = {
		custom = {
			{ id = "mul_waterfall1" },
		},
	},
	restrictions = {
		banned_cards = {
			{ id = "v_directors_cut" },
			{ id = "v_retcon" },
		},
		banned_tags = {
			{ id = "tag_boss" },
		},
	},
})

_boss_old = get_new_boss
function get_new_boss()
	ret = _boss_old()
	if
		G.GAME.challenge == "c_mul_waterfall"
		or G.GAME.challenge == "c_mul_monsoon"
		or G.GAME.challenge == "c_mul_cant_touch_this"
	then
		ret = "bl_mul_undying"
	end
	return ret
end

SMODS.Challenge({
	key = "monsoon",
	rules = {
		custom = {
			{ id = "mul_waterfall1" },
			{ id = "mul_waterfall2" },
			{ id = "mul_waterfall3" },
		},
	},
	restrictions = {
		banned_cards = {
			{ id = "v_directors_cut" },
			{ id = "v_retcon" },
			{ id = "j_luchador" },
			{ id = "j_chicot" },
		},
		banned_tags = {
			{ id = "tag_boss" },
		},
	},
})

SMODS.Challenge({
	key = "cant_touch_this",
	rules = {
		custom = {
			{ id = "mul_waterfall1" },
			{ id = "mul_waterfall4" },
		},
	},
	restrictions = {
		banned_cards = {
			{ id = "v_directors_cut" },
			{ id = "v_retcon" },
			{ id = "j_luchador" },
			{ id = "j_chicot" },
		},
		banned_tags = {
			{ id = "tag_boss" },
		},
	},
})
