---Initializes 8 booster packs of the same kind.
---@param key string
---@param atlas string?
---@param config table
---@param create_card fun(card: Card, i: number): table | Card
function Multiverse.init_booster(key, atlas, config, create_card)
	displayed_atlas = atlas or "booster_placeholder"
	for i = 1, 4 do
		SMODS.Booster({
			key = key .. "_normal" .. i,
			atlas = displayed_atlas,
			pos = atlas and { x = (i - 1), y = 0 } or { x = 0, y = 0 },
			config = {
				extra = config.extra,
				choose = config.choose,
			},
			weight = config.weight,
			draw_hand = config.draw_hand,
			group_key = "k_mul_" .. key,
			kind = "mul_" .. key,
			cost = config.cost,
			create_card = function(self, card, j)
				return create_card(card, j)
			end,
		})
	end
	for i = 1, 2 do
		SMODS.Booster({
			key = key .. "_jumbo" .. i,
			atlas = displayed_atlas,
			pos = atlas and { x = (i - 1), y = 1 } or { x = 0, y = 0 },
			config = {
				extra = config.extra + 2,
				choose = config.choose,
			},
			weight = config.weight,
			draw_hand = config.draw_hand,
			group_key = "k_mul_" .. key,
			kind = "mul_" .. key,
			cost = config.cost + 2,
			create_card = function(self, card, j)
				return create_card(card, j)
			end,
		})
	end
	for i = 1, 2 do
		SMODS.Booster({
			key = key .. "_mega" .. i,
			atlas = displayed_atlas,
			pos = atlas and { x = (i - 1), y = 1 } or { x = 0, y = 0 },
			config = {
				extra = config.extra + 2,
				choose = config.choose + 1,
			},
			weight = config.weight / 4,
			draw_hand = config.draw_hand,
			group_key = "k_mul_" .. key,
			kind = "mul_" .. key,
			cost = config.cost + 4,
			create_card = function(self, card, j)
				return create_card(card, j)
			end,
		})
	end
end

Multiverse.init_booster(
	"dimension",
	nil,
	{ weight = 0.5, extra = 4, choose = 1, cost = 6 },
	function(card, i)
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
	end
)

Multiverse.init_booster("skill", nil, {cost = 4, extra = 3, choose = 1, weight = 1}, function (card, i)
	local c = SMODS.create_card({ set = "Base", area = G.pack_cards, skip_materialize = true })
	c:set_ability(
		SMODS.poll_enhancement({ key = "dimension", options = get_current_pool("mul_Skill"), guaranteed = true }),
		true
	)
	return c
end)

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
