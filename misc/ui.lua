function Multiverse.create_custom_toggle(args)
	args = args or {}
	args.active_colour = args.active_colour or G.C.RED
	args.inactive_colour = args.inactive_colour or G.C.BLACK
	args.w = args.w or 3
	args.h = args.h or 0.5
	args.scale = args.scale or 1
	args.label = args.label or "NONE"
	args.label_scale = args.label_scale or 0.4
	args.ref_table = args.ref_table or {}
	args.ref_value = args.ref_value or "NONE"

	local check = Sprite(0, 0, 0.5 * args.scale, 0.5 * args.scale, G.ASSET_ATLAS["icons"], { x = 1, y = 0 })
	check.states.drag.can = false
	check.states.visible = false

	local info = nil
	if args.info then
		info = {}
		for k, v in ipairs(args.info) do
			table.insert(info, {
				n = G.UIT.R,
				config = { align = "cm", minh = 0.05 },
				nodes = {
					{ n = G.UIT.T, config = { text = v, scale = 0.25, colour = G.C.UI.TEXT_LIGHT } },
				},
			})
		end
		info = { n = G.UIT.R, config = { align = "cm", minh = 0.05 }, nodes = info }
	end
	local t = {
		n = args.col and G.UIT.C or G.UIT.R,
		config = { align = "cm", padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = { funnel_from = true } },
		nodes = {
			args.label ~= "" and {
				n = G.UIT.C,
				config = { align = "cr", minw = args.w },
				nodes = {
					{
						n = G.UIT.T,
						config = { text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT },
					},
					(args.spacer and { n = G.UIT.B, config = { w = 0.1, h = 0.1 } }) or nil,
				},
			} or nil,
			{
				n = G.UIT.C,
				config = { align = "cl", minw = 0.3 * args.w },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", r = 0.1, colour = G.C.BLACK },
						nodes = {
							{
								n = G.UIT.C,
								config = {
									align = "cm",
									r = 0.1,
									padding = 0.03,
									minw = 0.4 * args.scale,
									minh = 0.4 * args.scale,
									outline_colour = args.outline_colour or G.C.WHITE,
									outline = 1.2 * args.scale,
									line_emboss = 0.5 * args.scale,
									ref_table = args,
									colour = args.inactive_colour,
									button = "toggle_button",
									button_dist = 0.2,
									hover = true,
									toggle_callback = args.callback,
									func = "toggle",
									focus_args = { funnel_to = true },
								},
								nodes = {
									{ n = G.UIT.O, config = { object = check } },
								},
							},
						},
					},
				},
			},
		},
	}
	if args.info then
		t = {
			n = args.col and G.UIT.C or G.UIT.R,
			config = { align = "cm" },
			nodes = {
				t,
				info,
			},
		}
	end
	return t
end

---@param song string
---@param credit string
function Multiverse.music_toggle(song, credit)
	local toggle = Multiverse.create_custom_toggle({
		label = "",
		active_colour = Multiverse.C.PRIMARY1,
		ref_table = Multiverse.config.music,
		ref_value = song,
		w = 0,
		h = 0,
	})
	return { -- 1
		n = G.UIT.C,
		config = { align = "cm", padding = 0.1 },
		nodes = {
			{ -- 2
				n = G.UIT.R,
				config = {
					align = "cm",
					colour = Multiverse.config.music[song] and G.C.GREEN or G.C.RED,
					padding = 0.1,
					r = 0.1,
					func = "mul_update_music_toggle",
					song_data = song,
				},
				nodes = { -- nesting +3
					{
						n = G.UIT.C,
						config = {
							align = "cm",
							padding = 0.1,
							colour = G.C.WHITE,
							r = 0.1,
							emboss = 0.05,
							tooltip = {
								text = localize("mul_" .. song),
								colour = Multiverse.config.music[song] and G.C.GREEN or G.C.RED,
							},
						},
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cl" },
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = DynaText({
												string = song,
												colours = { G.C.UI.TEXT_DARK },
												shadow = true,
												scale = 0.4,
												float = true,
											}),
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cl" },
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = DynaText({
												string = credit,
												colours = { G.C.UI.TEXT_INACTIVE },
												scale = 0.3,
											}),
										},
									},
								},
							},
						},
					},
					{ -- index 2
						n = G.UIT.C,
						config = { align = "cl" },
						nodes = { -- 1 more nest at index 1
							toggle,
						},
					},
				},
			},
		},
	}
end

Multiverse.music_credits = {
	{ -- page
		{ -- row
			{ -- song
				"Prophecy", -- title
				"Creo", -- source
			},
			{
				"Life Will Change",
				"Persona 5 OST",
			},
			{
				"Pigstep",
				"Minecraft OST",
			},
			{
				"Hammer of Justice",
				"Deltarune Chapter 4 OST",
			},
		},
		{
			{
				"Sneaky Snitch",
				"Kevin Macleod",
			},
			{
				"Battle Against a True Hero",
				"Undertale OST",
			},
			{
				"Seek",
				"Among Us OST",
			},
		},
		{
			{
				"Main Theme (TF2)",
				"Team Fortress 2 OST",
			},
			{
				"Isolation",
				"NightHawk22",
			},
		},
	},
}

Multiverse.settings_changed = {
	dbg = false,
	jke = false,
}

local exit_mods_hook = G.FUNCS.exit_mods
function G.FUNCS.exit_mods(e)
	if G.ACTIVE_MOD_UI == Multiverse and (Multiverse.settings_changed.jke or Multiverse.settings_changed.dbg) then
		SMODS.save_all_config()
		SMODS.restart_game()
	end
	exit_mods_hook(e)
end

local mod_menu_hook = G.FUNCS.mods_button
function G.FUNCS.mods_button(e)
	if G.ACTIVE_MOD_UI == Multiverse and (Multiverse.settings_changed.jke or Multiverse.settings_changed.dbg) then
		SMODS.save_all_config()
		SMODS.restart_game()
	end
	mod_menu_hook(e)
end

function Multiverse.config_tab_definition()
	local mul_settings = {
		{
			n = G.UIT.R,
			config = { align = "cr" },
			nodes = {
				create_toggle({
					label = localize("mul_debug"),
					active_colour = Multiverse.C.PRIMARY1,
					ref_table = Multiverse.config,
					ref_value = "debug",
					callback = function()
						---@diagnostic disable-next-line: undefined-global
						if not mulDbg then
							Multiverse.config.debug = false
							return
						end
						Multiverse.settings_changed.dbg = not Multiverse.settings_changed.dbg
					end,
				}),
			},
		},
		{
			n = G.UIT.R,
			config = { align = "cr" },
			nodes = {
				create_toggle({
					label = localize("mul_joke"),
					active_colour = Multiverse.C.PRIMARY1,
					ref_table = Multiverse.config,
					ref_value = "joke",
					callback = function()
						Multiverse.settings_changed.jke = not Multiverse.settings_changed.jke
					end,
				}),
			},
		},
	}
	local mul_nodes = Multiverse.create_localized_rows(nil, "mul_config_menu_title", { text_scale = 1.5 })
	mul_nodes[#mul_nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.05 },
				nodes = mul_settings,
			},
		},
	}
	local rows = Multiverse.create_localized_rows(nil, "mul_config_menu_text", { text_scale = 1.25 })
	for _, r in ipairs(rows) do
		mul_nodes[#mul_nodes + 1] = r
	end
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK, padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.1 },
				nodes = mul_nodes,
			},
		},
	}
end

SMODS.current_mod.custom_ui = function(nodes)
	table.remove(nodes, 1)
	table.remove(nodes, 1)
	local centers = {
		"c_mul_philosophers_stone",
		"c_mul_ufo",
		"j_mul_ren_amamiya",
		"c_mul_enchanted_book",
		"c_mul_lightsaber",
		"c_mul_polymerization",
		"sk_mul_jud_slash",
	}
	local funcs = {
		Joker = "your_collection_jokers",
		mul_Myth = "your_collection_mul_myths",
		Tarot = "your_collection_tarots",
		mul_EnchantedBook = "your_collection_mul_deckenchantments",
		mul_Skill = "your_collection_mul_skillcards",
	}
	G.mul_mod_menu_display = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		5.25 * G.CARD_W,
		1 * G.CARD_H,
		{ card_limit = #centers, type = "title", highlight_limit = 0, collection = true }
	)
	for i, key in ipairs(centers) do
		local card = Card(
			G.mul_mod_menu_display.T.x + G.mul_mod_menu_display.T.w / 2,
			G.mul_mod_menu_display.T.y,
			G.CARD_W,
			G.CARD_H,
			G.P_CARDS.empty,
			G.P_CENTERS[key],
			{
				bypass_discovery_center = true,
				bypass_lock = true,
				bypass_discovery_ui = true,
			}
		)
		function card:click()
			Moveable.click(self)
			G.FUNCS[funcs[G.P_CENTERS[key].set]]()
		end
		card.no_ui = true
		card.dissolve = 1
		G.mul_mod_menu_display:emplace(card)
		card.facing = "back"
		card.sprite_facing = "back"
		G.E_MANAGER:add_event(
			Event({
				trigger = "after",
				blocking = false,
				delay = 0.05 + 0.25 * (i - 1),
				func = function()
					card:mul_no_juice_materialize(nil, true, nil, { blocking = false })
					return true
				end,
			}),
			"mul_menu"
		)
		G.E_MANAGER:add_event(
			Event({
				trigger = "after",
				blocking = false,
				delay = 0.05 + 0.25 * (i + 2),
				func = function()
					card:flip()
					return true
				end,
			}),
			"mul_menu"
		)
	end
	nodes[#nodes + 1] = {
		n = G.UIT.R,
		config = {
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.O,
				config = {
					align = "cm",
					object = G.mul_mod_menu_display,
				},
			},
		},
	}
	local title_text = DynaText({
		string = "Multiverse",
		colours = { G.C.UI.TEXT_LIGHT },
		shadow = true,
		float = true,
		silent = true,
		spacing = 5,
		scale = 1.5,
		rotate = true,
		pop_in = 0,
		font = SMODS.Fonts["mul_reflect"],
		text_effect = "mul_ui_multiverse_highlight",
	})
	title_text.states.visible = false
	nodes[#nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.05 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							align = "cm",
							object = title_text,
						},
					},
				},
			},
		},
	}
	nodes[#nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.01 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = Multiverse.version,
							colour = G.C.UI.TEXT_LIGHT,
							scale = 0.3,
						},
					},
				},
			},
		},
	}
	nodes[#nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.05 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize("k_multiverse_desc"),
							colour = G.C.UI.TEXT_LIGHT,
							scale = 0.5,
						},
					},
				},
			},
		},
	}
	nodes[#nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.2 },
		nodes = {
			UIBox_button({
				button = "mul_discord_invite",
				label = { localize("b_mul_discord_server") },
				minw = 5,
				colour = Multiverse.C.PRIMARY1,
				col = true,
			}),
			UIBox_button({
				button = "mul_landing_page",
				label = { localize("b_mul_landing_page") },
				minw = 5,
				colour = Multiverse.C.PRIMARY1,
				col = true,
			}),
		},
	}
end

function G.FUNCS.mul_discord_invite(e)
	love.system.openURL("https://discord.gg/TTEU5K3XC5")
end

function G.FUNCS.mul_landing_page(e)
	love.system.openURL("https://thunderedge.carrd.co/")
end

function Multiverse.display_songs(page)
	rows = {}
	for _, row in ipairs(Multiverse.music_credits[page]) do
		local row_items = {}
		for _, item in ipairs(row) do
			table.insert(row_items, Multiverse.music_toggle(item[1], item[2]))
		end
		table.insert(rows, {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = row_items,
		})
	end
	return {
		n = G.UIT.R,
		config = { align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = rows,
			},
		},
	}
end

function Multiverse.music_tab_definition(page)
	local mul_nodes = Multiverse.create_localized_rows(nil, "mul_music_menu_text", { text_scale = 1.5 })
	table.insert(mul_nodes, Multiverse.display_songs(page))
	local pages = {}
	for i, _ in ipairs(Multiverse.music_credits) do
		table.insert(pages, localize("k_page") .. string.format(" %s/%s", i, #Multiverse.music_credits))
	end
	table.insert(mul_nodes, {
		n = G.UIT.R,
		config = { align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = {},
				nodes = {
					create_option_cycle({
						options = pages,
						current_option = page,
						opt_callback = "mul_select_music_page",
						colour = Multiverse.ui_config.tab_button_colour,
					}),
				},
			},
		},
	})
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK, padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.1 },
				nodes = mul_nodes,
			},
		},
	}
end

function Multiverse.music_tab()
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.BLACK, align = "ct", r = 0.1, padding = 0.1, emboss = 0.05 },
		nodes = {
			{
				n = G.UIT.O,
				config = {
					id = "mul_music_page",
					object = UIBox({
						definition = Multiverse.music_tab_definition(Multiverse.selected_music_page),
						config = { type = "cm" },
					}),
				},
				align = "cm",
			},
		},
	}
end

function G.FUNCS.mul_update_music_toggle(e)
	e.config.colour = (e.config.song_data and Multiverse.config.music[e.config.song_data]) and G.C.GREEN or G.C.RED
	e.children[1].config.tooltip.colour = (e.config.song_data and Multiverse.config.music[e.config.song_data])
			and G.C.GREEN
		or G.C.RED
end

-- Code is based on Handy's UI code
function G.FUNCS.mul_select_music_page(args)
	if not G.OVERLAY_MENU then
		return
	end
	Multiverse.selected_music_page = args.to_key
	-- local def = Multiverse.music_tab_definition(Multiverse.selected_music_page)
	-- local container = G.OVERLAY_MENU:get_UIE_by_ID("mul_music_page")
	-- if container then
	-- 	container.config.object:remove()
	-- 	container.config.object = UIBox({
	-- 		definition = def,
	-- 		config = { type = "cm", parent = container },
	-- 	})
	-- 	container.config.object:recalculate()
	-- end
	local element = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_Music")
	G.FUNCS.change_tab(element)
end

SMODS.current_mod.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			r = 0.1,
			padding = 0.1,
			colour = G.C.BLACK,
		},
		nodes = {
			{
				n = G.UIT.O,
				config = {
					id = "mul_config_menu",
					object = UIBox({
						definition = Multiverse.config_tab_definition(),
						config = { type = "cm" },
					}),
					align = "cm",
				},
			},
		},
	}
end

-- Multiverse.test_ui_def = function()
-- 	return {
-- 		n = G.UIT.ROOT,
-- 		config = {},
-- 		nodes = {},
-- 	}
-- end

SMODS.current_mod.extra_tabs = function()
	return {
		{
			label = "Music",
			tab_definition_function = function()
				return Multiverse.music_tab()
			end,
		},
		-- {
		-- 	label = "Test",
		-- 	tab_definition_function = function()
		-- 		return Multiverse.test_ui_def()
		-- 	end,
		-- },
	}
end

Multiverse.selected_credits_page = 1

function SMODS.current_mod.credits_tab()
	G.mul_credits = {}
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.BLACK, align = "cm", r = 0.1, padding = 0.1, emboss = 0.05 },
		nodes = {
			{
				n = G.UIT.O,
				config = {
					id = "mul_credits_menu",
					object = UIBox({
						definition = Multiverse.credits_tab_definition(Multiverse.selected_credits_page),
						config = { type = "cm" },
					}),
				},
			},
		},
	}
end

Multiverse.credits_table = {
	{ -- page
		{ -- row
			{ -- entry
				card_key = "j_mul_thunderedge",
				desc_key = "k_mul_thunderedge_credits",
				link = "https://github.com/ThunderEdge73/Multiverse",
			},
			{ -- entry
				card_key = "j_mul_proto",
				desc_key = "k_mul_proto_credits",
				link = "https://github.com/ProotTheFoxCodes/Trials-of-the-protogen",
			},
		},
	},
}

function Multiverse.credits_tab_definition(page)
	rows = {}
	for _, row in ipairs(Multiverse.credits_table[page]) do
		local row_items = {}
		for _, item in ipairs(row) do
			table.insert(row_items, Multiverse.generate_credits_desc_nodes(item))
		end
		table.insert(rows, {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = row_items,
		})
	end
	local pages = {}
	for i, _ in ipairs(Multiverse.credits_table) do
		table.insert(pages, localize("k_page") .. string.format(" %s/%s", i, #Multiverse.credits_table))
	end
	table.insert(rows, {
		n = G.UIT.R,
		config = { align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = {},
				nodes = {
					create_option_cycle({
						options = pages,
						current_option = page,
						opt_callback = "mul_select_credits_page",
						colour = Multiverse.ui_config.tab_button_colour,
					}),
				},
			},
		},
	})
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.05 },
				nodes = rows,
			},
		},
	}
end

function G.FUNCS.mul_select_credits_page(args)
	if not G.OVERLAY_MENU then
		return
	end
	Multiverse.selected_credits_page = args.to_key
	-- local def = Multiverse.credits_tab_definition(Multiverse.selected_credits_page)
	-- local container = G.OVERLAY_MENU:get_UIE_by_ID("mul_credits_menu")
	-- if container then
	-- 	container.config.object:remove()
	-- 	container.config.object = UIBox({
	-- 		definition = def,
	-- 		config = { type = "cm", parent = container },
	-- 	})
	-- 	container.config.object:recalculate()
	-- 	container.UIBox:recalculate()
	-- end
	local element = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_Credits")
	G.FUNCS.change_tab(element)
end

function Multiverse.generate_credits_desc_nodes(entry)
	G.mul_credits[#G.mul_credits + 1] = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		G.CARD_W,
		G.CARD_H * 0.9,
		{ card_limit = 1, type = "title", highlight_limit = 0, collection = true }
	)
	local card = Card(
		G.mul_credits[#G.mul_credits].T.x + G.mul_credits[#G.mul_credits].T.w / 2,
		G.mul_credits[#G.mul_credits].T.y,
		G.CARD_W * 0.9,
		G.CARD_H * 0.9,
		G.P_CARDS.empty,
		G.P_CENTERS[entry.card_key],
		{
			bypass_discovery_center = true,
			bypass_lock = true,
			bypass_discovery_ui = true,
		}
	)
	card.no_ui = true
	function card:click()
		Moveable.click(self)
		love.system.openURL(entry.link)
	end
	card.dissolve = 1
	G.mul_credits[#G.mul_credits]:emplace(card)
	card.facing = "back"
	card.sprite_facing = "back"
	G.E_MANAGER:add_event(
		Event({
			trigger = "after",
			blocking = false,
			delay = 0.05,
			func = function()
				card:mul_no_juice_materialize(nil, true, nil, { blocking = false })
				return true
			end,
		}),
		"mul_menu"
	)
	G.E_MANAGER:add_event(
		Event({
			trigger = "after",
			blocking = false,
			delay = 0.8,
			func = function()
				card:flip()
				return true
			end,
		}),
		"mul_menu"
	)
	return {
		n = G.UIT.C,
		config = { align = "ct", padding = 0.05 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							align = "cm",
							object = G.mul_credits[#G.mul_credits],
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = Multiverse.create_localized_rows(nil, entry.desc_key, { text_scale = 1.05 }),
			},
		},
	}
end

function Multiverse.blind_instructions_HUD_def(key)
	return {
		n = G.UIT.ROOT,
		config = {
			padding = 0.05,
			colour = lighten(G.C.JOKER_GREY, 0.5),
			align = "cm",
			r = 0.1,
			detailed_tooltip = { set = "Other", key = "mul_blind_keybind_info" },
			detailed_tooltip_align = "cl",
			detailed_tooltip_offset = { x = -0.1, y = 0 },
		},
		nodes = {
			{
				n = G.UIT.C,
				config = { padding = 0.05, colour = G.C.L_BLACK, align = "cm", r = 0.1, emboss = 0.05 },
				nodes = Multiverse.create_localized_rows("Other", "mul_" .. key .. "_inst"),
			},
		},
	}
end

---Creates a fancy UI that displays text from a loc table
---@param set string
---@param key string
---@param args? {bg_colour: table?, text_scale: number?, loc_vars: table?, no_padding: boolean?}
---@return table
function Multiverse.create_localized_rows(set, key, args)
	args = args or {}
	args.bg_colour = args.bg_colour or G.C.WHITE
	local loc_entry
	args.text_scale = args.text_scale or 1
	if set then
		loc_entry = G.localization.descriptions[set][key]
	else
		loc_entry = G.localization.misc.dictionary[key]
	end
	local rows = {}
	if set then
		table.insert(rows, {
			n = G.UIT.R,
			config = { align = "cm", padding = args.no_padding and 0 or 0.05 },
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm" },
					nodes = {
						{ n = G.UIT.T, config = { text = loc_entry.name, colour = G.C.UI.TEXT_LIGHT, scale = 0.4 } },
					},
				},
			},
		})
		local text_rows = {}
		for _, line in ipairs(loc_entry.text_parsed) do
			table.insert(text_rows, {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = SMODS.localize_box(line, { scale = 0.9 * args.text_scale, vars = args.loc_vars }),
			})
		end
		table.insert(rows, {
			n = G.UIT.R,
			config = {
				align = "cm",
				padding = args.no_padding and 0 or 0.05,
				colour = args.bg_colour,
				r = 0.1,
				emboss = 0.05,
			},
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm", padding = 0.05 },
					nodes = text_rows,
				},
			},
		})
	else
		local text_rows = {}
		for _, line in ipairs(loc_entry) do
			table.insert(text_rows, {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = SMODS.localize_box(
					loc_parse_string(line),
					{ scale = 0.9 * args.text_scale, vars = args.loc_vars }
				),
			})
		end
		table.insert(rows, {
			n = G.UIT.R,
			config = {
				align = "cm",
				padding = args.no_padding and 0 or 0.05,
				colour = args.bg_colour,
				r = 0.1,
				emboss = 0.05,
			},
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm", padding = 0.05 },
					nodes = text_rows,
				},
			},
		})
	end
	return rows
end
