SMODS.Consumable({
	key = "lobotomized",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	config = { max_highlighted = 2, mod_conv = "m_mul_normal" },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, G.P_CENTERS[card.ability.mod_conv])
		return { vars = { card.ability.max_highlighted } }
	end,
})
SMODS.Consumable({
	key = "chair",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	config = { max_highlighted = 1, mod_conv = "m_mul_motivated" },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, G.P_CENTERS[card.ability.mod_conv])
		return { vars = { card.ability.max_highlighted } }
	end,
})
SMODS.Consumable({
	key = "apple",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	in_pool = function(self, args)
		return Multiverse.config["joke"]
	end,
	can_use = function(self, card)
		return true
	end,
	check_dependencies = function(self)
		return Multiverse.config["joke"]
	end,
	use = function(self, card, area, copier)
		Multiverse.play_video("bad_apple")
		Multiverse.start_animation("black_bg")
		Multiverse.very_important_thing = true
		G.E_MANAGER:add_event(Event({
			blockable = false,
			trigger = "after",
			delay = 218 * G.SPEEDFACTOR,
			func = function()
				Multiverse.very_important_thing = false
				Multiverse.stop_video("bad_apple")
				Multiverse.end_animation("black_bg")
				return true
			end,
		}))
	end,
})
SMODS.Consumable({
	key = "burger",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	in_pool = function(self, args)
		return Multiverse.config["joke"]
	end,
	can_use = function(self, card)
		return true
	end,
	check_dependencies = function(self)
		return Multiverse.config["joke"]
	end,
	use = function(self, card, area, copier)
		Multiverse.start_animation("eating_burger")
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 60 * G.SPEEDFACTOR,
			blockable = false,
			blocking = false,
			func = function()
				Multiverse.end_animation("eating_burger")
				return true
			end,
		}))
	end,
})

SMODS.Consumable({
	key = "eggman",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	config = {
		extra = {
			suit = "Clubs",
			enhancement = "m_mul_sus_yellow",
		},
	},
	can_use = function(self, card)
		return G.hand ~= nil
	end,
	loc_vars = function (self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["m_mul_sus_yellow"]
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards / 2 - 0.998) * 0.3
			if G.hand.cards[i]:is_suit(card.ability.extra.suit) then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.15,
					func = function()
						G.hand.cards[i]:flip()
						play_sound("card1", percent)
						G.hand.cards[i]:juice_up(0.3, 0.3)
						return true
					end,
				}))
			end
		end
		delay(0.2)
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit(card.ability.extra.suit) then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function()
						G.hand.cards[i]:set_ability(card.ability.extra.enhancement)
						return true
					end,
				}))
			end
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.hand.cards / 2 - 0.998) * 0.3
			if G.hand.cards[i]:is_suit(card.ability.extra.suit) then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.15,
					func = function()
						G.hand.cards[i]:flip()
						play_sound("tarot2", percent, 0.6)
						G.hand.cards[i]:juice_up(0.3, 0.3)
						return true
					end,
				}))
			end
		end
		delay(0.5)
	end,
})
