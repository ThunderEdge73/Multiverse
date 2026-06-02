G.SETTINGS.multiverse_tutorial = G.SETTINGS.multiverse_tutorial or {}

---@param context CalcContext
function Multiverse.handle_tutorials(context)
	if
		context.mul_deck_enchantments_modified
		and context.mul_enchantment_applied
		and not G.SETTINGS.multiverse_tutorial["deck_enchantment_view"]
	then
		G.SETTINGS.multiverse_tutorial["deck_enchantment_intro"] = true
		Multiverse.deck_enchantment_view_tutorial()
	end
	if
		context.open_booster
		and (context.booster.kind == "mul_enchantment" or context.booster.kind == "mul_dimension")
		and not G.SETTINGS.multiverse_tutorial["deck_enchantment_intro"]
	then
		G.E_MANAGER:add_event(Event({
			func = function()
				local has_book = false
				for _, c in ipairs(G.pack_cards.cards) do
					if c.ability.set == "mul_EnchantedBook" then
						has_book = true
						break
					end
				end
				if has_book then
					G.SETTINGS.multiverse_tutorial["deck_enchantment_intro"] = true
					Multiverse.deck_enchantment_tutorial()
				end
				return true
			end,
		}))
	end
	if
		context.end_of_round
		and context.main_eval
		and not context.game_over
		and not G.SETTINGS.multiverse_tutorial["thaumaturgy_energy"]
	then
		G.SETTINGS.multiverse_tutorial["thaumaturgy_energy"] = true
		Multiverse.thaumaturgy_energy_tutorial()
	end
	if context.mul_TP_altered and not G.SETTINGS.multiverse_tutorial["tp"] then
		G.SETTINGS.multiverse_tutorial["tp"] = true
		Multiverse.tp_tutorial()
	end
	if context.hand_drawn and not G.SETTINGS.multiverse_tutorial["skill"] then
		local found_skill = false
		for _, c in ipairs(context.hand_drawn) do
			if c.ability.set == "mul_Skill" then
				found_skill = true
				break
			end
		end
		if found_skill then
			G.SETTINGS.multiverse_tutorial["skill"] = true
			Multiverse.skill_tutorial()
		end
	end
	if
		context.card_added
		and context.card.config.center_key == "c_mul_philosophers_stone"
		and not G.SETTINGS.multiverse_tutorial["phil_stone"]
	then
		G.SETTINGS.multiverse_tutorial["phil_stone"] = true
		Multiverse.phil_stone_tutorial()
	end
	if
		context.card_added
		and Multiverse.can_receive_transmutable(context.card)
		and not G.SETTINGS.multiverse_tutorial["transmute"]
	then
		G.SETTINGS.multiverse_tutorial["transmute"] = true
		Multiverse.transmute_tutorial(context.card)
	end
end

function Multiverse.deck_enchantment_tutorial()
	G.SETTINGS.paused = true
	local step = 1
	step = tutorial_info({
		text_key = "mul_de_1",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_de_2",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_de_3",
		highlight = { G.pack_cards },
		attach = { major = G.pack_cards, type = "cl", offset = { x = -1.5, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_de_4",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_de_5",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end

function Multiverse.deck_enchantment_view_tutorial()
	G.SETTINGS.paused = true
	local step = 1
	step = tutorial_info({
		text_key = "mul_de_view_1",
		highlight = { G.mul_deck_enchantment_info },
		attach = { major = G.mul_deck_enchantment_info, type = "cm", offset = { x = -3, y = 0 } },
		step = step,
		no_button = true,
		button_listen = "mul_view_deck_enchantment_details",
		align = "cl",
		multiverse_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end

function Multiverse.thaumaturgy_energy_tutorial()
	G.SETTINGS.paused = true
	local step = 1
	step = tutorial_info({
		text_key = "mul_tha_1",
		highlight = { G.HUD:get_UIE_by_ID("row_thaumaturgy") },
		attach = { major = G.HUD:get_UIE_by_ID("row_thaumaturgy"), type = "cm", offset = { x = 0, y = -4 } },
		step = step,
		align = "cr",
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_tha_2",
		highlight = { G.HUD:get_UIE_by_ID("row_thaumaturgy") },
		attach = { major = G.HUD:get_UIE_by_ID("row_thaumaturgy"), type = "cm", offset = { x = 0, y = -4 } },
		step = step,
		align = "cr",
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_tha_3",
		highlight = { G.HUD:get_UIE_by_ID("row_thaumaturgy") },
		attach = { major = G.HUD:get_UIE_by_ID("row_thaumaturgy"), type = "cm", offset = { x = 0, y = -4 } },
		step = step,
		align = "cr",
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_tha_4",
		highlight = { G.HUD:get_UIE_by_ID("row_thaumaturgy") },
		attach = { major = G.HUD:get_UIE_by_ID("row_thaumaturgy"), type = "cm", offset = { x = 0, y = -4 } },
		step = step,
		align = "cr",
		multiverse_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end

function Multiverse.tp_tutorial()
	G.SETTINGS.paused = true
	local step = 1
	step = tutorial_info({
		text_key = "mul_tp_1",
		highlight = { G.mul_TP_meter },
		attach = { major = G.mul_TP_meter, type = "cm", offset = { x = -3, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_tp_2",
		highlight = { G.mul_TP_meter },
		attach = { major = G.mul_TP_meter, type = "cm", offset = { x = -3, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_tp_3",
		highlight = { G.mul_TP_meter },
		attach = { major = G.mul_TP_meter, type = "cm", offset = { x = -3, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_tp_4",
		highlight = { G.mul_TP_meter },
		attach = { major = G.mul_TP_meter, type = "cm", offset = { x = -3, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end

function Multiverse.skill_tutorial()
	G.SETTINGS.paused = true
	local step = 1
	local skills = Multiverse.filter(G.hand.cards, function(item)
		return item.ability.set == "mul_Skill"
	end)
	local boxes = Multiverse.map(skills, function(item)
		return item.children.mul_skill_cost_ui:get_UIE_by_ID("skill_cost")
	end)
	step = tutorial_info({
		text_key = "mul_skill_1",
		highlight = skills,
		attach = { major = G.hand, type = "cl", offset = { x = -1.5, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_skill_2",
		highlight = boxes,
		attach = { major = G.hand, type = "cl", offset = { x = -1.5, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_skill_3",
		highlight = skills,
		attach = { major = G.hand, type = "cl", offset = { x = -1.5, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_skill_4",
		highlight = skills,
		attach = { major = G.hand, type = "cl", offset = { x = -1.5, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end

function Multiverse.phil_stone_tutorial()
	G.SETTINGS.paused = true
	local step = 1
	local cards = Multiverse.filter(G.jokers.cards, function(item)
		return item.ability.mul_transmutable
	end)
	local a = #cards > 0 and { major = G.jokers, type = "cm", offset = { x = 0, y = 4 } }
		or { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } }
	step = tutorial_info({
		text_key = "mul_phil_stone_1",
		highlight = SMODS.find_card("c_mul_philosophers_stone"),
		attach = { major = G.consumeables, type = "cm", offset = { x = -3, y = 0 } },
		step = step,
		multiverse_tutorial = true,
		align = "cl",
	})
	step = tutorial_info({
		text_key = "mul_phil_stone_2",
		highlight = cards,
		attach = a,
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_phil_stone_3",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end

function Multiverse.transmute_tutorial(card)
	G.SETTINGS.paused = true
	local step = 1
	step = tutorial_info({
		text_key = "mul_transmute_1",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_transmute_2",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_transmute_3",
		highlight = { card },
		attach = { major = G.jokers, type = "cm", offset = { x = 0, y = 4.5 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_transmute_4",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		multiverse_tutorial = true,
	})
	step = tutorial_info({
		text_key = "mul_transmute_5",
		highlight = { G.HUD:get_UIE_by_ID("row_thaumaturgy") },
		attach = { major = G.HUD:get_UIE_by_ID("row_thaumaturgy"), type = "cm", offset = { x = 0, y = -4 } },
		step = step,
		align = "cr",
		multiverse_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end
