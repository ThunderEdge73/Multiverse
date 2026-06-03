SMODS.Shader({
	key = "enchantment",
	path = "enchantment.fs",
})

---@type table<string, Multiverse.DeckEnchantment>
Multiverse.DeckEnchantments = {}
---@type boolean

Multiverse.C.DECK_ENCHANTMENT = HEX("CAA540")

---@type Multiverse.DeckEnchantment
Multiverse.DeckEnchantment = SMODS.GameObject:extend({
	set = "mul_DeckEnchantment",
	max_level = 1,
	obj_buffer = {},
	obj_table = Multiverse.DeckEnchantments,
	unlocked = true,
	discovered = true,
	config = {},
	class_prefix = "de",
	deck_incompat = {},
	enchant_incompat = {},
	required_params = {
		"key",
		"enchantment_type",
	},
	calculate = function(self, enchantment, context) end,
	add_to_deck = function(self) end,
	remove_from_deck = function(self) end,
	loc_vars = function(self, info_queue, card) end,
	in_pool = function(self)
		return true
	end,
	on_change_level = function(self) end,
	get_level = function(self)
		return (
			G.GAME.mul_deck_enchantments
			and G.GAME.mul_deck_enchantments[self.key]
			and G.GAME.mul_deck_enchantments[self.key].level
		) or 0
	end,
	calc_dollar_bonus = function(self, enchantment) end,
	legendary = false,
	get_weight = function(self)
		return self.base_weight
	end,
	base_weight = 4,
	create_fake_card = function(self)
		local ret = {
			ability = (
				G.GAME.mul_deck_enchantments
				and G.GAME.mul_deck_enchantments[self.key]
				and G.GAME.mul_deck_enchantments[self.key].ability
			) or copy_table(self.config),
			fake_card = true,
			level = self:get_level(),
		}
		if Multiverse.info_queue_levels[self.key] then
			ret.level = Multiverse.info_queue_levels[self.key]
			Multiverse.info_queue_levels[self.key] = nil
		end
		return ret
	end,
	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		if not card then
			card = self:create_fake_card()
		end
		local target = {
			type = "descriptions",
			key = self.key,
			set = self.set,
			nodes = desc_nodes,
			AUT = full_UI_table,
			vars = specific_vars or {},
		}
		local res = {}
		if self.loc_vars and type(self.loc_vars) == "function" then
			res = self:loc_vars(info_queue, card) or {}
			target.vars = res.vars or target.vars
			target.key = res.key or target.key
			target.set = res.set or target.set
			target.scale = res.scale
			target.text_colour = res.text_colour
		end
		if desc_nodes == full_UI_table.main and not full_UI_table.name then
			full_UI_table.name = self.set == "Enhanced" and "temp_value"
				or localize({
					type = "name",
					set = target.set,
					key = res.name_key or target.key,
					nodes = full_UI_table.name,
					vars = res.name_vars or target.vars or {},
				})
		elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= "Enhanced" then
			desc_nodes.name = localize({ type = "name_text", key = res.name_key or target.key, set = target.set })
		end
		desc_nodes.name = Multiverse.parse_vars(desc_nodes.name, target.vars)
		if specific_vars and specific_vars.debuffed and not res.replace_debuff then
			target = {
				type = "other",
				key = "debuffed_" .. (specific_vars.playing_card and "playing_card" or "default"),
				nodes = desc_nodes,
				AUT = full_UI_table,
			}
		end
		if res.main_start then
			desc_nodes[#desc_nodes + 1] = res.main_start
		end
		localize(target)
		if res.main_end then
			desc_nodes[#desc_nodes + 1] = res.main_end
		end
		desc_nodes.background_colour = res.background_colour
	end,
	inject = function(self, i) end,
	register = function(self)
		if self.registered then
			sendWarnMessage(("Detected duplicate register call on object %s"):format(self.key), self.set)
			return
		end
		if self.group_id then
			Multiverse.ENCHANTMENT_GROUPS[self.group_id] = Multiverse.ENCHANTMENT_GROUPS[self.group_id] or {}
			table.insert(Multiverse.ENCHANTMENT_GROUPS[self.group_id], self.key)
		end
		SMODS.GameObject.register(self)
		self.order = #self.obj_buffer
	end,
	process_loc_text = function(self)
		SMODS.GameObject.process_loc_text(self)
		SMODS.process_loc_text(G.localization.misc.dictionary, "k_" .. string.lower(self.key), self.loc_txt, "name")
		SMODS.process_loc_text(
			G.localization.misc.dictionary,
			"b_" .. string.lower(self.key) .. "_cards",
			self.loc_txt,
			"collection"
		)
		SMODS.process_loc_text(
			G.localization.descriptions.Other,
			"undiscovered_" .. string.lower(self.key),
			self.loc_txt,
			"undiscovered"
		)
	end,
})

---@param obj Multiverse.DeckEnchantment
---@param ench_data EnchantmentData
---@param colours table
---@param active_colour table
---@param inactive_colour? table
function Multiverse.handle_deck_enchantment_loc_colours(obj, ench_data, colours, active_colour, inactive_colour)
	for i = 1, obj.max_level do
		if not ench_data or ench_data.level == i or ench_data.level == 0 then
			colours[#colours + 1] = active_colour
		else
			colours[#colours + 1] = inactive_colour or G.C.UI.TEXT_INACTIVE
		end
	end
end

function Multiverse.init_deck_enchantments()
	---@type table<string, EnchantmentData?>
	G.GAME.mul_deck_enchantments = G.GAME.mul_deck_enchantments or {}
	G.GAME.mul_deck_enchantment_order = G.GAME.mul_deck_enchantment_order or {}
	---@type integer
	G.GAME.mul_enchantment_luck = G.GAME.mul_enchantment_luck or 0
	---@type integer
	G.GAME.mul_visible_enchants = G.GAME.mul_visible_enchants or 1
end

---Checks if an enchantment is compatible with current selected deck.
---@param enchantment string
---@return boolean
function Multiverse.is_deck_compat(enchantment)
	for _, key in ipairs(Multiverse.DeckEnchantments[enchantment].deck_incompat) do
		if G.GAME.selected_back.effect.center.key == key then
			return false
		end
	end
	return true
end

---Checks if an enchantment is compatible with any other enchantments on current deck.
---Will also check for compat with other enchantments being simultaneously applied.
---@param enchantment string
---@param other string[]
---@return boolean
function Multiverse.is_enchant_compat(enchantment, other)
	if Multiverse.contains_value(other, enchantment) then -- incompat with self
		return false
	end
	for _, key in ipairs(Multiverse.DeckEnchantments[enchantment].enchant_incompat) do
		if
			(Multiverse.DeckEnchantments[key]:get_level() > 0) -- if incompat with thing already on deck
			or Multiverse.contains_value(other, key) -- if other incompat has been polled
		then
			return false
		end
	end
	return true
end

function Multiverse.is_group_id_compat(enchantment, other)
	local curr_id = Multiverse.DeckEnchantments[enchantment].group_id
	if not curr_id then
		return true
	end
	for _, key in ipairs(Multiverse.ENCHANTMENT_GROUPS[curr_id]) do
		if
			(Multiverse.DeckEnchantments[key]:get_level() > 0) -- if incompat with thing already on deck
			or Multiverse.contains_value(other, key) -- if other incompat has been polled
		then
			return false
		end
	end
	return true
end

---Calculates all applied deck enchantments.
---@param context CalcContext
---@param results table
function Multiverse.calculate_deck_enchantments(context, results)
	if G.GAME.mul_deck_enchantment_order then
		for _, key in ipairs(G.GAME.mul_deck_enchantment_order) do
			local data = G.GAME.mul_deck_enchantments[key]
			results[#results + 1] = Multiverse.DeckEnchantments[key]:calculate(data, context)
		end
	end
end

function Multiverse.level_up_deck_enchantment(enchantment, amt)
	local obj = Multiverse.DeckEnchantments[enchantment]
	if not obj then
		error("Attempt to level up nonexistent deck enchantment")
	end
	local init_level = obj:get_level()
	local final_level = Multiverse.clamp(init_level + amt, 0, obj.max_level)
	local delta = final_level - init_level
	if
		delta == 0
		or (
			not Multiverse.config.debug
			and (
				not Multiverse.is_deck_compat(enchantment)
				or not Multiverse.is_enchant_compat(enchantment, {})
				or not Multiverse.is_group_id_compat(enchantment, {})
			)
		)
	then
		return
	end
	local data = { level = final_level, key = enchantment, ability = copy_table(obj.config) }
	G.GAME.mul_deck_enchantments[enchantment] = G.GAME.mul_deck_enchantments[enchantment] or data
	G.GAME.mul_deck_enchantments[enchantment].level = final_level
	local removed = false
	local added = false
	if init_level == 0 then
		added = true
		G.GAME.mul_deck_enchantment_order[#G.GAME.mul_deck_enchantment_order + 1] = enchantment
	elseif final_level == 0 then
		removed = true
		local ench_to_wipe = -1
		for i, ench in ipairs(G.GAME.mul_deck_enchantment_order) do
			if ench == enchantment then
				ench_to_wipe = i
				break
			end
		end
		table.remove(G.GAME.mul_deck_enchantment_order, ench_to_wipe)
	end
	obj:on_change_level(delta, G.GAME.mul_deck_enchantments[enchantment])
	if added and not G.mul_deck_enchantment_info then
		G.mul_deck_enchantment_info = UIBox({
			definition = Multiverse.deck_enchantment_info_UI_def(),
			config = { align = "bli", offset = { x = 0, y = 0.4 }, major = G.consumeables, instance_type = "CARD" },
		})
		G.mul_deck_enchantment_info.states.collide.can = true
	end
	SMODS.calculate_context({
		mul_deck_enchantments_modified = true,
		amount = delta,
		mul_enchantment_removed = removed,
		mul_enchantment_applied = added,
		mul_enchantment_object = obj,
		mul_enchantment_data = G.GAME.mul_deck_enchantments[enchantment],
	})
	if removed then
		G.GAME.mul_deck_enchantments[enchantment] = nil
	end
end

function Multiverse.count_deck_enchantments()
	local count = 0
	if G.GAME.mul_deck_enchantments then
		for _, key in ipairs(Multiverse.DeckEnchantment.obj_buffer) do
			local level = Multiverse.DeckEnchantments[key]:get_level()
			if level > 0 then
				count = count + 1
			end
		end
	end
	return count
end

function Multiverse.count_deck_enchantment_levels()
	local count = 0
	if G.GAME.mul_deck_enchantments then
		for _, key in ipairs(Multiverse.DeckEnchantment.obj_buffer) do
			local level = Multiverse.DeckEnchantments[key]:get_level()
			if level > 0 then
				count = count + level
			end
		end
	end
	return count
end

function Multiverse.parse_vars(str, vars)
	local safe_vars = vars or {}
	return string.gsub(str, "(#%d+#)", function(matched)
		return tostring(safe_vars[tonumber(string.gsub(matched, "[#%s]", ""), 10)])
	end)
end

function Multiverse.number_to_roman(num)
	if num >= 4000 then
		sendWarnMessage("Attempt to convert " .. num .. " >= 4000 into Roman numeral")
		return "ERROR"
	end
	if num == 1000 then
		return "M"
	elseif num == 500 then
		return "D"
	elseif num == 100 then
		return "C"
	elseif num == 50 then
		return "L"
	elseif num == 10 then
		return "X"
	elseif num == 5 then
		return "V"
	elseif num <= 0 then
		return ""
	end
	if num > 1000 then
		return "M" .. Multiverse.number_to_roman(num - 1000)
	elseif num % 500 >= 400 then
		return "C" .. Multiverse.number_to_roman(num + 100)
	elseif num > 500 then
		return "D" .. Multiverse.number_to_roman(num - 500)
	elseif num > 100 then
		return "C" .. Multiverse.number_to_roman(num - 100)
	elseif num % 50 >= 40 then
		return "X" .. Multiverse.number_to_roman(num + 10)
	elseif num > 50 then
		return "L" .. Multiverse.number_to_roman(num - 50)
	elseif num > 10 then
		return "X" .. Multiverse.number_to_roman(num - 10)
	elseif num % 5 >= 4 then
		return "I" .. Multiverse.number_to_roman(num + 1)
	elseif num > 5 then
		return "V" .. Multiverse.number_to_roman(num - 5)
	else
		return "I" .. Multiverse.number_to_roman(num - 1)
	end
end

function Multiverse.deck_enchantment_info_UI_def()
	return {
		n = G.UIT.ROOT,
		config = {
			colour = G.C.RED,
			r = 0.05,
			padding = 0.05,
			align = "cm",
			minw = 0.45,
			minh = 0.2,
			button = "mul_view_deck_enchantment_details",
			hover = true,
			button_dist = 0,
		},
		nodes = {
			{
				n = G.UIT.T,
				config = {
					text = localize("k_mul_view_deck_enchantments"),
					scale = 0.25,
					colour = G.C.UI.TEXT_LIGHT,
					align = "cm",
				},
			},
		},
	}
end

function G.FUNCS.mul_view_deck_enchantment_details(e)
	G.E_MANAGER:add_event(Event({
		blocking = false,
		blockable = false,
		func = function()
			G.SETTINGS.paused = true
			G.FUNCS.overlay_menu({
				definition = Multiverse.detailed_enchantment_info_UI_def(),
				config = {},
			})
			return true
		end,
	}))
end

function Multiverse.populate_info_queue(set, key)
	local info_queue = {}
	local loc_target = G.localization.descriptions[set][key]
	for _, lines in ipairs(loc_target.text_parsed) do
		for _, part in ipairs(lines) do
			if part.control.T then
				info_queue[#info_queue + 1] = G.P_CENTERS[part.control.T] or G.P_TAGS[part.control.T]
			end
		end
	end
	return info_queue
end

-- shamelessly taken from Galdur lmao
Multiverse.back_desc_ui = function(args)
	local col = G.UIT.R
	local info_col = G.UIT.C
	local info_queue = Multiverse.populate_info_queue("Back", args[1])
	local tooltips = {}
	local back = Back(G.P_CENTERS[args[1]])
	local badges = { n = G.UIT.ROOT, config = { colour = G.C.CLEAR, align = "cm" }, nodes = {} }
	SMODS.create_mod_badges(args[1], badges.nodes)
	if badges.nodes.mod_set then
		badges.nodes.mod_set = nil
	end
	for _, center in pairs(info_queue) do
		local desc = generate_card_ui(center, {
			main = {},
			info = {},
			type = {},
			name = "done",
			badges = badges or {},
			from_detailed_tooltip = true,
		}, nil, center.set, nil)
		tooltips[#tooltips + 1] = {
			n = info_col,
			config = {
				align = "cm",
			},
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						colour = lighten(G.C.JOKER_GREY, 0.5),
						r = 0.1,
						padding = 0.05,
						emboss = 0.05,
					},
					nodes = {
						info_tip_from_rows(desc.info[1], desc.info[1].name),
					},
				},
			},
		}
	end
	return {
		n = G.UIT.C,
		config = { align = "cm", padding = 0.1 },
		nodes = {
			{
				n = col,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.C,
						config = {
							align = "cm",
							minh = 1.5,
							r = 0.1,
							colour = G.C.L_BLACK,
							padding = 0.1,
							outline = 1,
						},
						nodes = {
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									r = 0.1,
									minw = 3,
									maxw = 4,
									minh = 0.4,
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = UIBox({
												definition = {
													n = G.UIT.ROOT,
													config = {
														align = "cm",
														colour = G.C.CLEAR,
													},
													nodes = {
														{
															n = G.UIT.O,
															config = {
																object = DynaText({
																	string = back:get_name(),
																	maxw = 4,
																	colours = { G.C.WHITE },
																	shadow = true,
																	bump = true,
																	scale = 0.5,
																	pop_in = 0,
																	silent = true,
																}),
															},
														},
													},
												},
												config = {
													offset = { x = 0, y = 0 },
													align = "cm",
												},
											}),
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									colour = G.C.WHITE,
									minh = 1.3,
									maxh = 3,
									minw = 3,
									maxw = 4,
									r = 0.1,
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = UIBox({
												definition = back:generate_UI(),
												config = { offset = { x = 0, y = 0 } },
											}),
										},
									},
								},
							},
							badges.nodes[1] and {
								n = G.UIT.R,
								config = {
									align = "cm",
									r = 0.1,
									minw = 3,
									maxw = 4,
									minh = 0.4,
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = UIBox({
												definition = badges,
												config = { offset = { x = 0, y = 0 } },
											}),
										},
									},
								},
							},
						},
					},
				},
			},
			#tooltips > 0 and {
				n = col,
				config = { align = "cm", padding = 0.1 },
				nodes = tooltips,
			} or nil,
		},
	}
end

local create_popup_UIBox_tooltip_hook = create_popup_UIBox_tooltip
function create_popup_UIBox_tooltip(tooltip, ...)
	local ret = create_popup_UIBox_tooltip_hook(tooltip, ...)
	if tooltip.nothing_else then
		ret = {
			n = G.UIT.ROOT,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = ret.nodes[1].nodes,
		}
	end
	return ret
end

function Multiverse.generate_enchantment_details_UIBox(enchantment_center)
	local book = SMODS.create_card({ key = "c_mul_enchanted_book" })
	book.ability.extra.collection_enchant = enchantment_center.key
	book.ability.extra.forced_level = enchantment_center:get_level()
	local book_area = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		G.CARD_W,
		G.CARD_H,
		{ card_limit = 1, type = "title", highlight_limit = 0, collection = true }
	)
	book_area:emplace(book)
	local extra_text = DynaText({
		string = localize("k_mul_normal"),
		colours = { Multiverse.C.DECK_ENCHANTMENT },
		bump = true,
		silent = true,
		scale = 0.6,
		pop_in = 0,
	})
	if enchantment_center.enchantment_type == "negative" then
		extra_text = DynaText({
			string = localize("k_mul_cursed"),
			colours = { G.C.RED },
			silent = true,
			scale = 0.6,
			pop_in = 0,
		})
		extra_text.config.quiver = {
			speed = 0.3,
			amount = 0.1,
			silent = true,
		}
	elseif enchantment_center.legendary then
		extra_text = DynaText({
			string = localize("k_mul_legendary"),
			colours = { G.C.PURPLE },
			silent = true,
			float = true,
			scale = 0.6,
			pop_in = 0,
		})
	end
	local incompat_cards = {}
	for _, key in ipairs(enchantment_center.enchant_incompat) do
		local incompat_book = SMODS.create_card({ key = "c_mul_enchanted_book" })
		incompat_book.ability.extra.collection_enchant = key
		incompat_cards[#incompat_cards + 1] = incompat_book
	end
	if enchantment_center.group_id then
		for _, key in ipairs(Multiverse.ENCHANTMENT_GROUPS[enchantment_center.group_id]) do
			if key ~= enchantment_center.key then
				local incompat_book = SMODS.create_card({ key = "c_mul_enchanted_book" })
				incompat_book.ability.extra.collection_enchant = key
				incompat_cards[#incompat_cards + 1] = incompat_book
			end
		end
	end
	local deck_incompat_box = nil
	if next(enchantment_center.deck_incompat) then
		local deck_incompat_rows = {
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize("k_mul_incompat_with2"),
							scale = 0.4,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
		}
		for _, key in ipairs(enchantment_center.deck_incompat) do
			deck_incompat_rows[#deck_incompat_rows + 1] = {
				n = G.UIT.R,
				config = {
					align = "cm",
					on_demand_tooltip = {
						filler = {
							func = Multiverse.back_desc_ui,
							args = { key },
						},
						nothing_else = true,
					},
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize({ type = "name_text", set = "Back", key = key }),
							scale = 0.4,
							colour = G.C.FILTER,
						},
					},
				},
			}
		end
		deck_incompat_box = {
			n = G.UIT.C,
			config = { align = "cm", padding = 0.1, colour = G.C.BLACK, r = 0.1 },
			nodes = deck_incompat_rows,
		}
	end
	local rows = {
		{
			n = G.UIT.R,
			config = { padding = 0.1, align = "cm" },
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm" },
					nodes = {
						{
							n = G.UIT.O,
							config = { object = book_area },
						},
					},
				},
				{
					n = G.UIT.C,
					config = { align = "cm", padding = 0.1, colour = G.C.BLACK, r = 0.1 },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = extra_text,
									},
								},
							},
						},
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.O,
									config = {
										object = DynaText({
											string = localize("k_mul_deckenchantment"),
											colours = { Multiverse.C.DECK_ENCHANTMENT },
											bump = true,
											silent = true,
											scale = 0.6,
											pop_in = 0,
										}),
									},
								},
							},
						},
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = Multiverse.parse_vars(
											localize("k_mul_level_info"),
											{ enchantment_center:get_level(), enchantment_center.max_level }
										),
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.4,
									},
								},
							},
						},
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize("k_mul_detailed_enchantment_hover_info1"),
										colour = G.C.UI.TEXT_INACTIVE,
										scale = 0.4,
									},
								},
							},
						},
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize("k_mul_detailed_enchantment_hover_info2"),
										colour = G.C.UI.TEXT_INACTIVE,
										scale = 0.4,
									},
								},
							},
						},
					},
				},
				deck_incompat_box,
			},
		},
	}
	if #incompat_cards > 0 then
		local incompat_area = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
			G.ROOM.T.h,
			G.CARD_W * (#incompat_cards * 0.95 + 0.25),
			G.CARD_H,
			{ card_limit = #incompat_cards, type = "title", highlight_limit = 0, collection = true }
		)
		for _, c in ipairs(incompat_cards) do
			incompat_area:emplace(c)
		end
		rows[#rows + 1] = {
			n = G.UIT.R,
			config = { align = "cm", padding = 0.1 },
			nodes = {
				{
					n = G.UIT.T,
					config = { text = localize("k_mul_incompat_with1"), scale = 0.5, colour = G.C.UI.TEXT_LIGHT },
				},
			},
		}
		if incompat_area.T.w > 11 then
			local scrollbox = SMODS.UIScrollBox({
				content = {
					definition = {
						n = G.UIT.ROOT,
						config = { align = "cm", colour = G.C.CLEAR, padding = 0.1 },
						nodes = {
							{
								n = G.UIT.O,
								config = { object = incompat_area },
							},
						},
					},
					config = { align = "cm" },
				},
				overflow = {
					node_config = {
						maxw = 11,
						r = 0.1,
					},
				},
				sync_mode = "progress",
			})
			rows[#rows + 1] = {
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{
						n = G.UIT.O,
						config = { object = scrollbox },
					},
				},
			}
			local bar = SMODS.GUI.scrollbar({
				horizontal = true,
				w = 11,
				h = 0.2,
				colour = Multiverse.C.DECK_ENCHANTMENT,
				bg_colour = { 0, 0, 0, 0.15 },
				scroll_collision_obj = scrollbox,
			})
			bar.config.align = "cm"
			rows[#rows + 1] = bar
		else
			rows[#rows + 1] = {
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{
						n = G.UIT.O,
						config = { object = incompat_area },
					},
				},
			}
		end
	end
	local ui = {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR, padding = 0.1, align = "cm", minh = 8, minw = 12 },
		nodes = rows,
	}
	return ui
end

function G.FUNCS.mul_update_enchantment_detailed_view(e)
	if (Multiverse.DETAILED_ENCHANTMENT_VIEW or {}).key == e.config.center_data.key then
		e.config.colour = Multiverse.C.DECK_ENCHANTMENT
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
	end
end

function G.FUNCS.mul_change_enchantment_detailed_view(e)
	Multiverse.DETAILED_ENCHANTMENT_VIEW = e.config.center_data
	local node = G.OVERLAY_MENU:get_UIE_by_ID("mul_enchantment_details_uibox")
	if node.config.object then
		node.config.object:remove()
		node.config.object = nil
	end
	node.config.object = UIBox({
		definition = Multiverse.generate_enchantment_details_UIBox(Multiverse.DETAILED_ENCHANTMENT_VIEW),
		config = { parent = node, type = "cm" },
	})
	G.OVERLAY_MENU:recalculate()
end

function Multiverse.detailed_enchantment_info_UI_def()
	local all_enchants = Multiverse.map(G.GAME.mul_deck_enchantment_order, function(item)
		return Multiverse.DeckEnchantments[item]
	end)
	for i = 1, math.floor(#all_enchants / 2) do
		all_enchants[i], all_enchants[#all_enchants + 1 - i] = all_enchants[#all_enchants + 1 - i], all_enchants[i]
	end
	Multiverse.DETAILED_ENCHANTMENT_VIEW = all_enchants[1]
	local rows = {}
	for _, enchantment_center in ipairs(all_enchants) do
		local text = localize({
			type = "name_text",
			set = "mul_DeckEnchantment",
			key = enchantment_center.key,
		})
		text = Multiverse.parse_vars(text, { " " .. Multiverse.number_to_roman(enchantment_center:get_level()) })
		local words = {}
		string.gsub(text, "([%a%p]+)", function(w)
			table.insert(words, w)
		end)
		if enchantment_center.max_level > 1 and #words > 1 then
			local level = table.remove(words)
			table.insert(words, table.remove(words) .. " " .. level)
		end
		if enchantment_center.enchantment_type == "negative" and #words >= 3 then
			local curse = table.remove(words, 1)
			local of = table.remove(words, 1)
			table.insert(words, 1, curse .. " " .. of)
		end
		local text_rows = {}
		for _, word in ipairs(words) do
			text_rows[#text_rows + 1] = {
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
		rows[#rows + 1] = {
			n = G.UIT.R,
			config = {
				r = 0.1,
				colour = G.C.UI.BACKGROUND_INACTIVE,
				emboss = 0.05,
				align = "cm",
				func = "mul_update_enchantment_detailed_view",
				button = "mul_change_enchantment_detailed_view",
				center_data = enchantment_center,
				minw = 2,
				shadow = true,
				hover = true,
			},
			nodes = {
				{
					n = G.UIT.C,
					config = { padding = 0.1, align = "cm" },
					nodes = text_rows,
				},
			},
		}
	end
	local scrollbox = SMODS.UIScrollBox({
		content = {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.BLACK, minh = 8 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "ct", padding = 0.1 },
						nodes = rows,
					},
				},
			},
			config = { align = "cm" },
		},
		overflow = {
			node_config = {
				maxh = 8,
				r = 0.1,
			},
		},
		sync_mode = "progress",
	})
	local ench_list_box = {
		n = G.UIT.C,
		config = { align = "cm" },
		nodes = {
			{
				n = G.UIT.R,
				config = { padding = 0.1 },
				nodes = {
					{
						n = G.UIT.C,
						config = {},
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = scrollbox,
								},
							},
						},
					},
					scrollbox.content.T.h > 8 and {
						n = G.UIT.C,
						config = { align = "cm" },
						nodes = {
							SMODS.GUI.scrollbar({
								h = 8,
								w = 0.2,
								colour = Multiverse.C.DECK_ENCHANTMENT,
								bg_colour = { 0, 0, 0, 0.15 },
								scroll_collision_obj = scrollbox,
							}),
						},
					} or nil,
				},
			},
		},
	}
	return {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			minw = G.ROOM.T.w * 5,
			minh = G.ROOM.T.h * 5,
			padding = 0.1,
			r = 0.1,
			colour = { G.C.GREY[1], G.C.GREY[2], G.C.GREY[3], 0.7 },
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { r = 0.3, colour = G.C.JOKER_GREY, padding = 0.07, emboss = 0.1, align = "cm" },
				nodes = {
					{
						n = G.UIT.C,
						config = { colour = G.C.L_BLACK, r = 0.1, padding = 0.2, align = "cm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm" },
								nodes = {
									ench_list_box,
									{
										n = G.UIT.C,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.O,
												config = {
													object = UIBox({
														definition = Multiverse.generate_enchantment_details_UIBox(
															Multiverse.DETAILED_ENCHANTMENT_VIEW
														),
														config = { type = "cm" },
													}),
													id = "mul_enchantment_details_uibox",
												},
											},
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = {
									id = "overlay_menu_back_button",
									align = "cm",
									minw = 2.5,
									padding = 0.1,
									r = 0.1,
									hover = true,
									colour = G.C.ORANGE,
									button = "exit_overlay_menu",
									shadow = true,
									focus_args = { nav = "wide", button = "b" },
								},
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm", padding = 0, no_fill = true },
										nodes = {
											{
												n = G.UIT.T,
												config = {
													text = localize("b_back"),
													scale = 0.5,
													colour = G.C.UI.TEXT_LIGHT,
													shadow = true,
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
end

function Multiverse.update_deck_enchantments()
	if
		Multiverse.count_deck_enchantments() > 0
		and G.deck
		and not G.mul_deck_enchantment_info
		and not Multiverse.in_interaction()
	then
		G.mul_deck_enchantment_info = UIBox({
			definition = Multiverse.deck_enchantment_info_UI_def(),
			config = { align = "bli", offset = { x = 0, y = 0.4 }, major = G.consumeables, instance_type = "CARD" },
		})
		G.mul_deck_enchantment_info.states.collide.can = true
	elseif
		(Multiverse.count_deck_enchantments() == 0 or Multiverse.in_interaction()) and G.mul_deck_enchantment_info
	then
		G.mul_deck_enchantment_info:remove()
		G.mul_deck_enchantment_info = nil
	end
	if G.P_CENTERS["c_mul_enchanted_book"] and not G.P_CENTERS["c_mul_enchanted_book"].alerted then
		G.P_CENTERS["c_mul_enchanted_book"].alerted = true
	end
end

---If this returns an empty table, then the enchantment with the given key should not spawn.
---@param key string
---@param other string[]
---@param source string
---@return integer[]
function Multiverse.get_valid_enchantment_level_ups(key, other, source)
	local obj = Multiverse.DeckEnchantments[key]
	if not obj then
		error("Tried to get data of nonexistent enchantment")
	end
	local levels = {}
	if
		not Multiverse.is_enchant_compat(key, other)
		or not Multiverse.is_deck_compat(key)
		or not Multiverse.is_group_id_compat(key, other)
		or obj:get_weight() == 0
		or not obj:in_pool({ source = source, level_amt = 0 })
	then
		return levels
	end
	local curr_level = obj:get_level()
	for i = 1, obj.max_level do
		if curr_level + i <= obj.max_level and obj:in_pool({ level_amt = i, source = source }) then
			levels[#levels + 1] = i
		end
	end
	return levels
end

---Generates a set of enchantments that would be generated for an enchantment book.
---Set `singular` to true to force this to generate exactly 1 enchantment with a random level increment.
---Set `no_legendary` to true to prevent any legendary enchantments from showing up.
---`key_append` functions similarly to other usages of key_append.
---@param args {key_append: string?, no_legendary: boolean?, source: string?, guaranteed_curse: boolean?, forced_amt: integer?}
function Multiverse.poll_deck_enchantments(args)
	local temp = args or {}
	local key_append = temp.key_append or "default"
	local no_legendary = temp.no_legendary
	local source = temp.source
	local ret = {}
	local polled = {}
	local luck_factor = Multiverse.clamp((G.GAME.mul_enchantment_luck or 0) / 100, 0, 1)
	local amt = args.forced_amt
		or Multiverse.weighted_pseudorandom("mul_ench_amt_" .. key_append, luck_factor, 0.4 + luck_factor / 5, 1, 3)
	if not args.forced_amt and pseudorandom("mul_lucky_4_" .. G.GAME.round_resets.ante, 1, 1000) <= 3 then
		amt = 4
	end
	local legendary_polled = false
	local legendary_pool = {}
	for _, key in ipairs(Multiverse.DeckEnchantment.obj_buffer) do
		local obj = Multiverse.DeckEnchantments[key]
		-- essentially acts as the in_pool check
		local valid_levels = Multiverse.get_valid_enchantment_level_ups(key, polled, source)
		if #valid_levels > 0 then
			local entry = {
				enchant_key = key,
				enchant_obj = obj,
				level_pool = valid_levels,
			}
			if obj.legendary then
				legendary_pool[#legendary_pool + 1] = entry
			end
		end
	end
	local l_ench, l_index
	local generate_legendary = not no_legendary
		and pseudorandom("mul_legendary_ench_" .. G.GAME.round_resets.ante, 1, 1000) <= 3
	if generate_legendary then -- poll for legendary
		legendary_polled = true
		l_ench, l_index = Multiverse.weighted_poll(legendary_pool, function(item)
			return item.enchant_obj:get_weight()
		end, "mul_select_legendary_enchant_" .. key_append)
	end
	if l_ench and l_index and l_index ~= -1 then -- if a legendary was polled
		local level_index = Multiverse.weighted_pseudorandom(
			"mul_generate_level_" .. key_append,
			luck_factor,
			0.4 + luck_factor / 5,
			1,
			#l_ench.level_pool
		)
		ret[#ret + 1] = {
			key = l_ench.enchant_key,
			level_amt = l_ench.level_pool[level_index],
		}
		polled[#polled + 1] = l_ench.enchant_key
		amt = amt - 1
	end
	for _ = 1, amt do
		local base_pool = {}
		local curse_pool = {}
		for _, key in ipairs(Multiverse.DeckEnchantment.obj_buffer) do
			local obj = Multiverse.DeckEnchantments[key]
			-- essentially acts as the in_pool check
			local valid_levels = Multiverse.get_valid_enchantment_level_ups(key, polled, source)
			if #valid_levels > 0 then
				local entry = {
					enchant_key = key,
					enchant_obj = obj,
					level_pool = valid_levels,
				}
				if obj.enchantment_type ~= "negative" then
					base_pool[#base_pool + 1] = entry
				elseif not obj.legendary then
					curse_pool[#curse_pool + 1] = entry
				end
			end
		end
		local ench, index = Multiverse.weighted_poll(base_pool, function(item)
			return item.enchant_obj:get_weight()
		end, "mul_select_enchant_" .. key_append)
		if ench and index > 0 then -- If there is an available enchantment in the pool that was polled
			local curse, c_index
			local has_curse = args.guaranteed_curse
				or (
					not args.forced_amt
					and not legendary_polled
					and pseudorandom("mul_generate_curse_" .. key_append)
						> 0.9 + (G.GAME.mul_enchantment_luck or 0) * 0.09
				)
			if has_curse then -- poll for curse
				curse, c_index = Multiverse.weighted_poll(curse_pool, function(item)
					return item.enchant_obj:get_weight()
				end, "mul_select_curse_" .. key_append)
			end
			if has_curse and curse and c_index ~= -1 then -- if a curse was polled
				local level_index = pseudorandom("mul_generate_level_" .. key_append, 1, #curse.level_pool)
				ret[#ret + 1] = {
					key = curse.enchant_key,
					level_amt = curse.level_pool[level_index],
				}
				polled[#polled + 1] = curse.enchant_key
			else -- use original polled enchantment
				local level_index = Multiverse.weighted_pseudorandom(
					"mul_generate_level_" .. key_append,
					luck_factor,
					0.4 + luck_factor / 5,
					1,
					#ench.level_pool
				)
				ret[#ret + 1] = {
					key = ench.enchant_key,
					level_amt = ench.level_pool[level_index],
				}
				polled[#polled + 1] = ench.enchant_key
			end
		else -- use overflow enchant
			ret[#ret + 1] = {
				key = "de_mul_overflow",
				level_amt = pseudorandom("mul_overflow_level", 1, 3),
			}
		end
	end
	return ret
end

SMODS.ConsumableType({
	key = "mul_EnchantedBook",
	primary_colour = HEX("A61A1F"),
	secondary_colour = HEX("CAA540"),
	shop_rate = 0,
	default = "c_mul_enchanted_book",
	collection_rows = { 1 },
	create_UIBox_your_collection = function(self)
		local type_buf = {}
		for _, v in ipairs(SMODS.ConsumableType.visible_buffer) do
			if not v.no_collection and (not G.ACTIVE_MOD_UI or modsCollectionTally(G.P_CENTER_POOLS[v]).of > 0) then
				type_buf[#type_buf + 1] = v
			end
		end
		local ret = SMODS.card_collection_UIBox(
			G.P_CENTER_POOLS[self.key],
			self.collection_rows,
			{ back_func = #type_buf > 3 and "your_collection_consumables" or nil }
		)
		return ret
	end,
})

Multiverse.info_queue_levels = {}

SMODS.Consumable({
	key = "enchanted_book",
	set = "mul_EnchantedBook",
	atlas = "enchantment_book",
	discovered = true,
	unlocked = true,
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		if card.ability.extra.collection_enchant then
			local ench_key = card.ability.extra.collection_enchant
			local temp = Multiverse.DeckEnchantments[ench_key]:create_fake_card()
			temp.level = card.ability.extra.forced_level or 0
			temp.ability = copy_table(Multiverse.DeckEnchantments[ench_key].config)
			local vars = Multiverse.DeckEnchantments[ench_key]:loc_vars(info_queue, temp) or {}
			vars.set = vars.set or "mul_DeckEnchantment"
			vars.key = vars.key or ench_key
			return vars
		elseif card.ability.extra.enchant_list then
			local main_end = {}
			for index, _ in ipairs(card.ability.extra.enchant_list) do
				if index > G.GAME.mul_visible_enchants then
					local final_str = ""
					local str_pool = "qwertyuiopasdfghjklzxcvbnm"
					for _ = 1, 7 do
						local i = math.random(1, string.len(str_pool))
						final_str = final_str .. str_pool:sub(i, i + 1)
					end
					local dyntxt_obj = DynaText({
						string = { final_str },
						colours = { G.C.UI.TEXT_INACTIVE },
						pop_in_rate = 9999999,
						silent = true,
						random_element = true,
						pop_delay = 0.3,
						scale = 0.32,
						min_cycle_time = 0,
						font = SMODS.Fonts["mul_minecraft_enchantment_font"],
					})
					main_end[#main_end + 1] = {
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = dyntxt_obj,
								},
							},
						},
					}
					main_end[#main_end + 1] = {
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = DynaText({
										string = { "(lvl. ? -> ?)" },
										colours = { G.C.UI.TEXT_INACTIVE },
										pop_in_rate = 9999999,
										silent = true,
										scale = 0.32,
									}),
								},
							},
						},
					}
					-- main_end[#main_end + 1] = {
					-- 	n = G.UIT.R,
					-- 	config = { align = "cm" },
					-- 	nodes = {
					-- 		n = G.UIT.C,
					-- 		config = { align = "cm" },
					-- 		nodes = {
					-- 			{
					-- 				n = G.UIT.R,
					-- 				config = { align = "cm" },
					-- 				nodes = {
					-- 					{
					-- 						n = G.UIT.O,
					-- 						config = {
					-- 							object = dyntxt_obj,
					-- 						},
					-- 					},
					-- 				},
					-- 			},
					-- 			{
					-- 				n = G.UIT.R,
					-- 				config = { align = "cm" },
					-- 				nodes = {
					-- 					{
					-- 						n = G.UIT.O,
					-- 						config = {
					-- 							object = DynaText({
					-- 								string = { "(lvl. ? -> ?)" },
					-- 								colours = { G.C.UI.TEXT_INACTIVE },
					-- 								pop_in_rate = 9999999,
					-- 								silent = true,
					-- 								scale = 0.32,
					-- 							}),
					-- 						},
					-- 					},
					-- 				},
					-- 			},
					-- 		},
					-- 	},
					-- }
				end
			end
			return {
				key = "c_mul_enchanted_book_list_enchants",
				main_end = main_end,
			}
		end
	end,
	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		if not card then
			card = self:create_fake_card()
		end
		local target = {
			type = "descriptions",
			key = self.key,
			set = self.set,
			nodes = desc_nodes,
			AUT = full_UI_table,
			vars = specific_vars or {},
		}
		local res = {}
		if self.loc_vars and type(self.loc_vars) == "function" then
			res = self:loc_vars(info_queue, card) or {}
			target.vars = res.vars or target.vars
			target.key = res.key or target.key
			target.set = res.set or target.set
			target.scale = res.scale
			target.text_colour = res.text_colour
		end

		if desc_nodes == full_UI_table.main and not full_UI_table.name then
			full_UI_table.name = self.set == "Enhanced" and "temp_value"
				or localize({
					type = "name",
					set = target.set,
					key = res.name_key or target.key,
					nodes = full_UI_table.name,
					vars = res.name_vars or target.vars or {},
				})
		elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= "Enhanced" then
			desc_nodes.name = localize({ type = "name_text", key = res.name_key or target.key, set = target.set })
		end
		if specific_vars and specific_vars.debuffed and not res.replace_debuff then
			target = {
				type = "other",
				key = "debuffed_" .. (specific_vars.playing_card and "playing_card" or "default"),
				nodes = desc_nodes,
				AUT = full_UI_table,
			}
		end
		if res.main_start then
			desc_nodes[#desc_nodes + 1] = res.main_start
		end
		localize(target)
		if card.ability.extra.enchant_list then
			for index, value in ipairs(card.ability.extra.enchant_list) do
				if index <= G.GAME.mul_visible_enchants then
					info_queue[#info_queue + 1] = Multiverse.DeckEnchantments[value.key]
					local name = Multiverse.parse_vars(
						localize({ type = "name_text", set = "mul_DeckEnchantment", key = value.key }, ""),
						{ "" }
					)
					local init_level = Multiverse.DeckEnchantments[value.key]:get_level()
					Multiverse.info_queue_levels[value.key] = init_level + value.level_amt
					localize({
						type = "descriptions",
						set = "mul_Dummy",
						key = "du_mul_visible_enchant",
						vars = { name, init_level, init_level + value.level_amt },
						nodes = desc_nodes,
						AUT = full_UI_table,
					})
				end
			end
		end

		if res.main_end then
			desc_nodes[#desc_nodes + 1] = res.main_end
		end
		desc_nodes.background_colour = res.background_colour
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		if card.ability.extra.enchant_list then
			for _, ench in ipairs(card.ability.extra.enchant_list) do
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up()
						local is_newly_enchanted = Multiverse.DeckEnchantments[ench.key]:get_level() == 0
						Multiverse.level_up_deck_enchantment(ench.key, ench.level_amt)
						SMODS.calculate_effect({
							message = is_newly_enchanted and localize("k_mul_enchanted") or localize("k_mul_level_up"),
							instant = true,
						}, G.deck.cards[1] or G.deck)
						return true
					end,
				}))
				delay(1.2)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		if card.ability.extra.collection_enchant then
			badges[#badges + 1] = create_badge(
				localize("k_mul_deckenchantment"),
				G.C.SECONDARY_SET["mul_EnchantedBook"],
				G.C.UI.TEXT_LIGHT,
				1.2
			)
		else
			badges[#badges + 1] = create_badge(
				localize("k_mul_enchantedbook"),
				G.C.SECONDARY_SET["mul_EnchantedBook"],
				G.C.UI.TEXT_LIGHT,
				1.2
			)
		end
	end,
})

function Multiverse.has_deck_enchantment(key)
	return G.GAME.mul_deck_enchantments and G.GAME.mul_deck_enchantments[key]
end