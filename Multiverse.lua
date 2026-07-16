Multiverse = {} -- LSP shit
Multiverse = SMODS.current_mod
Multiverse.C = {}
Multiverse.C.PRIMARY1 = HEX("89C41B")
Multiverse.C.PRIMARY2 = HEX("C5CC41")
Multiverse.C.SECONDARY = HEX("204D7F")
Multiverse.C.TRANSMUTED_GRADIENT = SMODS.Gradient({
	key = "transmuted",
	colours = {
		HEX("89C41B"),
		HEX("C5CC41"),
	},
	cycle = 1.5,
})
Multiverse.C.TRANSMUTED_GRADIENT_SLOW = SMODS.Gradient({
	key = "transmuted_slow",
	colours = {
		HEX("89C41B"),
		HEX("C5CC41"),
	},
	cycle = 5,
})

Multiverse.transmute_card_stage = 0

Multiverse.selected_music_page = 1

G.E_MANAGER.queues.mul_menu = {}

SMODS.current_mod.ui_config = {
	colour = Multiverse.C.SECONDARY,
	back_colour = Multiverse.C.PRIMARY1,
	bg_colour = { Multiverse.C.SECONDARY[1], Multiverse.C.SECONDARY[2], Multiverse.C.SECONDARY[3], 0.6 },
	tab_button_colour = Multiverse.C.PRIMARY1,
}

Multiverse.ENCHANTMENT_GROUPS = {}

Multiverse.context_flags = {}

function Multiverse.reset_context_flags()
	G.E_MANAGER:add_event(Event({
		func = function()
			Multiverse.context_flags = {}
			return true
		end,
	}))
end

---@param card Card
function Multiverse.handle_debuffs(card)
	local ret = {}
	if Multiverse.is_kryptonite_debuffed(card) then
		ret["debuff"] = true
	end
	if Multiverse.is_stand_arrow_debuffed(card) then
		ret["debuff"] = true
	end
	if G.GAME.mul_objection_active and card.playing_card then
		ret["prevent_debuff"] = true
	end
	if card.config.center.impervious then
		ret["prevent_debuff"] = true
	end
	return ret
end

---@type table[]
Multiverse.drawn_card_modify_queue = {}

SMODS.current_mod.calculate = function(self, context)
	local ret = {}
	if context.hand_drawn and context.mul_effect_draw then
		for i, card in ipairs(context.hand_drawn) do
			if Multiverse.drawn_card_modify_queue[i] then
				for key, modifier in pairs(Multiverse.drawn_card_modify_queue[i]) do
					if key ~= "func" then
						card.ability[key] = (card.ability[key] or 0) + modifier
					end
				end
				if Multiverse.drawn_card_modify_queue[i].func then
					Multiverse.drawn_card_modify_queue[i].func(card)
				end
				Multiverse.drawn_card_modify_queue[i] = nil
			end
		end
		remove_nils(Multiverse.drawn_card_modify_queue)
	end
	if context.mul_calc_priority then
		ret[#ret + 1] = {
			innate = context.other_card.config.center.innate,
			buried = context.other_card.config.center.buried,
		}
	end
	if context.fix_probability and G.GAME.mul_chaos_form then
		ret[#ret + 1] = {
			numerator = 1,
			denominator = 2,
		}
	end
	if context.setting_blind then
		if next(SMODS.find_card("c_mul_eggman")) and not G.GAME.mul_eggman_secret then
			Multiverse.eggman_secret()
		end
	end
	if context.mul_using_skill then
		G.GAME.mul_skill_usage.run = G.GAME.mul_skill_usage.run + 1
		G.GAME.mul_skill_usage.round = G.GAME.mul_skill_usage.round + 1
	end
	if context.end_of_round and not context.game_over and context.main_eval then
		G.GAME.mul_objection_active = false
		G.GAME.mul_chaos_form = false
		G.GAME.mul_temp_skill_discount = 0
		G.GAME.mul_skill_usage.round = 0
		local cards_to_destroy = Multiverse.filter(G.playing_cards, function(item)
			return SMODS.has_enhancement(item, "m_mul_left_hand") or SMODS.has_enhancement(item, "m_mul_right_hand")
		end)
		if #cards_to_destroy > 0 then
			SMODS.destroy_cards(cards_to_destroy)
		end
		if context.beat_boss then
			G.GAME.mul_num_bosses_defeated = (G.GAME.mul_num_bosses_defeated or 0) + 1
		end
		Multiverse.apply_to_playing_cards(function(playing_card)
			if playing_card.ability.mul_temp_priority then
				playing_card.ability.mul_temp_priority = nil
			end
		end)
		Multiverse.context_flags.from_charge = true
		Wallet.mod_buffer("mul_thaumaturgy_energy", G.GAME.mul_thaumaturgy_energy_rate)
		ret[#ret + 1] = {
			mul_thaumaturgy_energy = G.GAME.mul_thaumaturgy_energy_rate,
			func = function()
				Wallet.reset_buffer("mul_thaumaturgy_energy")
				Multiverse.reset_context_flags()
			end,
		}
	end
	if context.mul_philosophers_stone_check and not context.game_over and context.main_eval then
		if G.GAME.mul_thaumaturgy_energy + (G.GAME.mul_thaumaturgy_energy_buffer or 0) >= 100 then
			if #G.consumeables.cards < G.consumeables.config.card_limit then
				local amt = G.GAME.mul_thaumaturgy_energy + G.GAME.mul_thaumaturgy_energy_buffer
				Multiverse.context_flags.from_philosophers_stone = true
				Wallet.mod_buffer("mul_thaumaturgy_energy", -amt)
				ret[#ret + 1] = {
					mul_thaumaturgy_energy = -amt,
					func = function()
						SMODS.add_card({
							key = "c_mul_philosophers_stone",
							key_append = "mul_thaumaturgy_charge",
						})
						Wallet.reset_buffer("mul_thaumaturgy_energy")
						Multiverse.reset_context_flags()
					end,
				}
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						delay(2.2 * G.SETTINGS.GAMESPEED)
						attention_text({
							scale = 1.4,
							text = localize("k_no_room_ex"),
							hold = 2 * G.SETTINGS.GAMESPEED,
							align = "cm",
							offset = { x = 0, y = -1.7 },
							major = G.play,
						})
						attention_text({
							scale = 0.7,
							text = localize("k_mul_make_room"),
							hold = 2 * G.SETTINGS.GAMESPEED,
							align = "cm",
							offset = { x = 0, y = -0.5 },
							major = G.play,
						})
						attention_text({
							scale = 0.7,
							text = localize("k_mul_make_room2"),
							hold = 2 * G.SETTINGS.GAMESPEED,
							align = "cm",
							offset = { x = 0, y = 0.3 },
							major = G.play,
						})
						return true
					end,
				}))
			end
		end
	end
	if context.starting_shop then
		Multiverse.hide_blind_instructions()
	end
	if context.debuff_card then
		ret[#ret + 1] = Multiverse.handle_debuffs(context.debuff_card)
	end
	if context.press_play then
		Multiverse.handle_half_cards()
		Multiverse.handle_ethereal()
	end
	if context.mul_change_skill_cost then
		if
			context.other_card.config.center.impulse
			and G.GAME.current_round.hands_played == 0
			and G.GAME.current_round.discards_used == 0
		then
			ret[#ret + 1] = {
				skill_tp_cost_mult = 0.5,
			}
		end
		ret[#ret + 1] = {
			skill_tp_discount = (G.GAME.mul_temp_skill_discount or 0) + (G.GAME.mul_skill_discount or 0),
		}
	end
	if context.using_consumeable then
		if context.consumeable.ability.set == "mul_Myth" then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.mul_last_myth_used = context.consumeable.config.center_key
					return true
				end,
			}))
		end
	end
	if context.after then
		if G.GAME.mul_waterbending then
			SMODS.change_play_limit(-G.GAME.mul_waterbending)
			G.GAME.mul_waterbending = nil
		end
		if SMODS.last_hand_oneshot then
			if next(SMODS.find_card("j_mul_ren_amamiya")) then
				-- Hold off on this until some dedicated artist gets this animation done
				-- Multiverse.play_animation("ren_cut_in")
			end
		else
			local tp_amt = pseudorandom("mul_tp_gen", G.GAME.mul_tp_min_gain, G.GAME.mul_tp_max_gain)
			Multiverse.context_flags.from_scored_hand = true
			Wallet.mod_buffer("mul_tp", tp_amt)
			ret[#ret + 1] = {
				mul_tp = tp_amt,
				func = function()
					Wallet.reset_buffer("mul_tp")
					Multiverse.reset_context_flags()
				end,
			}
		end
	end
	if
		context.check_eternal
		and context.trigger
		and (context.trigger.mul_fusion or context.trigger.mul_split)
		and context.other_card.ability.set == "mul_Skill"
	then
		ret[#ret + 1] = { no_destroy = { override_compat = true } }
	end
	Multiverse.calculate_deck_enchantments(context, ret)
	Multiverse.handle_tutorials(context)
	if #ret == 0 then
		return nil
	elseif #ret == 1 then
		return ret[1]
	else
		return SMODS.merge_effects(ret)
	end
end

SMODS.draw_ignore_keys["transmutable_target"] = true
SMODS.draw_ignore_keys["mul_joker_use_button"] = true
SMODS.draw_ignore_keys["mul_hitbox_indicator"] = true
SMODS.draw_ignore_keys["mul_skill_use_button"] = true
SMODS.draw_ignore_keys["mul_skill_cost_ui"] = true

function SMODS.current_mod.reset_game_globals(run_start)
	Multiverse.set_foddian_suit()
	Multiverse.set_stand_arrow_suit()
	Multiverse.set_card_counting_rank()
end

---@param path string
function Multiverse.recursive_load(path)
	local files = SMODS.NFS.getDirectoryItems(Multiverse.path .. path)
	for _, item in ipairs(files) do
		if string.sub(item, -4) == ".lua" then
			print("Multiverse: Loading " .. item:gsub("%d+_", ""))
			assert(SMODS.load_file(path .. "/" .. item), string.format("File %s failed to load", path))()
		elseif path:find("%.") == nil then
			Multiverse.recursive_load(path .. "/" .. item)
		end
	end
end

Multiverse.recursive_load("misc")
Multiverse.recursive_load("mod")

SMODS.current_mod.optional_features = function()
	return {
		quantum_enhancements = true,
	}
end

SMODS.current_mod.custom_card_areas = function(game)
	game.mul_exhaust = CardArea(
		game.discard.T.x,
		game.discard.T.y,
		game.discard.T.w,
		game.discard.T.h,
		{ type = "discard", card_limit = 1e308, max_highlighted = 0 }
	)
end

local debug, err = SMODS.load_file("debug.lua")
if debug then
	mulDbg = {}
	if Multiverse.config.debug then
		debug()
	end
end

Multiverse.debug_info = { ["Debug Mode"] = (Multiverse.config.debug and "Enabled" or "Disabled") }
