SMODS.ConsumableType({
	key = "mul_Myth",
	primary_colour = HEX("C5CC41"),
	secondary_colour = HEX("89C41B"),
	collection_rows = { 3, 4 },
	shop_rate = 2,
	default = "c_mul_homunculus",
})

function Multiverse.init_myth()
	---@type number
	G.GAME.mul_money_mult = G.GAME.mul_money_mult or 1
	---@type boolean
	G.GAME.mul_time_machine_active = G.GAME.mul_time_machine_active or false
	---@type boolean
	G.GAME.mul_stand_arrow_active = G.GAME.mul_stand_arrow_active or false
	---@type boolean
	G.GAME.mul_elder_scroll_active = G.GAME.mul_stand_arrow_active or false
	---@type integer
	G.GAME.mul_unicorn_protections = G.GAME.mul_unicorn_protections or 0
	---@type boolean
	G.GAME.mul_kryptonite_active = G.GAME.mul_kryptonite_active or false
	---@type string?
	G.GAME.mul_last_myth_used = G.GAME.mul_last_myth_used or nil
end

SMODS.Consumable({
	key = "philosophers_stone",
	set = "mul_Myth",
	atlas = "p_stone",
	pos = { x = 0, y = 0 },
	config = { extra = { energy_per_joker = 15 } },
	discovered = true,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_transmutable",
			vars = { G.GAME.mul_thaumaturgy_energy_per_joker or 10 },
		})
		local count = 0
		if G.jokers then
			for _, j in ipairs(G.jokers.cards) do
				if j:is_rarity("mul_transmuted") then
					count = count + 1
				end
			end
		end
		return { vars = { card.ability.extra.energy_per_joker, count * card.ability.extra.energy_per_joker } }
	end,
	in_pool = function(self, args)
		return false
	end,
	can_use = function(self, card)
		return #G.jokers.highlighted == 1 and G.jokers.highlighted[1].ability.mul_transmutable
	end,
	use = function(self, card, area, copier)
		local joker_to_transmute = G.jokers.highlighted[1]
		---@type Card
		Multiverse.transmuting_card = joker_to_transmute
		Multiverse.transmute_card_stage = 0
		local count = 0
		for _, j in ipairs(G.jokers.cards) do
			if j:is_rarity("mul_transmuted") then
				count = count + 1
			end
		end
		G.jokers:unhighlight_all()
		local transmute_key = joker_to_transmute.config.center.transmutes_into
		if count > 0 then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					play_sound("timpani")
					Multiverse.ease_thaumaturgy_energy(
						count * card.ability.extra.energy_per_joker,
						{ immediate = true }
					)
					return true
				end,
			}))
		end
		for i = 1, 3 do
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.7,
				func = function()
					ease_value(Multiverse, "transmute_card_stage", 1, nil, nil, true, 2.5)
					play_sound("mul_transmute" .. i, 0.9 + i / 10, 0.7)
					joker_to_transmute:juice_up(0.3, 0.5)
					if joker_to_transmute.children.particles then
						joker_to_transmute.children.particles:remove()
					end
					if card.children.particles then
						card.children.particles:remove()
					end
					joker_to_transmute.children.particles = Particles(0, 0, G.CARD_W, G.CARD_H, {
						timer_type = "TOTAL",
						timer = 0.025,
						scale = 0.25,
						speed = 1.5,
						lifespan = 0.9,
						attach = joker_to_transmute,
						colours = { Multiverse.C.PRIMARY1, Multiverse.C.PRIMARY2 },
						fill = true,
					})
					card.children.particles = Particles(0, 0, G.CARD_W, G.CARD_H, {
						timer_type = "TOTAL",
						timer = 0.025,
						scale = 0.25,
						speed = 1.5,
						lifespan = 0.9,
						attach = card,
						colours = { Multiverse.C.PRIMARY1, Multiverse.C.PRIMARY2 },
						fill = true,
					})
					card:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.9,
				func = function()
					if joker_to_transmute.children.particles then
						joker_to_transmute.children.particles.max = 0
					end
					if card.children.particles then
						card.children.particles.max = 0
					end
					return true
				end,
			}))
			delay(1)
		end
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.7,
			func = function()
				ease_value(Multiverse, "transmute_card_stage", 1, nil, nil, true, 7)
				play_sound("mul_transmute_final", 1.2, 0.8)
				if joker_to_transmute.children.particles then
					joker_to_transmute.children.particles:remove()
					joker_to_transmute.children.particles = nil
				end
				if card.children.particles then
					card.children.particles:remove()
					card.children.particles = nil
				end
				card:mul_safe_dissolve(nil, true, 1.6, true)
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 1.5,
			func = function()
				Multiverse.remove_all_stickers(joker_to_transmute)
				joker_to_transmute:set_ability(transmute_key)
				joker_to_transmute:set_cost()
				return true
			end,
		}))
		delay(4.5)
		G.E_MANAGER:add_event(Event({
			blocking = false,
			trigger = "after",
			delay = 2.5,
			func = function()
				Multiverse.transmuting_card = nil
				return true
			end,
		}))
	end,
})

SMODS.Consumable({
	key = "holy_grail",
	set = "mul_Myth",
	atlas = "holy_grail",
	pos = { x = 0, y = 0 },
	config = { extra = { num_consumables = 3 } },
	discovered = true,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.num_consumables } }
	end,
	can_use = function(self, card)
		return #G.jokers.highlighted == 1 and G.jokers.highlighted[1].config.center.mul_grail
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local pool = G.jokers.highlighted[1].config.center.mul_grail
			for i = 1, 3 do
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("timpani")
						SMODS.add_card({
							key = pseudorandom_element(pool, "mul_holy_grail"),
							edition = "e_negative",
							key_append = "mul_holy_grail",
						})
						return true
					end,
				}))
			end
		end)
	end,
})
SMODS.Consumable({
	key = "perpetual_motion",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	config = { extra = { max_thaum_energy = 20 } },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_thaum_energy } }
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			Multiverse.ease_thaumaturgy_energy(
				Multiverse.clamp(G.GAME.mul_thaumaturgy_energy, 0, card.ability.extra.max_thaum_energy),
				{ immediate = true }
			)
		end)
	end,
})
SMODS.Consumable({
	key = "tree_of_eden",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	can_use = function(self, card)
		return (
			G.jokers
			and #G.jokers.highlighted == 1
			and #G.jokers.cards < G.jokers.config.card_limit
			and G.jokers.highlighted[1].config.center.mul_tree_of_eden
		)
		-- in order for this card to be usable,
		-- the joker's key must be in Multiverse.transmutations
		-- and you must have space for a Joker
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local pool = G.jokers.highlighted[1].config.center.mul_tree_of_eden
			play_sound("timpani")
			SMODS.add_card({
				set = "Joker",
				key = pseudorandom_element(pool, "mul_tree_of_eden"),
			})
		end)
	end,
})

SMODS.Consumable({
	key = "sphere",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { energy_loss = 5 } },
	loc_vars = function(self, info_queue, card)
		local count = 0
		if G.hand then
			count = #G.hand.cards
		end
		return { vars = { card.ability.extra.energy_loss, count * card.ability.extra.energy_loss } }
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local count = #G.hand.cards
			SMODS.destroy_cards(G.hand.cards, nil, true)
			play_sound("timpani")
			Multiverse.ease_thaumaturgy_energy(-count * card.ability.extra.energy_loss, { immediate = true })
		end)
	end,
})

SMODS.Consumable({
	key = "necronomicon",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	can_use = function(self, card)
		return G.jokers and G.jokers.config.card_limit > #G.jokers.cards
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			SMODS.add_card({ rarity = "Rare", set = "Joker", key_append = "mul_necronomicon" })
			Multiverse.ease_thaumaturgy_energy(-G.GAME.mul_thaumaturgy_energy, { immediate = true })
		end)
	end,
})

SMODS.Consumable({
	key = "theory",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	can_use = function(self, card)
		return G.jokers and G.jokers.config.card_limit > #G.jokers.cards
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			SMODS.add_card({ set = "mul_can_transmute", key_append = "mul_theory" })
		end)
	end,
})

SMODS.Consumable({
	key = "chaos_emeralds",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = {
		extra = {
			progress_percent = 25,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.progress_percent,
			},
		}
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.highlighted == 1 and Multiverse.can_receive_transmutable(G.jokers.highlighted[1])
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local target = G.jokers.highlighted[1]
			play_sound("timpani")
			Multiverse.increment_transmute_progress(target, nil, card.ability.extra.progress_percent)
			target:juice_up(0.3, 0.5)
			Multiverse.transmute_check(target)
		end)
	end,
})

SMODS.Consumable({
	key = "rosetta_stone",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { energy_per_joker = 10 } },
	loc_vars = function(self, info_queue, card)
		local count = 0
		if G.jokers then
			count = #G.jokers.cards
		end
		return { vars = { card.ability.extra.energy_per_joker, count * card.ability.extra.energy_per_joker } }
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.cards >= 1
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			for _, j in ipairs(G.jokers.cards) do
				j:flip()
			end
			play_sound("timpani")
			Multiverse.ease_thaumaturgy_energy(
				card.ability.extra.energy_per_joker * #G.jokers.cards,
				{ immediate = true }
			)
		end)
	end,
})

SMODS.Consumable({
	key = "shadow_crystal",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_traitorous",
		})
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.highlighted == 1 and Multiverse.can_receive_transmutable(G.jokers.highlighted[1])
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local target = G.jokers.highlighted[1]
			local amt = target.config.center.transmute_req - target.ability.extra.transmute_progress - 1
			Multiverse.increment_transmute_progress(card, amt)
			play_sound("tarot1")
			target:add_sticker("mul_traitorous", true)
			target:juice_up(0.3, 0.5)
		end)
	end,
})

SMODS.Consumable({
	key = "one_ring",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = {},
	loc_vars = function(self, info_queue, card)
		local total = G.GAME.mul_thaumaturgy_energy or 0
		return {
			vars = {
				total / 2,
			},
		}
	end,
	can_use = function(self, card)
		return G.GAME.mul_thaumaturgy_energy > 1
	end,
	use = function(self, card, area, copier)
		local total = math.floor(G.GAME.mul_thaumaturgy_energy / 2)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			Multiverse.ease_thaumaturgy_energy(-total, { immediate = true })
		end)
		delay(0.6)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			Multiverse.ease_TP(total, { instant = true })
		end)
	end,
})

SMODS.Consumable({
	key = "gnosis",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { thaum_energy = 35 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.thaum_energy } }
	end,
	can_use = function(self, card)
		return G.jokers
			and #G.jokers.highlighted == 1
			and not SMODS.is_eternal(G.jokers.highlighted[1], card)
			and Multiverse.can_receive_transmutable(G.jokers.highlighted[1])
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			SMODS.destroy_cards(G.jokers.highlighted[1], nil, true)
			play_sound("timpani")
			Multiverse.ease_thaumaturgy_energy(card.ability.extra.thaum_energy, { immediate = true })
		end)
	end,
})

SMODS.Consumable({
	key = "puzzle",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, temp_recharge_boost = 12, money_penalty = 2 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		return { vars = { card.ability.extra.temp_recharge_boost, active } }
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			if card.ability.extra.is_active then
				G.GAME.mul_money_mult = G.GAME.mul_money_mult / card.ability.extra.money_penalty
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					+ card.ability.extra.temp_recharge_boost
			else
				G.GAME.mul_money_mult = G.GAME.mul_money_mult * card.ability.extra.money_penalty
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					- card.ability.extra.temp_recharge_boost
			end
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
})

SMODS.Consumable({
	key = "three_goddesses",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { min_energy = 40, progress_percent = 50 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.progress_percent, card.ability.extra.min_energy } }
	end,
	can_use = function(self, card)
		return G.jokers
			and #G.jokers.highlighted == 1
			and Multiverse.can_receive_transmutable(G.jokers.highlighted[1])
			and G.GAME.mul_thaumaturgy_energy >= card.ability.extra.min_energy
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			Multiverse.ease_thaumaturgy_energy(-G.GAME.mul_thaumaturgy_energy, { immediate = true })
			local target = G.jokers.highlighted[1]
			Multiverse.increment_transmute_progress(target, nil, card.ability.extra.progress_percent)
			target:juice_up(0.3, 0.5)
			Multiverse.transmute_check(target)
		end)
	end,
})

SMODS.Consumable({
	key = "ufo",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, temp_recharge_boost = 6, shop_penalty = 1 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		return { vars = { card.ability.extra.temp_recharge_boost, card.ability.extra.shop_penalty, active } }
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return card.ability.extra.is_active or (to_big(G.GAME.shop.joker_max) > to_big(1))
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			if card.ability.extra.is_active then
				change_shop_size(-card.ability.extra.shop_penalty)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					+ card.ability.extra.temp_recharge_boost
			else
				change_shop_size(card.ability.extra.shop_penalty)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					- card.ability.extra.temp_recharge_boost
			end
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
})

SMODS.Consumable({
	key = "stand_arrow",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, temp_recharge_boost = 12 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		local suit = G.GAME.current_round.mul_stand_arrow_suit or "Spades"
		return {
			vars = {
				card.ability.extra.temp_recharge_boost,
				localize(suit, "suits_singular"),
				active,
				colours = { G.C.SUITS[suit] },
			},
		}
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return card.ability.extra.is_active or not G.GAME.mul_stand_arrow_active
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			G.GAME.mul_stand_arrow_active = card.ability.extra.is_active
			if card.ability.extra.is_active then
				Multiverse.apply_to_playing_cards(function(playing_card)
					SMODS.recalc_debuff(playing_card)
				end)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					+ card.ability.extra.temp_recharge_boost
			else
				Multiverse.apply_to_playing_cards(function(playing_card)
					SMODS.recalc_debuff(playing_card)
				end)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					- card.ability.extra.temp_recharge_boost
			end
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
	update = function(self, card, dt)
		if card.ability.extra.is_active then
			Multiverse.apply_to_playing_cards(function(playing_card)
				SMODS.recalc_debuff(playing_card)
			end)
		end
	end,
})

function Multiverse.set_stand_arrow_suit()
	if not G.GAME.current_round.mul_stand_arrow_suit then
		G.GAME.current_round.mul_stand_arrow_suit =
			pseudorandom_element(SMODS.Suits, "mul_arrow" .. G.GAME.round_resets.ante).key
		return
	end
	local valid = Multiverse.filter(SMODS.Suits, function(item)
		return item.key ~= G.GAME.current_round.mul_stand_arrow_suit
	end)
	if next(valid) then
		G.GAME.current_round.mul_stand_arrow_suit = pseudorandom_element(valid, "mul_arrow" .. G.GAME.round_resets.ante)
	end
end

---@param card Card
function Multiverse.is_stand_arrow_debuffed(card)
	return card.playing_card
		and G.GAME.mul_stand_arrow_active
		and card:is_suit(G.GAME.current_round.mul_stand_arrow_suit, true)
end

SMODS.Consumable({
	key = "moon_berry",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { thaum_energy_cost = 35 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, G.P_CENTERS.e_polychrome)
		return { vars = { card.ability.extra.thaum_energy_cost } }
	end,
	can_use = function(self, card)
		return G.jokers
			and #G.jokers.highlighted == 1
			and not G.jokers.highlighted[1].edition
			and G.GAME.mul_thaumaturgy_energy >= card.ability.extra.thaum_energy_cost
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			G.jokers.highlighted[1]:set_edition("e_polychrome", true)
			Multiverse.ease_thaumaturgy_energy(-card.ability.extra.thaum_energy_cost, { immediate = true })
		end)
	end,
})

SMODS.Consumable({
	key = "elder_scroll",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, temp_recharge_boost = 16 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		return { vars = { card.ability.extra.temp_recharge_boost, active } }
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return card.ability.extra.is_active or not G.GAME.mul_elder_scroll_active
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			G.GAME.mul_elder_scroll_active = card.ability.extra.is_active
			if card.ability.extra.is_active then
				Multiverse.apply_to_hand(function(playing_card)
					if playing_card.facing == "front" then
						playing_card:flip()
					end
				end)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					+ card.ability.extra.temp_recharge_boost
			else
				Multiverse.apply_to_hand(function(playing_card)
					if playing_card.facing == "back" then
						playing_card:flip()
					end
				end)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					- card.ability.extra.temp_recharge_boost
			end
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
	calculate = function(self, card, context)
		if card.ability.extra.is_active and context.stay_flipped and context.to_area == G.hand then
			return { stay_flipped = true }
		end
	end,
})

SMODS.Consumable({
	key = "master_sword",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { energy_per_sticker = 15 } },
	loc_vars = function(self, info_queue, card)
		local total = 0
		if G.jokers and #G.jokers.highlighted == 1 then
			total = #Multiverse.get_stickers(G.jokers.highlighted[1]) * card.ability.extra.energy_per_sticker
		end
		return { vars = { card.ability.extra.energy_per_sticker, total } }
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.highlighted == 1 and #Multiverse.get_stickers(G.jokers.highlighted[1]) >= 1
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			local target = G.jokers.highlighted[1]
			play_sound("timpani")
			Multiverse.ease_thaumaturgy_energy(
				#Multiverse.get_stickers(target) * card.ability.extra.energy_per_sticker,
				{ immediate = true }
			)
			SMODS.destroy_cards(target, true, true)
		end)
	end,
})

SMODS.Consumable({
	key = "unicorn_horn",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		local nullifications = 0
		if G.GAME and G.GAME.mul_unicorn_protections then
			nullifications = G.GAME.mul_unicorn_protections
		end
		return { vars = { nullifications } }
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			G.GAME.mul_unicorn_protections = G.GAME.mul_unicorn_protections + 1
		end)
	end,
})

SMODS.Consumable({
	key = "kryptonite",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, temp_recharge_boost = 8 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		return { vars = { card.ability.extra.temp_recharge_boost, active } }
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return card.ability.extra.is_active or not G.GAME.mul_kryptonite_active
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			G.GAME.mul_kryptonite_active = card.ability.extra.is_active
			if card.ability.extra.is_active then
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					+ card.ability.extra.temp_recharge_boost
			else
				Multiverse.apply_to_jokers(function(joker)
					if joker:is_rarity(3) then
						SMODS.recalc_debuff(joker)
					end
				end)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					- card.ability.extra.temp_recharge_boost
			end
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
	update = function(self, card, dt)
		if card.ability.extra.is_active then
			Multiverse.apply_to_jokers(function(joker)
				if joker:is_rarity(3) then
					SMODS.recalc_debuff(joker)
				end
			end)
		end
	end,
})

---@param card Card
function Multiverse.is_kryptonite_debuffed(card)
	return card.area == G.jokers and G.GAME.mul_kryptonite_active and card:is_rarity(3)
end

SMODS.Consumable({
	key = "infinity_gauntlet",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { progress_percent = 50 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.progress_percent } }
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.highlighted == 1 and Multiverse.can_receive_transmutable(G.jokers.highlighted[1])
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			local target = G.jokers.highlighted[1]
			Multiverse.increment_transmute_progress(target, nil, card.ability.extra.progress_percent)
			local targets = {}
			for _, j in ipairs(G.jokers.cards) do
				if j ~= target then
					targets[#targets + 1] = j
				end
			end
			SMODS.destroy_cards(
				Multiverse.get_unique_pseudorandom_elements(targets, math.floor(#targets / 2), "mul_infinity_gauntlet"),
				nil,
				true
			)
		end)
	end,
})

SMODS.Consumable({
	key = "super_star",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, temp_recharge_penalty = 8, hands = 2, discards = 2 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		return {
			vars = {
				card.ability.extra.hands,
				card.ability.extra.discards,
				card.ability.extra.temp_recharge_penalty,
				active,
			},
		}
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return not card.ability.extra.is_active
			or (
				math.min(G.GAME.round_resets.hands, G.GAME.current_round.hands_left) > 3
				and math.min(G.GAME.round_resets.discards, G.GAME.current_round.discards_left) > 2
			)
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			if card.ability.extra.is_active then
				G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
				ease_hands_played(card.ability.extra.hands)
				G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
				ease_discard(card.ability.extra.discards)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					- card.ability.extra.temp_recharge_penalty
			else
				G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
				ease_hands_played(-card.ability.extra.hands)
				G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
				ease_discard(-card.ability.extra.discards)
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					+ card.ability.extra.temp_recharge_penalty
			end
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
})

SMODS.Consumable({
	key = "matrix",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, temp_recharge_penalty = 12, joker_slots = 1 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		return {
			vars = {
				card.ability.extra.joker_slots,
				card.ability.extra.temp_recharge_penalty,
				active,
			},
		}
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return not card.ability.extra.is_active or G.jokers.config.card_limit > 0
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			if card.ability.extra.is_active then
				G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					- card.ability.extra.temp_recharge_penalty
			else
				G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
				G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate
					+ card.ability.extra.temp_recharge_penalty
			end
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
})

SMODS.Consumable({
	key = "time_machine",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	eternal_compat = true,
	cost = 6,
	config = { extra = { is_active = false, progress_boost = 1 } },
	loc_vars = function(self, info_queue, card)
		table.insert(info_queue, {
			set = "Other",
			key = "mul_active_consumable",
		})
		local active = card.ability.extra.is_active and localize("k_mul_active") or localize("k_mul_inactive")
		return { vars = { card.ability.extra.progress_boost, active } }
	end,
	keep_on_use = function(self, card)
		return not card.ability.extra.is_active
	end,
	can_use = function(self, card)
		return card.ability.extra.is_active or not G.GAME.mul_time_machine_active
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("tarot1")
			card.ability.extra.is_active = not card.ability.extra.is_active
			G.GAME.mul_time_machine_active = card.ability.extra.is_active
			if card.ability.extra.is_active then
				card:add_sticker("eternal", true)
			else
				card:remove_sticker("eternal")
			end
		end)
	end,
	calculate = function(self, card, context)
		if
			card.ability.extra.is_active
			and context.end_of_round
			and not context.blueprint
			and not context.game_over
			and context.main_eval
		then
			for _, j in ipairs(G.jokers.cards) do
				if Multiverse.can_receive_transmutable(j) then
					Multiverse.increment_transmute_progress(j, card.ability.extra.progress_boost)
					j:juice_up(0.3, 0.5)
				end
			end
		end
	end,
})

SMODS.Consumable({
	key = "palace_treasure",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { conversion_rate = 1 } },
	loc_vars = function(self, info_queue, card)
		local total = math.floor((G.GAME.mul_thaumaturgy_energy or 0) / card.ability.extra.conversion_rate)
		return {
			vars = {
				card.ability.extra.conversion_rate,
				total,
			},
		}
	end,
	can_use = function(self, card)
		return G.GAME.mul_thaumaturgy_energy > 0
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			play_sound("timpani")
			total = math.floor(G.GAME.mul_thaumaturgy_energy / card.ability.extra.conversion_rate)
			Multiverse.ease_thaumaturgy_energy(-G.GAME.mul_thaumaturgy_energy, { immediate = true })
			ease_dollars(total, true)
		end)
	end,
})

SMODS.Consumable({
	key = "journal",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		local journal_card = G.GAME.mul_last_myth_used and G.P_CENTERS[G.GAME.mul_last_myth_used] or nil
		local last_myth = journal_card and localize({ type = "name_text", key = journal_card.key, set = "mul_Myth" })
			or localize("k_none")
		local colour = (not journal_card or journal_card.name == "Journal") and G.C.RED or G.C.GREEN
		if not (not journal_card or journal_card.name == "Journal") then
			info_queue[#info_queue + 1] = journal_card
		end
		local main_end = {
			{
				n = G.UIT.C,
				config = { align = "bm", padding = 0.02 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = " " .. last_myth .. " ",
									colour = G.C.UI.TEXT_LIGHT,
									scale = 0.3,
									shadow = true,
								},
							},
						},
					},
				},
			},
		}
		return { vars = { last_myth }, main_end = main_end }
	end,
	can_use = function(self, card)
		return (G.consumeables.config.card_limit > (#G.consumeables.cards - (card.area == G.consumeables and 1 or 0)))
			and G.GAME.mul_last_myth_used
			and G.GAME.mul_last_myth_used ~= "c_mul_journal"
	end,
	use = function(self, card, area, copier)
		Multiverse.effect_animation(card, function()
			if G.consumeables.config.card_limit > #G.consumeables.cards then
				play_sound("timpani")
				SMODS.add_card({ key = G.GAME.mul_last_myth_used })
			end
		end)
	end,
})

SMODS.Consumable({
	key = "homunculus",
	set = "mul_Myth",
	atlas = "temp_myth",
	pos = { x = 0, y = 0 },
	discovered = true,
	cost = 6,
	config = { extra = { cards_created = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards_created } }
	end,
	can_use = function(self, card)
		return G.consumeables.config.card_limit > (#G.consumeables.cards - (card.area == G.consumeables and 1 or 0))
	end,
	use = function(self, card, area, copier)
		local cards_created = G.consumeables.config.card_limit - #G.consumeables.cards
		play_sound("timpani")
		local count = 0
		while count < cards_created and G.consumeables.config.card_limit > #G.consumeables.cards do
			SMODS.add_card({ set = "mul_Myth" })
		end
	end,
})
