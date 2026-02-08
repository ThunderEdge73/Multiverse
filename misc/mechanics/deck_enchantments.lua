SMODS.Shader({
	key = "enchantment",
	path = "enchantment.fs",
})

---@type table<string, Multiverse.DeckEnchantment>
Multiverse.DeckEnchantments = {}
---@type boolean

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
	---@type integer
	G.GAME.mul_enchantment_luck = G.GAME.mul_enchantment_luck or 0
	---@type integer
	G.GAME.mul_visible_enchants = 1
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
	for _, key in ipairs(Multiverse.DeckEnchantments[enchantment].enchant_incompat) do
		if
			(G.GAME.mul_deck_enchantments[key] and G.GAME.mul_deck_enchantments[key].level > 0)
			or Multiverse.contains_value(other, enchantment)
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
	if G.GAME.mul_deck_enchantments then
		for _, key in ipairs(Multiverse.DeckEnchantment.obj_buffer) do
			local data = G.GAME.mul_deck_enchantments[key]
			if data and data.level > 0 then
				results[#results + 1] =
					Multiverse.DeckEnchantments[key]:calculate(G.GAME.mul_deck_enchantments[key], context)
			end
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
	if delta == 0 then
		return
	end
	local removed = false
	local added = false
	if init_level == 0 then
		obj:add_to_deck()
		added = true
	elseif final_level == 0 then
		obj:remove_from_deck()
		removed = true
	end
	obj:on_change_level(delta, final_level)
	G.GAME.mul_deck_enchantments[enchantment] =
		{ level = final_level, key = enchantment, ability = copy_table(obj.config) }
	SMODS.calculate_context({
		mul_modify_deck_enchantments = true,
		amount = delta,
		mul_enchantment_removed = removed,
		mul_enchantment_applied = added,
		mul_enchantment_object = obj,
	})
end

function Multiverse.count_deck_enchantments()
	local count = 0
	if G.GAME.mul_deck_enchantments then
		for _, key in ipairs(Multiverse.DeckEnchantment.obj_buffer) do
			local level = G.GAME.mul_deck_enchantments[key] and G.GAME.mul_deck_enchantments[key].level or 0
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
			local level = G.GAME.mul_deck_enchantments[key] and G.GAME.mul_deck_enchantments[key].level or 0
			if level > 0 then
				count = count + level
			end
		end
	end
	return count
end

function Multiverse.parse_vars(str, vars)
	return string.gsub(str, "(#%d+#)", function(matched)
		return tostring(vars[tonumber(string.gsub(matched, "[#%s]", ""), 10)])
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
		config = { colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = {
					colour = G.C.RED,
					r = 0.05,
					padding = 0.05,
					align = "cm",
					minw = 0.45,
					minh = 0.2,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "View Deck Enchantments",
									scale = 0.25,
									colour = G.C.UI.TEXT_LIGHT,
									align = "cm",
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
	if Multiverse.count_deck_enchantments() > 0 and G.deck and not G.mul_deck_enchantment_info then
		G.mul_deck_enchantment_info = UIBox({
			definition = Multiverse.deck_enchantment_info_UI_def(),
			config = { align = "bri", offset = { x = -0.1, y = 0.65 }, major = G.consumeables },
		})
		G.mul_deck_enchantment_info.states.collide.can = true
	elseif Multiverse.count_deck_enchantments() == 0 and G.mul_deck_enchantment_info then
		G.mul_deck_enchantment_info:remove()
		G.mul_deck_enchantment_info = nil
	end
	if
		G.mul_deck_enchantment_info
		and G.mul_deck_enchantment_info.states.collide.is
		and G.deck
		and not G.mul_deck_enchantment_tooltip
	then
		local fake_card = {
			ability_UIBox_table = generate_card_ui(Multiverse.DummyCenters["du_mul_all_enchants"]),
			config = {
				center = Multiverse.DummyCenters["du_mul_all_enchants"],
			},
			T = G.deck.T,
		}
		G.mul_deck_enchantment_tooltip = UIBox({
			definition = G.UIDEF.card_h_popup(fake_card),
			config = {
				align = "bm",
				offset = { x = 0, y = 0.2 },
				major = G.mul_deck_enchantment_info,
				instance_type = "POPUP",
			},
		})
		G.mul_deck_enchantment_tooltip.states.collide.can = false
		G.mul_deck_enchantment_tooltip:recalculate()
	elseif
		(not G.mul_deck_enchantment_info or not G.mul_deck_enchantment_info.states.collide.is)
		and G.mul_deck_enchantment_tooltip
	then
		G.mul_deck_enchantment_tooltip:remove()
		G.mul_deck_enchantment_tooltip = nil
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
	local singular = temp.singular
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
	for i = 1, amt do
		local base_pool = {}
		local legendary_pool = {}
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
				if obj.legendary then
					legendary_pool[#legendary_pool + 1] = entry
				elseif obj.enchantment_type ~= "negative" then
					base_pool[#base_pool + 1] = entry
				else
					curse_pool[#curse_pool + 1] = entry
				end
			end
		end
		local ench, index = Multiverse.weighted_poll(base_pool, function(item)
			return item.enchant_obj:get_weight()
		end, "mul_select_enchant_" .. key_append)
		if ench and index > 0 then
			local l_ench, l_index
			local generate_legendary = not no_legendary
				and pseudorandom("mul_legendary_ench_" .. G.GAME.round_resets.ante, 1, 1000) <= 3
			if generate_legendary then
				l_ench, l_index = Multiverse.weighted_poll(legendary_pool, function(item)
					return item.enchant_obj:get_weight()
				end, "mul_select_legendary_enchant_" .. key_append)
			end
			if l_ench and l_index and l_index ~= -1 then
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
			else
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
		else
			ret[#ret + 1] = {
				key = "de_mul_overflow",
				level_amt = pseudorandom("mul_overflow_level", 1, 3),
			}
		end
		if i == amt then
			local has_curse = args.guaranteed_curse
				or (
					not args.forced_amt
					and G.GAME.modifiers.mul_enable_curses
					and pseudorandom("mul_generate_curse_" .. key_append)
						> 0.9 + (G.GAME.mul_enchantment_luck or 0) * 0.09
				)
			if has_curse then
				local curse, c_index = Multiverse.weighted_poll(curse_pool, function(item)
					return item.enchant_obj:get_weight()
				end, "mul_select_curse_" .. key_append)
				if curse and c_index then
					local level_index = pseudorandom("mul_generate_level_" .. key_append, 1, #curse.level_pool)
					ret["curse"] = {
						key = curse.enchant_key,
						level_amt = curse.level_pool[level_index],
					}
				end
			end
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
			temp.level = 0
			temp.ability = copy_table(Multiverse.DeckEnchantments[ench_key].config)
			local vars = Multiverse.DeckEnchantments[ench_key]:loc_vars(info_queue, temp)
			vars.set = vars.set or "mul_DeckEnchantment"
			vars.key = vars.key or ench_key
			return vars
		elseif card.ability.extra.enchant_list then
			return {
				key = "c_mul_enchanted_book_list_enchants",
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
				end
				local name = Multiverse.parse_vars(
					localize({ type = "name_text", set = "mul_DeckEnchantment", key = value.key }, ""),
					{ "" }
				)
				local init_level = Multiverse.DeckEnchantments[value.key]:get_level()
				Multiverse.info_queue_levels[value.key] = init_level + value.level_amt
				localize({
					type = "descriptions",
					set = "mul_Dummy",
					key = index <= G.GAME.mul_visible_enchants and "du_mul_visible_enchant" or "du_mul_hidden_enchant",
					vars = { name, init_level, init_level + value.level_amt },
					nodes = desc_nodes,
					AUT = full_UI_table,
				})
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
