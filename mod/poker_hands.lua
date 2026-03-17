SMODS.PokerHandPart({
	key = "storm",
	func = function(hand)
		if #hand < 5 then
			return {}
		end
		local ranks = {}
		local suits = {}
		local wilds = 0
		for _, card in ipairs(hand) do
			if not SMODS.has_no_rank(card) and not Multiverse.contains_value(ranks, card:get_id()) then
				ranks[#ranks + 1] = card:get_id()
			end
			if SMODS.has_any_suit(card) then
				wilds = wilds + 1
			elseif not SMODS.has_no_suit(card) then
				for key, _ in pairs(SMODS.Suits) do
					if card:is_suit(key, false, true) and not suits[key] then
						suits[key] = true
					end
				end
			end
		end
		if #ranks < 5 or Multiverse.len(suits) < 4 then
			return {}
		end
		return { hand }
	end,
})

SMODS.PokerHand({
	key = "storm",
	mult = 2,
	chips = 5,
	l_mult = 2,
	l_chips = 10,
	example = {
		{ "S_A", true },
		{ "D_Q", true },
		{ "H_2", true },
		{ "D_6", true },
		{ "C_9", true },
	},
	evaluate = function(parts, hand)
		return parts.mul_storm
	end,
})
