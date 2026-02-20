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
