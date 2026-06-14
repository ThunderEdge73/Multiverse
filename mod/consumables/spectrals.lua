SMODS.Consumable({
	key = "eternity",
	set = "Spectral",
	atlas = "placeholder",
	pos = { x = 1, y = 1 },
	config = { extra = { destroyed = 1 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "eternal",
		})
		local has_incompat = false
		if G.jokers then
			for _, j in ipairs(G.jokers.cards) do
				if not j.config.center.eternal_compat then
					has_incompat = true
					break
				end
			end
		end
		return { key = (has_incompat and "c_mul_eternity_alt") or nil, vars = { card.ability.extra.destroyed } }
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.cards > 0 and #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local cards_to_destroy = {}
			for _, j in ipairs(G.jokers.cards) do
				if j.config.center.eternal_compat == false then
					cards_to_destroy[#cards_to_destroy + 1] = j
				else
					j:add_sticker("eternal", true)
					j:juice_up(0.3, 0.5)
				end
			end
			local count = 0
			for _, j in ipairs(G.jokers.cards) do
				if j.ability.eternal then
					count = count + 1
				end
			end
			local destroyed = Multiverse.get_unique_pseudorandom_elements(G.hand.cards, count, "mul_eternity")
			Multiverse.play_animation("lightning")
			cards_to_destroy = SMODS.merge_lists({ cards_to_destroy, destroyed })
			SMODS.destroy_cards(cards_to_destroy)
		end)
	end,
})

SMODS.Consumable({
	key = "backstab", -- may need to be nerfed, dont got time to test ts
	set = "Spectral",
	atlas = "placeholder",
	pos = { x = 1, y = 1 },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_traitorous",
		})
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.cards >= 1
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local target = pseudorandom_element(G.jokers.cards, "mul_backstab")
			local copied_joker = SMODS.copy_card(target, { strip_edition = true })
			copied_joker:add_sticker("mul_traitorous", true)
			copied_joker:set_edition("e_negative")
		end)
	end,
})

SMODS.Consumable({
	key = "scheme",
	set = "Spectral",
	atlas = "placeholder",
	pos = { x = 1, y = 1 },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "rental",
			vars = { G.GAME.rental_rate },
		})
		local total_value = 0
		if G.jokers then
			for _, j in ipairs(G.jokers.cards) do
				total_value = total_value + j.sell_cost
			end
		end
		return { vars = { total_value * 3 } }
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.cards > 0
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local total = 0
			for _, j in ipairs(G.jokers.cards) do
				total = total + j.sell_cost
				j:set_rental(true)
				j:juice_up(0.3, 0.5)
			end
			ease_dollars(total * 3, true)
		end)
	end,
})
