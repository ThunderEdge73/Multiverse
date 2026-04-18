blindexpander.Passive({
	key = "summon",
	loc_vars = function(self, blind, passive)
		local name = localize({ type = "name_text", key = passive.blind_obj.summon, set = "Blind" })
		return {
			vars = { name },
		}
	end,
	fixed = true,
})

blindexpander.Passive({
	key = "otherworldly",
	fixed = true,
})

blindexpander.Passive({
	key = "memorization",
	config = { mult = 3 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.mult },
		}
	end,
	remove = function(self, blind, passive, from_disable)
		if G.GAME.failed_limbo then
			SMODS.calculate_effect({
				x_blind_size = 1 / passive.config.mult,
			}, G.GAME.blind)
		end
	end,
	apply = function(self, blind, passive, from_disable)
		if G.GAME.failed_limbo then
			SMODS.calculate_effect({
				x_blind_size = passive.config.mult,
			}, G.GAME.blind)
		end
	end,
})

blindexpander.Passive({
	key = "unsightreadable",
	calculate = function(self, blind, passive, context)
		if G.GAME.failed_limbo then
			if context.stay_flipped and context.to_area == G.hand then
				return {
					stay_flipped = true,
				}
			end
		end
	end,
	remove = function(self, blind, passive, from_disable)
		if G.GAME.failed_limbo then
			for i = 1, #G.hand.cards do
				if G.hand.cards[i].facing == "back" then
					G.hand.cards[i]:flip()
				end
			end
			for _, playing_card in pairs(G.playing_cards) do
				playing_card.ability.wheel_flipped = nil
			end
		end
	end,
	apply = function(self, blind, passive, from_disable)
		if G.GAME.failed_limbo then
			for i = 1, #G.hand.cards do
				if G.hand.cards[i].facing == "front" then
					G.hand.cards[i]:flip()
				end
			end
			for _, playing_card in pairs(G.playing_cards) do
				playing_card.ability.wheel_flipped = true
			end
		end
	end,
})

blindexpander.Passive({
	key = "determination",
	config = { percent = 10 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.percent * (G.GAME.mul_undyne_damage_mult or 1) },
		}
	end,
})

blindexpander.Passive({
	key = "justice",
	config = { debuffed = 1 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.debuffed },
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
		if context.mul_highlighted and context.other_card.area == G.hand then
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
	remove = function(self, passive, from_disable)
		ease_hands_played(passive.config.hands_removed)
		if from_disable then
			passive.config.hands_removed = 0
		end
	end,
})

blindexpander.Passive({
	key = "draw_reduction",
	config = { max_draw = 4 },
	modifies_draw = true,
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.max_draw + 1, passive.config.max_draw },
		}
	end,
	calculate = function(self, blind, passive, context)
		if
			context.drawing_cards
			and context.amount > passive.config.max_draw
			and (G.GAME.current_round.hands_played ~= 0 or G.GAME.current_round.discards_used ~= 0)
		then
			return {
				cards_to_draw = passive.config.max_draw,
			}
		end
	end,
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
	config = { chips = -10 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.chips },
		}
	end,
	calculate = function(self, blind, passive, context)
		if context.individual and context.cardarea == G.play then
			return {
				chips = passive.config.chips,
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
					local pool2 = Multiverse.filter(G.hand.cards, function(c)
						return c.facing == "front"
					end)
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
	apply = function(self, blind, passive, from_disable)
		if from_disable then
			SMODS.calculate_effect({
				x_blind_size = passive.config.mult,
			}, G.GAME.blind)
		end
	end,
	remove = function(self, blind, passive, from_disable)
		SMODS.calculate_effect({
			x_blind_size = 1 / passive.config.mult,
		}, G.GAME.blind)
	end,
})

blindexpander.Passive({
	key = "vulnerable",
	config = { xmult = 2 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.xmult },
			key = passive.fake_card and "psv_mul_vulnerable_infoqueue" or nil,
		}
	end,
	calculate = function(self, blind, passive, context)
		if context.final_scoring_step then
			return {
				xmult = passive.config.xmult,
			}
		end
		if context.after then
			G.E_MANAGER:add_event(Event({
				func = function()
					blind:remove_passive(self.key)
					return true
				end,
			}))
		end
	end,
})

blindexpander.Passive({
	key = "burning",
	config = { discards_left = 2 },
	loc_vars = function(self, blind, passive)
		return {
			vars = { passive.config.discards_left },
			key = passive.fake_card and "psv_mul_burning_infoqueue" or nil,
		}
	end,
	calculate = function(self, blind, passive, context)
		if context.pre_discard and not context.hook then
			passive.config.discards_left = passive.config.discards_left - 1
			local text, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
			return {
				level_up = true,
				level_up_hand = text,
				func = function()
					if passive.config.discards_left <= 0 then
						G.E_MANAGER:add_event(Event({
							func = function()
								blind:remove_passive(self.key)
								return true
							end,
						}))
					end
				end,
			}
		end
	end,
})
