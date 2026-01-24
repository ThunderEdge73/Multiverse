SMODS.Booster({
	key = "dimension_normal1",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 6,
		choose = 1,
	},
	weight = 0.5,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 8,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "dimension_normal2",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 6,
		choose = 1,
	},
	weight = 0.5,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 8,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "dimension_normal3",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 6,
		choose = 1,
	},
	weight = 0.5,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 8,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "dimension_normal4",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 6,
		choose = 1,
	},
	weight = 0.5,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 8,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "dimension_jumbo1",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 8,
		choose = 1,
	},
	weight = 0.5,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 10,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "dimension_jumbo2",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 8,
		choose = 1,
	},
	weight = 0.5,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 10,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "dimension_mega1",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 8,
		choose = 2,
	},
	weight = 0.25,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 12,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "dimension_mega2",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 8,
		choose = 2,
	},
	weight = 0.25,
	draw_hand = true,
	group_key = "k_mul_dimension",
	kind = "mul_dimension",
	cost = 12,
	create_card = function(self, card, i)
		local c
		local card_type = pseudorandom("mul_dimension_pack", 1, 4)
		if card_type == 1 then
			c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
			c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
				source = "dimension",
				key_append = "dimension",
			})
		elseif card_type == 2 then
			c = SMODS.create_card({
				set = "mul_Myth",
				area = G.pack_cards,
				skip_materialize = true,
				key_append = "dimension",
			})
		elseif card_type == 3 then
			c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
			c:set_ability(
				SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
				true
			)
		elseif card_type == 4 then
			local pool = {}
			for _, center in ipairs(G.P_CENTER_POOLS["Joker"]) do
				if center.original_mod == Multiverse then
					pool[#pool + 1] = center
				end
			end
			local key = pseudorandom_element(pool, "dimension", {
				in_pool = function(v, args)
					return v.rarity ~= "mul_transmuted"
						and v.rarity ~= 4
						and (type(v.in_pool) ~= "function" or v:in_pool(args))
				end,
			}).key
			c = SMODS.create_card({ key = key, area = G.pack_cards, skip_materialize = true })
		end
		return c
	end,
})

SMODS.Booster({
	key = "skill_normal1",
	atlas = "booster_placeholder",
	pos = { x = 0, y = 0 },
	config = {
		extra = 3,
		choose = 1,
	},
	weight = 1,
	draw_hand = true,
	group_key = "skill",
	kind = "skill",
	cost = 12,
	create_card = function(self, card, i)
		local c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
		c:set_ability(
			SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
			true
		)
		return c
	end,
})

SMODS.Booster({
	key = "enchantment_table_normal",
	atlas = "enchantment_table",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config = {
		extra = 3,
		choose = 1,
	},
	weight = 3,
	draw_hand = false,
	group_key = "k_mul_enchantment_table",
	kind = "mul_enchantment",
	cost = 10,
	create_card = function(self, card, i)
		local c = SMODS.create_card({ key = "c_mul_enchanted_book", area = G.pack_cards, skip_materialize = true })
		c.ability.extra.enchant_list = Multiverse.poll_deck_enchantments({
			source = "ench_book",
			key_append = "ench_book",
		})
		return c
	end,
})
