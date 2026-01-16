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
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				local _first_dissolve = nil
				local new_cards = {}
				for i = 1, 2 do
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local _card = copy_card(target, nil, nil, G.playing_card)
					_card:add_to_deck()
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, _card)
					G.hand:emplace(_card)
					_card:start_materialize(nil, _first_dissolve)
					_first_dissolve = true
					new_cards[#new_cards + 1] = _card
					if i == 1 then
						Multiverse.convert_to_half_card(_card, "left")
					else
						Multiverse.convert_to_half_card(_card, "right")
					end
				end
				SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
				SMODS.destroy_cards(target, nil, true, true)
				play_sound("slice1", 0.96 + math.random() * 0.08)
				return true
			end,
		}))
		delay(0.6)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.highlighted == 1 and Multiverse.can_halve_selected()
	end,
})

SMODS.Consumable({
	key = "polymerization",
	set = "Tarot",
	atlas = "placeholder",
	pos = { x = 0, y = 1 },
	config = { max_highlighted = 2 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = {
			set = "Other",
			key = "mul_fuse",
		}
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
		local c1 = G.hand.highlighted[1]
		local c2 = G.hand.highlighted[2]
		local left_enh_key = c1.ability.mul_half_card == "left" and c1.config.center.key or c2.config.center.key
		local right_enh_key = c1.ability.mul_half_card == "left" and c2.config.center.key or c1.config.center.key
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				local new_card = SMODS.add_card({ set = "Enhanced", key = "m_mul_frankenstein", no_edition = true })
				new_card.ability.extra.enhancement1 = left_enh_key
				new_card.ability.extra.enhancement2 = right_enh_key
				SMODS.calculate_context({ playing_card_added = true, cards = new_card })
				SMODS.destroy_cards({ c1, c2 }, nil, true)
				return true
			end,
		}))
		delay(0.6)
	end,
	can_use = function(self, card)
		return Multiverse.can_frankenstein_fuse_selected()
	end,
})
