function Multiverse.create_custom_toggle(args)
	args = args or {}
	args.active_colour = args.active_colour or G.C.RED
	args.inactive_colour = args.inactive_colour or G.C.BLACK
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
		config = {
			align = args.align or "cm",
			r = 0.1,
			colour = G.C.CLEAR,
			focus_args = { funnel_from = true },
			padding = 0.1,
		},
		nodes = {
			args.label ~= "" and {
				n = G.UIT.C,
				config = {
					align = args.text_align or "cr",
					minw = args.w,
					tooltip = args.tooltip
						and { text = localize(args.tooltip), text_scale = 1, colour = args.tooltip_colour or G.C.FILTER },
				},
				nodes = {
					{
						n = G.UIT.T,
						config = { text = args.label, scale = args.label_scale, colour = G.C.UI.TEXT_LIGHT },
					},
				},
			} or nil,
			{
				n = G.UIT.C,
				config = { minw = args.w_space, minh = args.h_space or 0 },
			},
			{
				n = G.UIT.C,
				config = { align = "cm" },
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
	if args.reverse and args.label ~= "" then
		t.nodes[1], t.nodes[3] = t.nodes[3], t.nodes[1]
	end
	if args.info then
		t = {
			n = args.col and G.UIT.C or G.UIT.R,
			config = { align = args.align or "cm" },
			nodes = {
				t,
				{
					n = G.UIT.R,
					config = { minh = 0.1, minw = 0.1 },
				},
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
			{
				"Hammer of Justice",
				"Deltarune Chapter 4 OST",
			},
		},
	},
	{
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
		},
	},
}

Multiverse.settings_changed = {}

function Multiverse.has_changed_settings()
	for _, v in pairs(Multiverse.settings_changed) do
		if v then
			return true
		end
	end
	return false
end

local exit_mods_hook = G.FUNCS.exit_mods
function G.FUNCS.exit_mods(e, ...)
	G.E_MANAGER:clear_queue("mul_menu")
	if G.ACTIVE_MOD_UI == Multiverse and Multiverse.has_changed_settings() then
		SMODS.save_all_config()
		SMODS.restart_game()
	end
	exit_mods_hook(e, ...)
end

local mod_menu_hook = G.FUNCS.mods_button
function G.FUNCS.mods_button(e, ...)
	G.E_MANAGER:clear_queue("mul_menu")
	if G.ACTIVE_MOD_UI == Multiverse and Multiverse.has_changed_settings() then
		SMODS.save_all_config()
		SMODS.restart_game()
	end
	mod_menu_hook(e, ...)
end

function Multiverse.config_tab_definition()
	local mul_settings = {
		{
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				Multiverse.create_custom_toggle({
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
					reverse = true,
					align = "cl",
					text_align = "cl",
					tooltip = "mul_dbg_effects",
					tooltip_colour = G.C.RED,
				}),
				Multiverse.create_custom_toggle({
					label = localize("mul_joke"),
					active_colour = Multiverse.C.PRIMARY1,
					ref_table = Multiverse.config,
					ref_value = "joke",
					callback = function()
						Multiverse.settings_changed.jke = not Multiverse.settings_changed.jke
					end,
					reverse = true,
					align = "cl",
					text_align = "cl",
					tooltip = "mul_restart",
					tooltip_colour = G.C.RED,
				}),
			},
		},
	}
	local mul_nodes =
		{ Multiverse.create_localized_rows(nil, "mul_config_menu_title", { text_scale = 2, empty = true }) }
	mul_nodes[#mul_nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm" },
		nodes = mul_settings,
	}
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK, padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
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
		G.CARD_H,
		{ card_limit = #centers, type = "title_2", highlight_limit = 0, collection = true }
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
					if not card.removed then
						play_sound("card1")
					end
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
		string = localize("mul_multiverse"),
		colours = { G.C.UI.TEXT_LIGHT },
		shadow = true,
		float = true,
		silent = true,
		spacing = 5,
		scale = 1.5,
		rotate = true,
		pop_in = 0,
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
	local items = {}
	local entries = localize("mul_mod_items")
	for i = 1, 2 do
		local col = {}
		for j, entry in ipairs(entries) do
			table.insert(col, {
				n = G.UIT.C,
				config = { align = "cm", id = i == 1 and "first_item" or nil },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = SMODS.localize_box(loc_parse_string(entry), { scale = 1.2 }),
					},
				},
			})
			table.insert(col, {
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = SMODS.localize_box(loc_parse_string("{C:white} ~ {}"), { scale = 1.2 }),
					},
				},
			})
		end
		items[#items + 1] = {
			n = G.UIT.C,
			config = { id = i == 1 and "first_item" or nil },
			nodes = col,
		}
	end
	nodes[#nodes + 1] = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.05 },
		nodes = {
			{
				n = G.UIT.O,
				config = {
					object = SMODS.UIScrollBox({
						content = {
							definition = {
								n = G.UIT.ROOT,
								config = { colour = G.C.CLEAR, padding = 0.1 },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = items,
									},
								},
							},
							config = { align = "cm" },
						},
						overflow = {
							node_config = {
								maxw = 10.1,
							},
						},
						sync_mode = "offset",
						scroll_move = function(self, dt)
							if not self.text_size then
								local element = self:get_UIE_by_ID("first_item")
								self.text_size = element.T.w
							end
							self.scroll_offset.x =
								math.fmod((self.scroll_offset.x or 0) + G.real_dt * 1.1, self.text_size)
						end,
					}),
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
				config = { align = "cm", minh = 5 },
				nodes = rows,
			},
		},
	}
end

function Multiverse.music_tab_definition(page)
	local mul_nodes =
		{ Multiverse.create_localized_rows(nil, "mul_music_menu_text", { text_scale = 1.5, minh = 1.2, minw = 14 }) }
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
	local def = Multiverse.music_tab_definition(Multiverse.selected_music_page)
	local container = G.OVERLAY_MENU:get_UIE_by_ID("mul_music_page")
	if container then
		container.config.object:remove()
		container.config.object = UIBox({
			definition = def,
			config = { type = "cm", parent = container },
		})
		container.config.object:recalculate()
	end
	-- local element = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_Music")
	-- G.FUNCS.change_tab(element)
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

Multiverse.test_ui_def = function()
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = {
					minw = 3,
					minh = 0.8,
					mul_custom_draw_func = function(self)
						local t = self.VT or self.T
						local offset = 0.2
						local verts = {
							offset * G.TILESIZE,
							0,
							t.w * G.TILESIZE,
							0,
							(t.w - offset) * G.TILESIZE,
							t.h * G.TILESIZE,
							0,
							t.h * G.TILESIZE,
						}
						love.graphics.setColor(Multiverse.C.PRIMARY1)
						love.graphics.polygon("fill", verts)
					end,
				},
			},
		},
	}
end

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
						definition = Multiverse.credits_tab_definition(),
						config = { type = "cm" },
					}),
				},
			},
		},
	}
end

Multiverse.credits_table = {
	{
		card_key = "j_mul_thunderedge",
		desc_key = "mul_thunderedge_credits",
		link = "https://github.com/ThunderEdge73/Multiverse",
	},
	{
		card_key = "j_mul_proto",
		desc_key = "mul_proto_credits",
		link = "https://github.com/ProotTheFoxCodes/Trials-of-the-protogen",
	},
	"MISC_CREDITS",
}

function Multiverse.credits_tab_definition()
	local rows = {}
	local contributor_text = DynaText({
		string = localize("mul_contributors"),
		colours = { G.C.UI.TEXT_LIGHT },
		shadow = true,
		float = true,
		silent = true,
		spacing = 5,
		scale = 1,
		rotate = true,
		pop_in = 0,
		text_effect = "mul_ui_multiverse_highlight",
	})

	rows[#rows + 1] = {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.1 },
		nodes = {
			{
				n = G.UIT.O,
				config = {
					object = contributor_text,
				},
			},
		},
	}
	for _, entry in ipairs(Multiverse.credits_table) do
		if entry == "MISC_CREDITS" then
			local inspiration_text = DynaText({
				string = localize("mul_inspirations"),
				colours = { G.C.UI.TEXT_LIGHT },
				shadow = true,
				float = true,
				silent = true,
				spacing = 5,
				scale = 1,
				rotate = true,
				pop_in = 0,
				text_effect = "mul_ui_multiverse_highlight",
			})
			rows[#rows + 1] = {
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = inspiration_text,
						},
					},
				},
			}
			rows[#rows + 1] = {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.B,
						config = { w = 1, h = 0.1 },
					},
				},
			}
			local desc_nodes = {}
			localize({
				type = "other",
				key = "mul_misc_credits",
				nodes = desc_nodes,
				vars = {
					colours = {
						darken(HEX("8dffa8"), 0.2),
						HEX("F4A6C7"),
						HEX("800080"),
						HEX("FE0001"),
						HEX("4d1575"),
						HEX("7E7AFF"),
						HEX("ff8c8c"),
						HEX("fd9712"),
						HEX("f51bbc"),
						HEX("7a2eb6"),
						HEX("8b61ad"),
					},
				},
				scale = 1.075,
			})
			credits_rows = {}
			for _, v in ipairs(desc_nodes) do
				credits_rows[#credits_rows + 1] = { n = G.UIT.R, config = { align = "cl" }, nodes = v }
			end
			rows[#rows + 1] = {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", r = 0.1, colour = G.C.WHITE, padding = 0.1 },
						nodes = {
							{ n = G.UIT.C, config = { align = "cm", padding = 0.05 }, nodes = credits_rows },
						},
					},
				},
			}
			rows[#rows + 1] = {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.B,
						config = { w = 1, h = 0.05 },
					},
				},
			}
		else
			rows[#rows + 1] = Multiverse.generate_credits_desc_nodes(entry)
		end
	end
	local scrollbox = SMODS.UIScrollBox({
		content = {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.BLACK, r = 0.1 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", padding = 0.1 },
						nodes = rows,
					},
				},
			},
			config = { align = "cm" },
		},
		overflow = {
			node_config = {
				maxh = 6,
				r = 0.1,
			},
		},
		sync_mode = "progress",
	})
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.BLACK, padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", colour = G.C.L_BLACK, padding = 0.1, r = 0.1, emboss = 0.05 },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							align = "cm",
							object = scrollbox,
						},
					},
				},
			},
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					SMODS.GUI.scrollbar({
						h = 6,
						w = 0.2,
						max = 1,
						min = 0,
						colour = Multiverse.C.TRANSMUTED_GRADIENT_SLOW,
						bg_colour = { 0, 0, 0, 0.15 },
						scroll_collision_obj = scrollbox,
					}),
				},
			},
		},
	}
end

SMODS.draw_ignore_keys["thunderedge_alt"] = true
SMODS.draw_ignore_keys["thunderedge_alt_soul"] = true

function Multiverse.generate_credits_desc_nodes(entry)
	G.mul_credits[#G.mul_credits + 1] = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		G.CARD_W,
		G.CARD_H,
		{ card_limit = 1, type = "title", highlight_limit = 0, collection = true }
	)
	local card = Card(
		G.mul_credits[#G.mul_credits].T.x + G.mul_credits[#G.mul_credits].T.w / 2,
		G.mul_credits[#G.mul_credits].T.y,
		G.CARD_W,
		G.CARD_H,
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
	if entry.card_key == "j_mul_thunderedge" then
		card.mul_thunderedge_credits = true
		card.mul_transition_progress = 0
		card.children.floating_sprite:set_role({ major = card, role_type = "Glued", draw_major = card })
		card.children.thunderedge_alt_soul =
			SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, "mul_contributors", { x = 1, y = 1 })
		card.children.thunderedge_alt =
			SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, "mul_contributors", { x = 0, y = 1 })
		for _, s in ipairs({ "thunderedge_alt", "thunderedge_alt_soul" }) do
			card.children[s].states.hover = card.states.hover
			card.children[s].states.click = card.states.click
			card.children[s].states.drag = card.states.drag
			card.children[s].states.collide.can = false
			card.children[s]:set_role({ major = card, role_type = "Glued", draw_major = card })
		end
		function card:hover()
			Moveable.hover(self)
			G.E_MANAGER:add_event(Event({
				trigger = "ease",
				ref_table = card,
				ref_value = "mul_transition_progress",
				blocking = false,
				blockable = false,
				ease_to = 1,
				delay = 0.15,
			}))
		end
		function card:stop_hover()
			Moveable.stop_hover(self)
			G.E_MANAGER:add_event(Event({
				trigger = "ease",
				ref_table = card,
				ref_value = "mul_transition_progress",
				blocking = false,
				blockable = false,
				ease_to = 0,
				delay = 0.15,
			}))
		end
		function card:update(dt)
			Moveable:update(dt)
		end
	end
	G.mul_credits[#G.mul_credits]:emplace(card)
	return {
		n = G.UIT.R,
		config = { align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
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
				n = G.UIT.C,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{
						n = G.UIT.R,
						config = { padding = 0.05, align = "cm" },
						nodes = localize({
							type = "name",
							key = entry.desc_key,
							set = "Other",
							name_nodes = {},
							vars = {},
						}),
					},
					{
						n = G.UIT.R,
						config = {},
						nodes = { Multiverse.create_localized_rows(nil, entry.desc_key) },
					},
				},
			},
		},
	}
end

---Creates a fancy UI that displays text from a loc table
---@param set string
---@param key string
---@param args? {bg_colour?: table, text_scale?: number, loc_vars?: table, text_colour?: table, align?: "c" | "l" | "r", empty?: boolean, minh?: number, minw?: number}
---@return table
function Multiverse.create_localized_rows(set, key, args)
	args = args or {}
	args.text_scale = args.text_scale or 1
	local desc_nodes = {}
	localize({
		type = "descriptions",
		set = set or "Other",
		key = key,
		nodes = desc_nodes,
		fixed_scale = args.text_scale,
		scale = args.text_scale,
		text_colour = args.text_colour,
		vars = args.loc_vars or {},
	})
	local rows = {}
	for _, v in ipairs(desc_nodes) do
		rows[#rows + 1] = { n = G.UIT.R, config = { align = (args.align or "c") .. "m" }, nodes = v }
	end
	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			colour = args.bg_colour or (args.empty and G.C.CLEAR or G.C.UI.BACKGROUND_WHITE),
			r = 0.1,
			padding = not args.empty and 0.04 or nil,
			minw = args.minw or 2,
			minh = args.minh or 0.8,
			emboss = not args.empty and 0.05 or nil,
			filler = true,
		},
		nodes = {
			{ n = G.UIT.R, config = { align = "cm", padding = 0.03 }, nodes = rows },
		},
	}
end

--#region Other mod link redirects
function G.FUNCS.mul_joy_link()
	love.system.openURL("https://github.com/nh6574/JoyousSpring")
end
function G.FUNCS.mul_akyrs_link()
	love.system.openURL("https://github.com/Aikoyori/Balatro-Aikoyoris-Shenanigans")
end
function G.FUNCS.mul_lobc_link()
	love.system.openURL("https://github.com/Mysthaps/LobotomyCorp")
end
function G.FUNCS.mul_entr_link()
	love.system.openURL("https://github.com/lord-ruby/Entropy")
end
function G.FUNCS.mul_scp_link()
	love.system.openURL("https://github.com/lord-ruby/DataExpunged")
end
function G.FUNCS.mul_pha_link()
	love.system.openURL("https://github.com/GhostSalt/Phanta")
end
function G.FUNCS.mul_catan_link()
	love.system.openURL("https://github.com/GhostSalt/Catan")
end
function G.FUNCS.mul_ghost_link()
	love.system.openURL("https://github.com/GhostSalt")
end
function G.FUNCS.mul_crv_link()
	love.system.openURL("https://github.com/Cdrvo/Revos-Vault")
end
function G.FUNCS.mul_valk_link()
	love.system.openURL("https://github.com/felli-modding-studio/VallKarri")
end
function G.FUNCS.mul_toga_link()
	love.system.openURL("https://github.com/TheOneGoofAli/TOGAPackBalatro")
end
function G.FUNCS.mul_mxms_link()
	love.system.openURL("https://github.com/the-Astra/Maximus")
end
function G.FUNCS.mul_sr_link()
	love.system.openURL("https://github.com/the-Astra/SuperRogue")
end
function G.FUNCS.mul_yahi_link()
	love.system.openURL("https://github.com/Yahiamice/yahimod-balatro")
end
function G.FUNCS.mul_prbk_link()
	love.system.openURL("https://github.com/Balatro-Paperback/paperback")
end

--#endregion

local uie_draw_self = UIElement.draw_self

function UIElement:draw_self(...)
	if self.config.mul_custom_draw_func then
		if not self.states.visible then
			if self.config.force_focus then
				add_to_drawhash(self)
			end
			return
		end
		if
			self.config.force_focus
			or self.config.force_collision
			or self.config.button_UIE
			or self.config.button
			or self.states.collide.can
		then
			add_to_drawhash(self)
		end
		prep_draw(self, 1)
		love.graphics.scale(1 / G.TILESIZE)
		self.config.mul_custom_draw_func(self)
		love.graphics.pop()
	else
		uie_draw_self(self, ...)
	end
end
