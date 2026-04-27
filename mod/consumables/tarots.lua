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
		Multiverse.play_animation("black_bg")
		Multiverse.play_video("bad_apple")
		Multiverse.very_important_thing = true
		G.E_MANAGER:add_event(Event({
			blockable = false,
			func = function()
				if not Multiverse.is_video_playing("bad_apple") then
					Multiverse.very_important_thing = false
					Multiverse.stop_animation("black_bg")
					return true
				end
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
		return G.hand ~= nil and #G.hand.cards > 0
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS["m_mul_sus_yellow"]
	end,
	use = function(self, card, area, copier)
		Multiverse.apply_to_cards_animation(card, G.hand.cards, function(_card)
			_card:set_ability(card.ability.extra.enhancement)
		end, function(_card)
			return _card:is_suit(card.ability.extra.suit)
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

function Multiverse.frankenstein_fuse()
	local c1 = G.hand.highlighted[1]
	local c2 = G.hand.highlighted[2]
	local left_enh_key = c1.ability.mul_half_card == "left" and c1.config.center_key or c2.config.center_key
	local right_enh_key = c1.ability.mul_half_card == "left" and c2.config.center_key or c1.config.center_key
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
end

function Multiverse.is_valid_frankenstein(card)
	if not card then
		return false
	end
	return type((card.ability or {}).extra) == "table"
		and card.ability.extra.enhancement1
		and card.ability.extra.enhancement2
		and card.ability.extra.enhancement1 ~= card.ability.extra.enhancement2
end

---@return boolean
function Multiverse.can_frankenstein_fuse_selected()
	return G.hand ~= nil
		and G.hand.highlighted
		and #G.hand.highlighted == 2
		and not SMODS.is_eternal(G.hand.highlighted[1], { mul_fusion = true })
		and not SMODS.is_eternal(G.hand.highlighted[2], { mul_fusion = true })
		and G.hand.highlighted[1].config.center_key ~= "c_base"
		and G.hand.highlighted[2].config.center_key ~= "c_base"
		and G.hand.highlighted[1].config.center_key ~= G.hand.highlighted[2].config.center_key
		and Multiverse.is_valid_half(G.hand.highlighted[1])
		and Multiverse.is_valid_half(G.hand.highlighted[2])
		and G.hand.highlighted[1].ability.mul_half_card ~= G.hand.highlighted[2].ability.mul_half_card
end
