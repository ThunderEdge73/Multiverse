SMODS.Tag({
	key = "enchantment",
	pos = { x = 0, y = 0 },
    atlas = "enchantment_tag",
	loc_vars = function (self, info_queue, tag)
		info_queue[#info_queue+1] = G.P_CENTERS["p_mul_enchantment_table_normal"]
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			local lock = tag.ID
			G.CONTROLLER.locks[lock] = true
			tag:yep("+", G.C.SECONDARY_SET.mul_EnchantedBook, function()
				local booster = SMODS.add_card({ key = "p_mul_enchantment_table_normal", area = G.play })
				booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
				booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
				booster.T.w = G.CARD_W * 1.27
				booster.T.h = G.CARD_H * 1.27
				booster:set_sprites(G.P_CENTERS["p_mul_enchantment_table_normal"])
				booster.cost = 0
				booster.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = booster } })
				booster:start_materialize()
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
})

SMODS.Tag({
	key = "dimensional",
	pos = { x = 0, y = 0 },
    atlas = "enchantment_tag",
	loc_vars = function (self, info_queue, tag)
		info_queue[#info_queue+1] = G.P_CENTERS["p_mul_dimension_normal1"]
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			local lock = tag.ID
			G.CONTROLLER.locks[lock] = true
			tag:yep("+", G.C.SECONDARY_SET.mul_EnchantedBook, function()
				local booster = SMODS.add_card({ key = "p_mul_dimension_normal1", area = G.play })
				booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
				booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
				booster.T.w = G.CARD_W * 1.27
				booster.T.h = G.CARD_H * 1.27
				booster.cost = 0
				booster.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = booster } })
				booster:start_materialize()
				G.CONTROLLER.locks[lock] = nil
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
})
