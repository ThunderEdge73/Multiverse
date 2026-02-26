---Effectively a cleaner take_ownership that makes taking ownership of modded Jokers and making them transmutable more convenient
---Note that I adhere to the standards implied by this function due to consumable behavior.
---Also note that calc must manually handle checking if the Joker is transmutable via Multiverse.transmute_check()
---@param key string Note that the Joker with this key must satisfy `type(modded_joker.ability.extra) == "table"`
---@param config {requirement: number, tracker_var: number | table, transmutes_into: string, grail_pool: string[], eden_pool: string[]} Other data needed for a transmutable Joker.
---@param calc fun(self, card, context): nil A calculation function used to increment transmute_progress. This should not return anything.
function Multiverse.transmutable_override(key, config, calc)
	local no_joker_prefix_key = key:sub(3)
	local calculate_hook = SMODS.Jokers[key].calculate
	local loc_vars_hook = SMODS.Jokers[key].loc_vars
	local temp_config = SMODS.Jokers[key].config
	temp_config.extra = temp_config.extra or {}
	temp_config.extra.transmute_progress = config.tracker_var
	local temp_pools = SMODS.Jokers[key].pools
	temp_pools["mul_can_transmute"] = true
	SMODS.Joker:take_ownership(no_joker_prefix_key, {
		transmute_req = Multiverse.set_transmute_requirements(config.requirement),
		config = temp_config,
		loc_vars = function(self, info_queue, card)
			local ret = nil
			if loc_vars_hook then
				ret = loc_vars_hook(self, info_queue, card)
			end
			Multiverse.transmute_info_queue(card, info_queue)
			return ret
		end,
		calculate = function(self, card, context)
			if not context.blueprint then
				calc(self, card, context)
			end
			if calculate_hook then
				calculate_hook(self, card, context)
			end
		end,
		pools = temp_pools,
		transmutes_into = config.transmutes_into,
		mul_grail = config.grail_pool,
		mul_tree_of_eden = config.eden_pool,
	}, true)
end

--#region Manual vanilla overrides, which are annoying because of non-standardized config tables
--Code is taken from vremade to streamline the process of preserving the original functionality of the overrided joker
SMODS.Joker:take_ownership("joker", {
	transmute_req = Multiverse.set_transmute_requirements(15),
	config = {
		extra = { mult = 4, transmute_progress = { n = 0 } },
	},
	loc_vars = function(self, info_queue, card)
		Multiverse.transmute_info_queue(card, info_queue)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end
		if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Tarot" then
			if not card.ability.extra.transmute_progress[context.consumeable.config.center_key] then
				card.ability.extra.transmute_progress[context.consumeable.config.center_key] = true
				Multiverse.increment_transmute_progress(card, 1)
			end
		end
	end,
	transmutes_into = "j_mul_ren_amamiya",
	mul_grail = { "c_emperor" },
	mul_tree_of_eden = { "j_cartomancer", "j_hallucination", "j_vagabond" },
}, true)

SMODS.Joker:take_ownership("pareidolia", {
	loc_vars = function(self, info_queue, card)
		Multiverse.transmute_info_queue(card, info_queue)
	end,
	transmute_req = Multiverse.set_transmute_requirements(6),
	config = { extra = { transmute_progress = { n = 0 } } },
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if not card.ability.extra.transmute_progress[context.scoring_name] then
				card.ability.extra.transmute_progress[context.scoring_name] = true
				Multiverse.increment_transmute_progress(card, 1)
			end
		end
	end,
	transmutes_into = "j_mul_impostor",
	mul_grail = { "c_lovers", "c_strength", "c_death", "c_hanged_man" },
	mul_tree_of_eden = { "j_mul_jack_frost", "j_smeared", "j_shortcut" },
}, true)

SMODS.Joker:take_ownership("invisible", {
	transmute_req = Multiverse.set_transmute_requirements(20),
	config = {
		extra = {
			invis_rounds = 0,
			total_rounds = 2,
			transmute_progress = { n = 0 },
		},
	},
	loc_vars = function(self, info_queue, card)
		local main_end = {}
		if G.jokers and G.jokers.cards then
			for _, joker in ipairs(G.jokers.cards) do
				if joker.edition and joker.edition.negative then
					localize({ type = "other", key = "remove_negative", nodes = main_end, vars = {} })
					break
				end
			end
		end
		Multiverse.transmute_info_queue(card, info_queue)
		return {
			vars = {
				card.ability.extra.total_rounds,
				card.ability.extra.invis_rounds,
			},
			main_end = main_end[1],
		}
	end,
	calculate = function(self, card, context)
		if context.selling_self and not context.blueprint then
			if not card.ability.extra.invis_rounds >= card.ability.extra.total_rounds then
				local jokers = {}
				for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] ~= card then
						jokers[#jokers + 1] = G.jokers.cards[i]
					end
				end
				if #jokers > 0 then
					if #G.jokers.cards <= G.jokers.config.card_limit then
						local chosen_joker = pseudorandom_element(jokers, "vremade_invisible")
						local copied_joker = copy_card(
							chosen_joker,
							nil,
							nil,
							nil,
							chosen_joker.edition and chosen_joker.edition.negative
						)
						if copied_joker.ability.invis_rounds then
							copied_joker.ability.invis_rounds = 0
						end
						if type(copied_joker.ability.extra) == "table" and copied_joker.ability.extra.invis_rounds then
							copied_joker.ability.extra.invis_rounds = 0
						end
						copied_joker:add_to_deck()
						G.jokers:emplace(copied_joker)
						return { message = localize("k_duplicated_ex") }
					else
						return { message = localize("k_no_room_ex") }
					end
				else
					return { message = localize("k_no_other_jokers") }
				end
			else
				return nil, true
			end
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra.invis_rounds = card.ability.extra.invis_rounds + 1
			if card.ability.extra.invis_rounds == card.ability.extra.total_rounds then
				local eval = function(c)
					return not c.REMOVED
				end
				juice_card_until(card, eval, true)
			end
			return {
				message = (card.ability.extra.invis_rounds < card.ability.extra.total_rounds)
						and (card.ability.extra.invis_rounds .. "/" .. card.ability.extra.total_rounds)
					or localize("k_active_ex"),
				colour = G.C.FILTER,
			}
		end
		if not context.blueprint and context.card_added and context.card.ability.set == "Joker" then
			if not card.ability.extra.transmute_progress[context.card.config.center_key] then
				card.ability.extra.transmute_progress[context.card.config.center_key] = true
				Multiverse.increment_transmute_progress(card, 1)
			end
		end
	end,
	transmutes_into = "j_mul_waldo",
	mul_grail = { "c_judgement", "c_wraith" },
	mul_tree_of_eden = { "j_riff_raff", "j_chaos", "j_diet_cola" },
}, true)

-- Not really transmutation-related, more so for the funny factor
SMODS.Joker:take_ownership("chicot", {
	add_to_deck = function(self, card, from_debuff)
		Multiverse.play_video("chicot_summoning")
		Multiverse.start_animation("black_bg")
		Multiverse.very_important_thing = true
		G.E_MANAGER:add_event(Event({
			blockable = false,
			trigger = "after",
			delay = 12.7 * G.SETTINGS.GAMESPEED,
			func = function()
				Multiverse.very_important_thing = false
				Multiverse.stop_video("chicot_summoning")
				Multiverse.end_animation("black_bg")
				return true
			end,
		}))
		if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
			G.GAME.blind:disable()
			play_sound("timpani")
			SMODS.calculate_effect({ message = localize("ph_boss_disabled") }, card)
		end
	end,
}, true)
--#endregion
