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
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_sus_yellow"]
	end,
	use = function(self, card, area, copier)
		Multiverse.apply_to_hand_animation(card, function(playing_card)
			playing_card:set_ability(card.ability.extra.enhancement)
		end, function(playing_card)
			return playing_card:is_suit(card.ability.extra.suit)
		end)
	end,
})

SMODS.Consumable({
	key = "lightsaber",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	config = { max_highlighted = 1 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_half"]
		return {
			vars = {
				card.ability.max_highlighted,
			},
		}
	end,
	use = function(self, card, area, copier)
		local targets = {}
		for _, c in ipairs(G.hand.cards) do
			if Multiverse.can_halve_card(c) then
				targets[#targets + 1] = c
			end
		end
		local target = pseudorandom_element(targets, "mul_lightsaber")
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))
		Multiverse.halve_cards(target)
		delay(0.6)
	end,
	can_use = function(self, card)
		local targets = {}
		if G.hand then
			for _, c in ipairs(G.hand.cards) do
				if Multiverse.can_halve_card(c) then
					targets[#targets + 1] = c
				end
			end
		end
		return #targets > 0
	end,
})

SMODS.Consumable({
	key = "polymerization",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	config = { max_highlighted = 2 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = Multiverse.DummyCenters["du_mul_half"]
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_frankenstein"]
		return {
			vars = {
				card.ability.max_highlighted,
			},
		}
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
		Multiverse.frankenstein_fuse()
		delay(0.6)
	end,
	can_use = function(self, card)
		return Multiverse.can_frankenstein_fuse_selected()
	end,
})
