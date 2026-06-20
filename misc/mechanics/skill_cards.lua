SMODS.Shader({
	key = "exhausted",
	path = "exhausted.fs",
})

Multiverse.SkillCard = SMODS.Enhancement:extend({
	obj_buffer = {},
	class_prefix = "sk",
	set = "mul_Skill",
	replace_base_card = true,
	no_rank = true,
	no_suit = true,
	atlas = "mul_skill_placeholder",
	required_params = {
		"key",
		"tp_cost",
	},
	can_use_skill = function(self, card)
		return true
	end,
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		local cost = self:get_final_tp_cost(card or self:create_fake_card(), true)
		if not (card and card.area == G.hand) then
			if cost == "X" then
				localize({
					type = "descriptions",
					set = "mul_Dummy",
					key = "du_mul_skill_cost_x",
					nodes = desc_nodes,
					AUT = full_UI_table,
					vars = { cost },
				})
			else
				localize({
					type = "descriptions",
					set = "mul_Dummy",
					key = "du_mul_skill_cost_num",
					nodes = desc_nodes,
					AUT = full_UI_table,
					vars = { cost },
				})
			end
		end
		Multiverse.SkillCard.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	end,
	use_skill = function(self, card) end,
	--- DO NOT OVERRIDE
	get_final_tp_cost = function(self, card, ui_format)
		if ui_format and card.facing == "back" then
			return "?"
		end
		if self.tp_cost == "X" then
			return ui_format and "X" or G.GAME.mul_TP
		end
		local res = {}
		local discount = 0
		local cost_mult = 1
		SMODS.calculate_context({ mul_change_skill_cost = true, other_card = card, mul_base_cost = self.tp_cost }, res)
		for _, eff in pairs(res) do
			for _, tab in pairs(eff) do
				if tab.skill_tp_discount and type(tab.skill_tp_discount) == "number" then
					discount = discount + math.floor(tab.skill_tp_discount) -- flat modifications
				end
				if tab.skill_tp_cost_mult and type(tab.skill_tp_cost_mult) == "number" then
					cost_mult = cost_mult * tab.skill_tp_cost_mult -- multiplicative modifications
				end
			end
		end
		local amt =
			math.max(math.floor((self.tp_cost - (card.ability.mul_skill_tp_discount or 0) - discount) * cost_mult), 0)
		return ui_format and format_ui_value(amt) or amt
	end,
	generate_cost_ui = function(self, card)
		local t = {
			n = G.UIT.ROOT,
			config = {
				minw = 0.6,
				align = "tm",
				colour = darken(G.C.BLACK, 0.2),
				shadow = true,
				r = 0.05,
				padding = 0.05,
				minh = 1,
			},
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						colour = lighten(G.C.BLACK, 0.1),
						r = 0.1,
						minw = 1.05,
						minh = 0.55,
						emboss = 0.05,
						padding = 0.03,
						id = "skill_cost",
					},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = {
										{
											suffix = " " .. localize("k_mul_TP"),
											string = self:get_final_tp_cost(card, true),
										},
									},
									colours = { G.C.FILTER },
									shadow = true,
									silent = true,
									bump = true,
									pop_in = 0,
									scale = 0.45,
								}),
								func = "mul_update_tp_cost",
								ref_table = card,
								align = "cm",
							},
						},
					},
				},
			},
		}
		return UIBox({
			definition = t,
			config = {
				align = "tm",
				offset = { x = 0, y = 0.4 },
				major = card,
				bond = "Weak",
				parent = card,
			},
		})
	end,
	generate_use_ui = function(self, card)
		local t = {
			n = G.UIT.ROOT,
			config = {
				ref_table = card,
				minw = 1.1,
				maxw = 1.3,
				padding = 0.1,
				align = "bm",
				colour = G.C.GREEN,
				shadow = true,
				r = 0.08,
				minh = 0.94,
				func = "mul_can_use_skill",
				one_press = true,
				button = "mul_use_skill",
				hover = true,
			},
			nodes = {
				{ n = G.UIT.T, config = { text = localize("b_use"), colour = G.C.WHITE, scale = 0.5 } },
			},
		}
		return UIBox({
			definition = t,
			config = {
				align = "bm",
				offset = { x = 0, y = -0.3 },
				major = card,
				bond = "Weak",
				parent = card,
			},
		})
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_mul_skill"), G.C.FILTER, nil, 1.2)
	end,
})

G.FUNCS.mul_update_tp_cost = function(e)
	local card = e.config.ref_table
	local center = card.config.center
	local old_str = e.config.object.config.string[1].string
	e.config.object.config.string[1].string = center:get_final_tp_cost(card, true)
	if old_str ~= center:get_final_tp_cost(card, true) then
		e.config.object:update_text(true)
		card.children.mul_skill_cost_ui:recalculate()
	end
end

G.FUNCS.mul_can_use_skill = function(e)
	local card = e.config.ref_table
	local center = card.config.center
	if
		G.GAME.blind.in_blind
		and card:mul_can_use_generic()
		and #G.hand.highlighted == 1
		and G.hand.highlighted[1] == card
		and G.GAME.mul_TP >= center:get_final_tp_cost(card)
		and (center.tp_cost ~= "X" or G.GAME.mul_TP > 0 or G.GAME.mul_x_boost > 0)
		and not card.debuff
		and center:can_use_skill(card)
	then
		e.config.button = "mul_use_skill"
		e.config.colour = G.C.GREEN
	else
		e.config.button = nil
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
	end
end

function Multiverse.handle_sneaky_trigggers(cards)
	local prev_state = G.STATE
	G.TAROT_INTERRUPT = G.STATE
	G.STATE = G.STATES.PLAY_TAROT
	G.CONTROLLER.locks.use = true
	for i, c in ipairs(cards) do
		delay(0.2)
		Multiverse.draw_card(G.hand, G.play, i * 100 / #cards, "up", nil, c)
		delay(0.2)
	end
	for _, c in ipairs(cards) do
		local center = c.config.center
		delay(0.2)
		local res = center:use_skill(c, 0, G.GAME.mul_x_boost) or "discard"
		delay(0.6)
		SMODS.calculate_context({ mul_using_skill = true, other_card = c })
		if res == "discard" then
			c.ability.discarded = true
			Multiverse.draw_card(G.play, G.discard, 100, "down", false, c)
		elseif res == "retain" then
			Multiverse.draw_card(G.play, G.hand, 100, "up", false, c)
		elseif res == "destroy" then
			SMODS.destroy_cards(c, { immediate = true })
		else
			Multiverse.exhaust_cards(c, true)
		end
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					G.STATE = prev_state
					G.TAROT_INTERRUPT = nil
					G.CONTROLLER.locks.use = false
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					save_run()
					return true
				end,
			}))
			return true
		end,
	}))
end

G.FUNCS.mul_use_skill = function(e)
	local card = e.config.ref_table
	local center = card.config.center
	local prev_state = G.STATE
	G.TAROT_INTERRUPT = G.STATE
	G.STATE = G.STATES.PLAY_TAROT
	G.CONTROLLER.locks.use = true
	local paid = center:get_final_tp_cost(card)
	local x = nil
	if center.tp_cost == "X" then
		x = paid + G.GAME.mul_x_boost
	end
	Multiverse.ease_TP(-paid, { from_skill = true, immediate = true })
	Multiverse.draw_card(G.hand, G.play, 1, "up", true, card, nil, true)
	delay(0.2)
	local res = center:use_skill(card, paid, x) or "discard"
	delay(0.6)
	SMODS.calculate_context({ mul_using_skill = true, other_card = card })
	if res == "discard" then
		card.ability.discarded = true
		Multiverse.draw_card(G.play, G.discard, 100, "down", false, card)
	elseif res == "retain" then
		Multiverse.draw_card(G.play, G.hand, 100, "up", false, card)
	elseif res == "destroy" then
		SMODS.destroy_cards(card, { immediate = true })
	else
		Multiverse.exhaust_cards(card, true)
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					G.STATE = prev_state
					G.TAROT_INTERRUPT = nil
					G.CONTROLLER.locks.use = false
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					save_run()
					return true
				end,
			}))
			return true
		end,
	}))
end

local inject_objects_hook = SMODS.injectObjects
function SMODS.injectObjects(class, ...)
	inject_objects_hook(class, ...)
	if class == SMODS.GameObject then
		Multiverse.SkillCard:inject_class()
	end
end

Multiverse.C.INTERACTION_BG = HEX("00000000")

function Multiverse.interaction_UI_def(text)
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", minw = 100, minh = 100, colour = Multiverse.C.INTERACTION_BG },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							id = "interaction_text",
							align = "cm",
							object = DynaText({
								string = { text },
								bump = true,
								scale = 0.8,
								colours = { G.C.UI.TEXT_LIGHT },
								silent = true,
								shadow = true,
								pop_in = 0,
							}),
						},
					},
				},
			},
		},
	}
end

---@param args {select_limit?: number, area?: visibleInteractionArea, display_text?: string, end_interaction?: fun(), can_end_interaction?: fun(): boolean?}
---@param card Card?
function Multiverse.start_interaction(args, card)
	args = args or {}
	args.area = args.area or "hand"
	if args.area == "discard" and not card then
		error("Need to specify card that triggers the interaction")
	end
	args.select_limit = args.select_limit or math.huge
	args.display_text = args.display_text or "ERROR"
	Multiverse.can_end_interaction = args.can_end_interaction or function()
		return true
	end
	Multiverse.on_end_interaction = args.end_interaction or function() end
	G.E_MANAGER:add_event(Event({
		func = function()
			G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							Multiverse.show_interaction_ui(args.display_text, args.area, card, args.select_limit)
							return true
						end,
					}))
					return true
				end,
			}))
			return true
		end,
	}))
end

function G.FUNCS.mul_can_confirm_end_interaction(e)
	if type(Multiverse.can_end_interaction) == "function" and Multiverse.can_end_interaction() then
		e.config.colour = G.C.FILTER
		e.config.button = "mul_end_interaction"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

---@type fun(): boolean?
function Multiverse.can_end_interaction()
	return true
end

---@type fun()
function Multiverse.on_end_interaction() end

function G.FUNCS.mul_end_interaction(e)
	Multiverse.on_end_interaction()
	G.E_MANAGER:add_event(Event({
		func = function()
			Multiverse.remove_interaction_ui()
			return true
		end,
	}))
end

function Multiverse.confirm_end_interaction_UI_def()
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR, align = "cm" },
		nodes = {
			{
				n = G.UIT.R,
				config = { colour = G.C.CLEAR, align = "cm", padding = 0.2 },
				nodes = {
					UIBox_button({
						label = { localize("k_mul_run_info") },
						button = "run_info",
						colour = G.C.RED,
						col = true,
					}),
					UIBox_button({
						label = { localize("k_mul_confirm") },
						func = "mul_can_confirm_end_interaction",
						colour = G.C.UI.BACKGROUND_INACTIVE,
						col = true,
					}),
				},
			},
		},
	}
end

function Multiverse.build_discard_view_UI_def(cards_to_display, highlighted_max)
	G.mul_discard_view_areas = {}
	local rows = {}
	local cards_left = #cards_to_display
	while cards_left > 0 do
		local size = math.min(cards_left, 5)
		local area = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
			G.ROOM.T.h,
			size * G.CARD_W,
			1.03 * G.CARD_H,
			{ card_limit = size, type = "title", highlight_limit = math.huge, collection = true }
		)
		G.mul_discard_view_areas[#G.mul_discard_view_areas + 1] = area
		cards_left = cards_left - size
		rows[#rows + 1] = {
			n = G.UIT.R,
			config = { padding = 0.1, align = "cl" },
			nodes = {
				{
					n = G.UIT.O,
					config = {
						object = area,
					},
				},
			},
		}
	end
	local i, n = 1, 0
	G.mul_discard_view_areas._discard_select_data = { max = highlighted_max, highlighted = {} }
	for index_ref, c in ipairs(G.discard.cards) do
		if Multiverse.contains_value(cards_to_display, c) then
			n = n + 1
			local card = copy_card(c)
			card.ability._mul_index_ref = index_ref
			function card:click()
				if card.ability._mul_discard_view_selected then
					card.ability._mul_discard_view_selected = false
					local index_to_remove = -1
					for k, v in ipairs(G.mul_discard_view_areas._discard_select_data.highlighted) do
						if v == card.ability._mul_index_ref then
							index_to_remove = k
						end
					end
					table.remove(G.mul_discard_view_areas._discard_select_data.highlighted, index_to_remove)
				elseif
					G.mul_discard_view_areas._discard_select_data.max
					> #G.mul_discard_view_areas._discard_select_data.highlighted
				then
					card.ability._mul_discard_view_selected = true
					table.insert(G.mul_discard_view_areas._discard_select_data.highlighted, card.ability._mul_index_ref)
				else
					local index_to_find = table.remove(G.mul_discard_view_areas._discard_select_data.highlighted, 1)
					for _, area in ipairs(G.mul_discard_view_areas) do
						for _, area_card in ipairs(area.cards) do
							if area_card.ability._mul_index_ref == index_to_find then
								area_card.ability._mul_discard_view_selected = false
								index_to_find = nil
								break
							end
						end
						if not index_to_find then
							break
						end
					end
					card.ability._mul_discard_view_selected = true
					table.insert(G.mul_discard_view_areas._discard_select_data.highlighted, card.ability._mul_index_ref)
				end
			end
			G.mul_discard_view_areas[i]:emplace(card)
			if n >= G.mul_discard_view_areas[i].config.card_limit then
				i = i + 1
				n = 0
			end
		end
	end
	local scrollbox = SMODS.UIScrollBox({
		content = {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR, padding = 0.1, align = "cm" },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cl", padding = 0.1 },
						nodes = rows,
					},
				},
			},
			config = { align = "cm" },
		},
		overflow = {
			node_config = {
				align = "tm",
				maxh = 6.5,
				r = 0.1,
				minw = 5.5 * G.CARD_W,
				padding = 0.1,
			},
		},
		sync_mode = "progress",
	})
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = scrollbox,
						},
					},
				},
			},
			scrollbox.content.T.h > 6.5 and {
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					SMODS.GUI.scrollbar({
						h = 6.5,
						w = 0.2,
						max = 1,
						min = 0,
						colour = G.C.FILTER,
						bg_colour = { 0, 0, 0, 0.15 },
						scroll_collision_obj = scrollbox,
						scroll_mult = 1.25,
					}),
				},
			} or nil,
		},
	}
end

function Multiverse.get_discard_view_selected()
	if G.STATE ~= G.STATES.MULTIVERSE_INTERACTION_DISCARD or not G.mul_discard_view_areas then
		return {}
	end
	local cards = Multiverse.map(G.mul_discard_view_areas._discard_select_data.highlighted, function(item)
		return G.discard.cards[item]
	end)
	return cards
end

G.STATES.MULTIVERSE_INTERACTION_HAND = -10
G.STATES.MULTIVERSE_INTERACTION_JOKERS = -11
G.STATES.MULTIVERSE_INTERACTION_CONSUMABLES = -12
G.STATES.MULTIVERSE_INTERACTION_DISCARD = -13
Multiverse.interaction_old_data = {}

---@alias visibleInteractionArea
---| "hand"
---| "jokers"
---| "consumables"
---| "discard"

---@param text string
---@param area? visibleInteractionArea
---@param card? Card For use specifically with the discard view interaction
---@param highlighted_max? number
function Multiverse.show_interaction_ui(text, area, card, highlighted_max)
	if Multiverse.in_interaction() then
		return
	end
	local visible = area or "hand"
	if G.mul_interact_menu then
		G.mul_interact_menu:remove()
		G.mul_interact_menu = nil
	end
	if visible == "hand" then
		G.STATE = G.STATES.MULTIVERSE_INTERACTION_HAND
		Multiverse.interaction_old_data.highlighted_limit = G.hand.config.highlighted_limit
	elseif visible == "jokers" then
		G.STATE = G.STATES.MULTIVERSE_INTERACTION_JOKERS
		Multiverse.interaction_old_data.highlighted_limit = G.jokers.config.highlighted_limit
	elseif visible == "consumables" then
		G.STATE = G.STATES.MULTIVERSE_INTERACTION_CONSUMABLES
		Multiverse.interaction_old_data.highlighted_limit = G.consumeables.config.highlighted_limit
	elseif visible == "discard" then
		G.STATE = G.STATES.MULTIVERSE_INTERACTION_DISCARD
	else
		error("Invalid interaction focus area")
	end
	Multiverse.interaction_old_data.affected = visible
	G.mul_interact_menu = UIBox({
		definition = Multiverse.interaction_UI_def(text),
		config = { offset = { x = 0, y = visible == "discard" and -4.5 or -1.5 }, major = G.ROOM_ATTACH, align = "cm" },
	})
	G.mul_end_interact_button = UIBox({
		definition = Multiverse.confirm_end_interaction_UI_def(),
		config = { offset = { x = 0, y = 2 }, major = G.ROOM_ATTACH, align = "bm" },
	})
	if visible == "hand" then
		G.hand.T.x = 3.8536585365854
		G.hand:hard_set_VT()
		if G.buttons then
			G.buttons:set_alignment({ offset = { x = 0, y = 3 } })
		end
		G.jokers.T.y = -4
		G.consumeables.T.y = -4
		G.hand.config.highlighted_limit = highlighted_max
	elseif visible == "jokers" then
		G.consumeables.T.y = -4
		G.jokers.T.x = 3.8536585365854 + (G.hand.T.w - G.jokers.T.w) / 2
		G.jokers.T.y = G.TILE_H - G.jokers.T.h - 1.9
		G.jokers.config.highlighted_limit = highlighted_max
	elseif visible == "consumables" then
		G.jokers.T.y = -4
		G.consumeables.T.x = 3.8536585365854 + (G.hand.T.w - G.consumeables.T.w) / 2
		G.consumeables.T.y = G.TILE_H - G.consumeables.T.h - 1.9
		G.consumeables.config.highlighted_limit = highlighted_max
	else
		G.jokers.T.y = -4
		G.consumeables.T.y = -4
		local c = Multiverse.filter(G.discard.cards, function(item)
			return item ~= card
		end)
		G.mul_discard_view = UIBox({
			definition = Multiverse.build_discard_view_UI_def(c, highlighted_max),
			config = { offset = { x = 0, y = 0 }, major = G.ROOM_ATTACH, align = "cm" },
		})
	end
	Multiverse.hide_TP_meter()
	G.HUD:set_alignment({ offset = { x = -6.7, y = 0 } })
	G.E_MANAGER:add_event(Event({
		trigger = "ease",
		ref_table = G.mul_end_interact_button.config.offset,
		ref_value = "y",
		ease_to = G.mul_end_interact_button.config.offset.y - 3.5,
		timer = "REAL",
		blockable = false,
		blocking = false,
		delay = 0.2,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "ease",
		ref_table = Multiverse.C.INTERACTION_BG,
		ref_value = 4,
		ease_to = 0.5,
		delay = 0.3,
		timer = "REAL",
	}))
end

local can_use_consumable_hook = Card.can_use_consumeable
function Card:can_use_consumeable(any_state, skip_check, ...)
	local ret = can_use_consumable_hook(self, any_state, skip_check, ...)
	if
		G.STATE ~= G.STATES.HAND_PLAYED
			and G.STATE ~= G.STATES.DRAW_TO_HAND
			and G.STATE ~= G.STATES.PLAY_TAROT
			and not Multiverse.in_interaction()
		or any_state
	then
		return ret
	end
	return false
end

function Multiverse.remove_interaction_ui()
	if Multiverse.in_interaction() then
		if Multiverse.interaction_old_data.affected == "hand" then
			G.hand.config.highlighted_limit = Multiverse.interaction_old_data.highlighted_limit
			G.hand:unhighlight_all()
		elseif Multiverse.interaction_old_data.affected == "jokers" then
			G.jokers.config.highlighted_limit = Multiverse.interaction_old_data.highlighted_limit
			G.jokers:unhighlight_all()
		elseif Multiverse.interaction_old_data.affected == "consumables" then
			G.consumeables.config.highlighted_limit = Multiverse.interaction_old_data.highlighted_limit
			G.consumeables:unhighlight_all()
		end
		if G.mul_discard_view then
			G.mul_discard_view:remove()
			G.mul_discard_view = nil
		end
		G.mul_discard_view_areas = nil
		G.mul_interact_menu:get_UIE_by_ID("interaction_text").config.object:pop_out(3)
		G.STATE = G.STATES.SELECTING_HAND
		G.hand.T.x = G.TILE_W - G.hand.T.w - 2.85
		G.hand:hard_set_VT()
		if G.buttons then
			G.buttons:set_alignment({ offset = { x = 0, y = 0.3 } })
		end
		G.jokers.T.y = 0
		G.jokers.T.x = G.hand.T.x - 0.1
		G.consumeables.T.y = 0
		G.consumeables.T.x = G.jokers.T.x + G.jokers.T.w + 0.2
		Multiverse.show_TP_meter()
		G.HUD:set_alignment({ offset = { x = -0.7, y = 0 } })
		G.E_MANAGER:add_event(Event({
			trigger = "ease",
			ref_table = G.mul_end_interact_button.config.offset,
			ref_value = "y",
			ease_to = G.mul_end_interact_button.config.offset.y + 3.5,
			timer = "REAL",
			blockable = false,
			blocking = false,
			delay = 0.2,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "ease",
			ref_table = Multiverse.C.INTERACTION_BG,
			ref_value = 4,
			ease_to = 0,
			delay = 0.3,
			timer = "REAL",
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				G.mul_interact_menu:remove()
				G.mul_interact_menu = nil
				G.mul_end_interact_button:remove()
				G.mul_end_interact_button = nil
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function()
						save_run()
						return true
					end,
				}))
				return true
			end,
		}))
	end
end

local save_hook = save_run
function save_run(...)
	if not Multiverse.in_interaction() then
		save_hook(...)
	end
end

function Multiverse.init_skills()
	---@type integer
	G.GAME.mul_x_boost = G.GAME.mul_x_boost or 0
	---@type table
	G.GAME.mul_skill_usage = G.GAME.mul_skill_usage or {
		run = 0,
		round = 0,
	}
end

function Multiverse.get_final_X_value(center, card, ui_format, with_paren)
	if not center.set == "mul_Skill" then
		error("center is not mul_Skill")
	end
	if not center.tp_cost == "X" then
		error("center does not have its cost set to X")
	end
	if ui_format then
		local mod = G.GAME.mul_x_boost or 0
		local str = "X"
		if mod > 0 then
			str = str .. " + " .. format_ui_value(mod)
		elseif mod < 0 then
			str = str .. " - " .. format_ui_value(math.abs(mod))
		end
		if with_paren and mod ~= 0 then
			str = "(" .. str .. ")"
		end
		return str
	end
	return center:get_final_tp_cost(card, false) + (G.GAME.mul_x_boost or 0)
end

local has_no_suit_hook = SMODS.has_no_suit
function SMODS.has_no_suit(card, ...)
	if card.ability.set == "mul_Skill" then
		return true
	end
	return has_no_suit_hook(card, ...)
end

local has_no_rank_hook = SMODS.has_no_rank
function SMODS.has_no_rank(card, ...)
	if card.ability.set == "mul_Skill" then
		return true
	end
	return has_no_rank_hook(card, ...)
end

local never_scores_hook = SMODS.never_scores
function SMODS.never_scores(card, ...)
	if card.ability.set == "mul_Skill" then
		return true
	end
	return never_scores_hook(card, ...)
end
