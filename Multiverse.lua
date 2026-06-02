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

---Talisman compatibility?
to_big = to_big or function(x)
	return x
end
to_number = to_number or function(x)
	return x
end

SMODS.ObjectType({
	key = "mul_can_transmute",
	default = "j_joker",
	cards = {
		["j_joker"] = true,
		["j_pareidolia"] = true,
		["j_invisible"] = true,
	},
})

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
	if card.config.center.mul_impervious then
		ret["prevent_debuff"] = true
	end
	return ret
end

SMODS.current_mod.calculate = function(self, context)
	local ret = {}
	if context.setting_blind then
		if next(SMODS.find_card("c_mul_eggman")) and not G.GAME.mul_eggman_secret then
			Multiverse.eggman_secret()
		end
	end
	if context.end_of_round and not context.game_over and context.main_eval then
		G.GAME.mul_objection_active = false
		local cards_to_destroy = Multiverse.filter(G.playing_cards, function(item)
			return SMODS.has_enhancement(item, "m_mul_left_hand") or SMODS.has_enhancement(item, "m_mul_right_hand")
		end)
		if #cards_to_destroy > 0 then
			SMODS.destroy_cards(cards_to_destroy)
		end
		Multiverse.ease_thaumaturgy_energy(G.GAME.mul_thaumaturgy_energy_rate, { from_charge = true })
		if context.beat_boss then
			G.GAME.num_bosses_defeated = (G.GAME.num_bosses_defeated or 0) + 1
		end
	end
	if context.mul_philosophers_stone_check and not context.game_over and context.main_eval then
		G.E_MANAGER:add_event(Event({
			func = function()
				Multiverse.check_philosophers_stone()
				return true
			end,
		}))
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
			context.other_card.config.center.mul_impulse
			and G.GAME.current_round.hands_played == 0
			and G.GAME.current_round.discards_used == 0
		then
			ret[#ret + 1] = {
				skill_tp_cost_mult = 0.5,
			}
		end
	end
	if context.using_consumeable and context.consumeable.ability.set == "mul_Myth" then
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.mul_last_myth_used = context.consumeable.config.center_key
				return true
			end,
		}))
	end
	if context.after then
		if SMODS.last_hand_oneshot then
			if next(SMODS.find_card("j_mul_ren_amamiya")) then
				-- Hold off on this until some dedicated artist gets this animation done
				-- Multiverse.play_animation("ren_cut_in")
			end
		else
			print("what")
			G.E_MANAGER:add_event(Event({
				func = function()
					Multiverse.ease_TP(
					pseudorandom("mul_TP_gen", G.GAME.mul_TP_min_gain, G.GAME.mul_TP_max_gain),
						{ from_hand = true }
					)
					return true
				end,
			}))
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
		return SMODS.merge_effects(unpack(ret))
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
		{ type = "discard", card_limit = 1e308, max_highlighted = 1e308 }
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
