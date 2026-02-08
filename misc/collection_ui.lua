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
	G.E_MANAGER:add_event(Event({
		func = function()
			G.FUNCS.mul_deckenchantment_collection_page({ cycle_config = {} })
			return true
		end,
	}))
	return {
		n = G.UIT.O,
		config = {
			object = UIBox({
				definition = Multiverse.create_UIBox_your_collection_deckenchantments_content(),
				config = { offset = { x = 0, y = 0 }, align = "cm" },
			}),
			id = "your_collection_deckenchantment_contents",
			align = "cm",
		},
	}
end

function Multiverse.create_UIBox_your_collection_deckenchantments_content(page)
	page = page or 1
	args = {}
	args.w_mod = 1
	args.h_mod = 0.95
	args.card_scale = 1
	local pool = SMODS.collection_pool(Multiverse.DeckEnchantments)
	G.your_collection = {}
	local rows = 3
	local cols = 5
	local table_nodes = {}

	for i = 1, rows do
		G.your_collection[i] = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
			G.ROOM.T.h,
			(args.w_mod * cols + 0.25) * G.CARD_W,
			args.h_mod * G.CARD_H,
			{ card_limit = cols, type = "title", highlight_limit = 0, collection = true }
		)
		table.insert(table_nodes, {
			n = G.UIT.R,
			config = { align = "cm", padding = 0.07, no_fill = true },
			nodes = {
				{ n = G.UIT.O, config = { object = G.your_collection[i] } },
			},
		})
	end

	local options = {}
	for i = 1, math.ceil(#pool / (rows * cols)) do
		table.insert(
			options,
			localize("k_page") .. " " .. tostring(i) .. "/" .. tostring(math.ceil(#pool / (rows * cols)))
		)
	end

	local t = create_UIBox_generic_options({
		colour = G.ACTIVE_MOD_UI
			and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_colour or (G.ACTIVE_MOD_UI.ui_config or {}).colour),
		bg_colour = G.ACTIVE_MOD_UI
			and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_bg_colour or (G.ACTIVE_MOD_UI.ui_config or {}).bg_colour),
		back_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_back_colour or (
			G.ACTIVE_MOD_UI.ui_config or {}
		).back_colour),
		outline_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_outline_colour or (
			G.ACTIVE_MOD_UI.ui_config or {}
		).outline_colour),
		back_func = G.ACTIVE_MOD_UI and "openModUI_" .. G.ACTIVE_MOD_UI.id or "your_collection",
		snap_back = args.snap_back,
		infotip = args.infotip,
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm" },
						nodes = table_nodes,
					},
				},
			},
			((rows * cols) < #pool) and {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					create_option_cycle({
						options = options,
						w = 4.5,
						cycle_shoulders = true,
						opt_callback = "mul_deckenchantment_collection_page",
						current_option = page,
						colour = G.ACTIVE_MOD_UI and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour
							or G.C.RED,
						no_pips = true,
						focus_args = { snap_to = true, nav = "wide" },
					}),
				},
			} or nil,
		},
	})
	return t
end

function G.FUNCS.mul_deckenchantment_collection_page(args)
	local rows, cols = 3, 5
	local page = args and args.cycle_config.current_option or 1
	local t = Multiverse.create_UIBox_your_collection_deckenchantments_content(page)
	if G.your_collection then
		for i = #G.your_collection, 1, -1 do
			for j = #G.your_collection[i].cards, 1, -1 do
				local c = G.your_collection[j]:remove_card(G.your_collection[i].cards[j])
				c:remove()
				c = nil
			end
		end
		local pool = SMODS.collection_pool(Multiverse.DeckEnchantments)
		local row, col = 1, 1
		for index, obj in ipairs(pool) do
			if index <= (page - 1) * rows * cols then
			elseif index > page * rows * cols then
				break
			else
				local card = Card(
					G.your_collection[row].T.x + G.your_collection[row].T.w / 2,
					G.your_collection[row].T.y,
					G.CARD_W,
					G.CARD_H,
					G.P_CARDS.empty,
					G.P_CENTERS["c_mul_enchanted_book"]
				)
				card.ability.extra.collection_enchant = pool[index].key
				card:start_materialize({ HEX("A61A1F"), HEX("CAA540") }, row > 1 or col > 1)
				G.your_collection[row]:emplace(card)
				col = col + 1
				if col > cols then
					row = row + 1
					col = 1
				end
			end
		end
		INIT_COLLECTION_CARD_ALERTS()
	end
	local e = G.OVERLAY_MENU:get_UIE_by_ID("your_collection_deckenchantment_contents")
	if e and e.config.object then
		e.config.object:remove()
	end
	e.config.object = UIBox({
		definition = t,
		config = { offset = { x = 0, y = 0 }, align = "cm", parent = e },
	})
end

G.FUNCS.your_collection_mul_skillcards = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = Multiverse.create_UIBox_your_collection_skillcards(),
	})
end

function Multiverse.create_UIBox_your_collection_skillcards()
	G.E_MANAGER:add_event(Event({
		func = function()
			G.FUNCS.mul_skillcard_collection_page({ cycle_config = {} })
			return true
		end,
	}))
	return {
		n = G.UIT.O,
		config = {
			object = UIBox({
				definition = Multiverse.create_UIBox_your_collection_skillcards_content(),
				config = { offset = { x = 0, y = 0 }, align = "cm" },
			}),
			id = "your_collection_skillcard_contents",
			align = "cm",
		},
	}
end

function Multiverse.create_UIBox_your_collection_skillcards_content(page)
	page = page or 1
	args = {}
	args.w_mod = 1
	args.h_mod = 1.03
	args.card_scale = 1
	local pool = SMODS.collection_pool(G.P_CENTER_POOLS.mul_Skill)
	G.your_collection = {}
	local rows = 2
	local cols = 5
	local table_nodes = {}

	for i = 1, rows do
		G.your_collection[i] = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
			G.ROOM.T.h,
			(args.w_mod * cols + 0.25) * G.CARD_W,
			args.h_mod * G.CARD_H,
			{ card_limit = cols, type = "title", highlight_limit = 0, collection = true }
		)
		table.insert(table_nodes, {
			n = G.UIT.R,
			config = { align = "cm", padding = 0.07, no_fill = true },
			nodes = {
				{ n = G.UIT.O, config = { object = G.your_collection[i] } },
			},
		})
	end

	local options = {}
	for i = 1, math.ceil(#pool / (rows * cols)) do
		table.insert(
			options,
			localize("k_page") .. " " .. tostring(i) .. "/" .. tostring(math.ceil(#pool / (rows * cols)))
		)
	end

	local t = create_UIBox_generic_options({
		colour = G.ACTIVE_MOD_UI
			and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_colour or (G.ACTIVE_MOD_UI.ui_config or {}).colour),
		bg_colour = G.ACTIVE_MOD_UI
			and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_bg_colour or (G.ACTIVE_MOD_UI.ui_config or {}).bg_colour),
		back_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_back_colour or (
			G.ACTIVE_MOD_UI.ui_config or {}
		).back_colour),
		outline_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_outline_colour or (
			G.ACTIVE_MOD_UI.ui_config or {}
		).outline_colour),
		back_func = G.ACTIVE_MOD_UI and "openModUI_" .. G.ACTIVE_MOD_UI.id or "your_collection",
		snap_back = args.snap_back,
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm" },
						nodes = table_nodes,
					},
				},
			},
			((rows * cols) < #pool) and {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					create_option_cycle({
						options = options,
						w = 4.5,
						cycle_shoulders = true,
						opt_callback = "mul_skillcard_collection_page",
						current_option = page,
						colour = G.ACTIVE_MOD_UI and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour
							or G.C.RED,
						no_pips = true,
						focus_args = { snap_to = true, nav = "wide" },
					}),
				},
			} or nil,
		},
	})
	G.E_MANAGER:add_event(Event({
		blocking = false,
		blockable = false,
		timer = "REAL",
		func = function()
			if G.OVERLAY_MENU then
				local _infotip_object = G.OVERLAY_MENU.definition.config.object:get_UIE_by_ID("overlay_menu_infotip")
				if _infotip_object then
					_infotip_object.config.object:remove()
					_infotip_object.config.object = UIBox({
						definition = overlay_infotip(localize("ml_skill_card_explanation")),
						config = { offset = { x = 0, y = 0 }, align = "bm", parent = _infotip_object },
					})
				end
			end
			return true
		end,
	}))
	return t
end

function G.FUNCS.mul_skillcard_collection_page(args)
	local rows, cols = 2, 5
	local page = args and args.cycle_config.current_option or 1
	local t = Multiverse.create_UIBox_your_collection_skillcards_content(page)
	if G.your_collection then
		for i = #G.your_collection, 1, -1 do
			for j = #G.your_collection[i].cards, 1, -1 do
				local c = G.your_collection[j]:remove_card(G.your_collection[i].cards[j])
				c:remove()
				c = nil
			end
		end
		local pool = SMODS.collection_pool(G.P_CENTER_POOLS.mul_Skill)
		local row, col = 1, 1
		for index, _ in ipairs(pool) do
			if index <= (page - 1) * rows * cols then
			elseif index > page * rows * cols then
				break
			else
				local center = pool[(page - 1) * rows * cols + (row - 1) * cols + col]
				if not center then
					break
				end
				local card = Card(
					G.your_collection[row].T.x + G.your_collection[row].T.w / 2,
					G.your_collection[row].T.y,
					G.CARD_W,
					G.CARD_H,
					G.P_CARDS.empty,
					center
				)
				card:start_materialize({ G.C.FILTER, G.C.RED, G.C.BLUE }, row > 1 or col > 1)
				G.your_collection[row]:emplace(card)
				col = col + 1
				if col > cols then
					row = row + 1
					col = 1
				end
			end
		end
		INIT_COLLECTION_CARD_ALERTS()
	end
	local e = G.OVERLAY_MENU:get_UIE_by_ID("your_collection_skillcard_contents")
	if e and e.config.object then
		e.config.object:remove()
	end
	e.config.object = UIBox({
		definition = t,
		config = { offset = { x = 0, y = 0 }, align = "cm", parent = e },
	})
end
