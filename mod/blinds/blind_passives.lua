if not blindexpander or not blindexpander.Passive then
	return
end

blindexpander.Passive({
	key = "memorization",
	config = { mult = 3 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.mult },
		}
	end,
})

blindexpander.Passive({
	key = "unsightreadable",
})

blindexpander.Passive({
	key = "determination",
	config = { percent = 10 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.percent * G.GAME.mul_undyne_damage_mult },
		}
	end,
})

blindexpander.Passive({
	key = "justice",
	config = { destroyed = 1 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.destroyed },
		}
	end,
})

blindexpander.Passive({
	key = "time_warp",
	config = { selected = 0, hands_removed = 0 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { 12 - passive.config.selected },
		}
	end,
	calculate = function(self, blind, passive, context)
        if context.before then
			if #context.scoring_hand > 5 then
				passive.config.selected = 0
			end
		end
		if context.mul_highlighted then
			passive.config.selected = passive.config.selected + 1
			if passive.config.selected == 12 then
				passive.config.selected = 0
                passive.config.hands_removed = passive.config.hands_removed + 1
				ease_hands_played(-1)
				G.E_MANAGER:add_event(Event({
					func = function()
						if G.GAME.current_round.hands_left <= 0 then
							G.E_MANAGER:add_event(Event({
								trigger = "after",
								delay = 2,
								func = function()
									Multiverse.lose()
									return true
								end,
							}))
						end
						return true
					end,
				}))
			end
		end
	end,
    remove = function (self, passive, from_disable)
        ease_hands_played(passive.config.hands_removed)
        if from_disable then
            passive.config.hands_removed = 0
        end
    end
})

blindexpander.Passive({
	key = "artifact",
	config = { preventions = 1 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.preventions },
		}
	end,
	calculate = function(self, blind, passive, context)
		if context.mul_prevent_disable then
			return {
				prevent_disable = function(is_already_prevented)
					if not is_already_prevented and passive.config.preventions > 0 then
						passive.config.preventions = passive.config.preventions - 1
						if passive.config.preventions == 0 then
							blind:disable_passive(self.key)
						end
					end
				end,
			}
		end
	end,
})

blindexpander.Passive({
	key = "beat_of_death",
	config = { chips = -20 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.chips },
		}
	end,
	calculate = function(self, blind, passive, context)
		if context.individual and context.cardarea == G.play then
			return {
				chips = -20,
			}
		end
	end,
})

blindexpander.Passive({
	key = "debilitate",
	config = { affected = 1 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.affected },
		}
	end,
	calculate = function(self, blind, passive, context)
		if context.hand_drawn then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				func = function()
					local pool1 = Multiverse.filter(G.hand.cards, function(c)
						return not c.debuff
					end)
					local target = pseudorandom_element(pool1, "mul_corrupt_heart")
					if target then
						SMODS.debuff_card(target, true, "mul_corrupt_heart")
						target:juice_up()
					end
					local pool2 = {}
					for _, c in ipairs(G.hand.cards) do
						if c ~= target and c.facing == "front" then
							pool2[#pool2 + 1] = c
						end
					end
					local target2 = pseudorandom_element(pool2, "mul_corrupt_heart")
					if target2 then
						target2:flip()
						return true
					end
					return true
				end,
			}))
		end
	end,
	remove = function(self, passive, from_disable)
		Multiverse.apply_to_playing_cards(function(playing_card)
			SMODS.debuff_card(playing_card, false, "mul_corrupt_heart")
		end)
		Multiverse.apply_to_hand(function(playing_card)
			if playing_card.facing == "back" then
				playing_card:flip()
			end
		end)
	end,
})

blindexpander.Passive({
	key = "surrounding",
	config = {},
	calculate = function(self, blind, passive, context)
		if context.modify_scoring_hand and context.in_scoring then
			if
				context.other_card == context.scoring_hand[1]
				or context.other_card == context.scoring_hand[#context.scoring_hand]
			then
				return {
					remove_from_hand = true,
				}
			end
		end
	end,
})

blindexpander.Passive({
	key = "bulky",
	config = { mult = 2 },
    apply = function(self, passive, from_disable)
        Multiverse.change_blind_size(function(chips)
			return chips * passive.config.mult
		end)
    end,
	remove = function(self, passive, from_disable)
        Multiverse.change_blind_size(function(chips)
			return chips / passive.config.mult
		end)
    end,
})
