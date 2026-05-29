SMODS.current_mod.custom_collection_tabs = function()
	return {
		UIBox_button({
			button = "your_collection_mul_deckenchantments",
			id = "your_collection_mul_deckenchantments",
			label = { localize("b_mul_deckenchantment_cards") },
			minw = 5,
			count = {
				tally = #SMODS.collection_pool(Multiverse.DeckEnchantments),
				of = #SMODS.collection_pool(Multiverse.DeckEnchantments),
			},
		}),
		UIBox_button({
			button = "your_collection_mul_skillcards",
			id = "your_collection_mul_skillcards",
			label = { localize("b_mul_skill_cards") },
			minw = 5,
			count = {
				tally = #SMODS.collection_pool(G.P_CENTER_POOLS.mul_Skill),
				of = #SMODS.collection_pool(G.P_CENTER_POOLS.mul_Skill),
			},
		}),
	}
end

G.FUNCS.your_collection_mul_deckenchantments = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = Multiverse.create_UIBox_your_collection_deckenchantments(),
	})
end

function Multiverse.create_UIBox_your_collection_deckenchantments()
	return SMODS.card_collection_UIBox(Multiverse.DeckEnchantments, { 5, 5, 5 }, {
		h_mod = 0.95,
		modify_card = function(card, center, i, j)
			card.ability.extra.collection_enchant = center.key
		end,
		center = "c_mul_enchanted_book",
		no_materialize = true,
	})
end

G.FUNCS.your_collection_mul_skillcards = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = Multiverse.create_UIBox_your_collection_skillcards(),
	})
end

function Multiverse.create_UIBox_your_collection_skillcards()
	-- return {
	-- 	n = G.UIT.O,
	-- 	config = {
	-- 		object = UIBox({
	-- 			definition = SMODS.card_collection_UIBox(
	-- 				G.P_CENTER_POOLS.mul_Skill,
	-- 				{ 5, 5 },
	-- 				{
	-- 					h_mod = 1.03,
	-- 					no_materialize = true,
	-- 					infotip = localize("ml_edition_seal_enhancement_explanation"),
	-- 					snap_back = true,
	-- 				}
	-- 			),
	-- 			config = { offset = { x = 0, y = 0 }, align = "cm" },
	-- 		}),
	-- 		align = "cm",
	-- 	},
	-- }
	return SMODS.card_collection_UIBox(G.P_CENTER_POOLS.mul_Skill, { 5, 5 }, {
		h_mod = 1.03,
		no_materialize = true,
		infotip = localize("ml_skill_card_explanation"),
		snap_back = true,
	})
end

function Multiverse.create_ench_name_UIBox(card)
	local text = localize({
		type = "name_text",
		set = "mul_DeckEnchantment",
		key = card.ability.extra.collection_enchant,
	})
	text = Multiverse.parse_vars(text, { "" })
	words = {}
	string.gsub(text, "([%a%p]+)", function(w)
		table.insert(words, w)
	end)
	rows = {}
	for _, word in ipairs(words) do
		rows[#rows + 1] = {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = word,
						colour = G.C.UI.TEXT_LIGHT,
						scale = 0.3,
					},
				},
			},
		}
	end
	return {
		n = G.UIT.ROOT,
		config = {
			r = 0.2,
			colour = { 0, 0, 0, 0.4 },
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.1,
					align = "cm",
				},
				nodes = rows,
			},
		},
	}
end

SMODS.draw_ignore_keys["mul_enchant_name"] = true

SMODS.DrawStep({
	key = "enchant_name",
	order = 200,
	func = function(self, layer)
		local should_draw = (self.ability.extra or {}).collection_enchant
		if
			not self.children.mul_ench_name
			and (self.config.center.discovered or self.bypass_discovery_center)
			and should_draw
		then
			self.children.mul_ench_name = UIBox({
				definition = Multiverse.create_ench_name_UIBox(self),
				config = {
					parent = self,
					align = "cm",
					bond = "Glued",
				},
			})
		end
		if self.children.mul_ench_name then
			if should_draw then
				self.children.mul_ench_name:draw()
			else
				self.children.mul_ench_name:remove()
				self.children.mul_ench_name = nil
			end
		end
	end,
	conditions = { vortex = false, facing = "front" },
})
