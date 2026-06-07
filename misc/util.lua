---Checks if `value` is mapped to a key within `table`.
---@param table table
---@param value any
---@return boolean
function Multiverse.contains_value(table, value)
	for _, v in pairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

---Counts the number of key-value pairings in a table `t`.
---@param table table
---@return integer
function Multiverse.len(table)
	local count = 0
	for _, _ in pairs(table) do
		count = count + 1
	end
	return count
end

---Constrains a number to be within a given range.
---@param n number
---@param min? number
---@param max? number
---@return number
function Multiverse.clamp(n, min, max)
	local lower = min or 0
	local higher = max or 1
	if lower > higher then
		error("min cannot be higher than max")
	end
	if n < lower then
		return lower
	elseif n > higher then
		return higher
	else
		return n
	end
end

---Returns all cards in `t` such that `func(t)` is truthy in an indexed array.
---@param t table
---@param func fun(item): boolean
---@return table
function Multiverse.filter(t, func)
	local ret = {}
	for _, v in pairs(t) do
		if func(v) then
			table.insert(ret, v)
		end
	end
	return ret
end

---@param t table
---@param func fun(item): any
---@return table
function Multiverse.map(t, func)
	local ret = {}
	for k, v in pairs(t) do
		ret[k] = func(v)
	end
	return ret
end

---Gets `n` random values of `t` that each correspond to a distinct index of `t` while respecting seeds.
---@generic T
---@param t T[]
---@param n integer
---@param seed string
---@return T[]
function Multiverse.get_unique_pseudorandom_elements(t, n, seed)
	local eligible = {}
	for i = 1, #t do
		eligible[#eligible + 1] = i
	end
	local ret = {}
	for i = 1, math.min(n, #t) do
		local target_index, eligible_index = pseudorandom_element(eligible, seed)
		ret[#ret + 1] = t[target_index]
		table.remove(eligible, eligible_index)
	end
	return ret
end

---Basically just Card:start_dissolve but doesnt destroy the card
function Card:mul_safe_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice, args)
	local dissolve_time = 0.7 * (dissolve_time_fac or 1)
	local temp = args or {}
	local no_particles = temp.no_particles
	self.dissolve = 0
	self.dissolve_colours = dissolve_colours or { G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY }
	if not no_juice then
		self:juice_up()
	end
	local childParts = not no_particles
		and Particles(0, 0, 0, 0, {
			timer_type = "TOTAL",
			timer = 0.01 * dissolve_time,
			scale = 0.1,
			speed = 2,
			lifespan = 0.7 * dissolve_time,
			attach = self,
			colours = self.dissolve_colours,
			fill = true,
		})
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		blockable = false,
		delay = 0.7 * dissolve_time,
		func = function()
			if childParts then
				childParts:fade(0.3 * dissolve_time)
			end
			return true
		end,
	}))
	if not silent then
		G.E_MANAGER:add_event(Event({
			blockable = false,
			func = function()
				play_sound("whoosh2", math.random() * 0.2 + 0.9, 0.5)
				play_sound("crumple" .. math.random(1, 5), math.random() * 0.2 + 0.9, 0.5)
				return true
			end,
		}))
	end
	G.E_MANAGER:add_event(Event({
		trigger = "ease",
		blockable = false,
		ref_table = self,
		ref_value = "dissolve",
		ease_to = 1,
		delay = 1 * dissolve_time,
		func = function(t)
			return t
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		blockable = false,
		delay = 1.051 * dissolve_time,
	}))
end

function Card:mul_no_juice_materialize(dissolve_colours, silent, timefac, args)
	local dissolve_time = 0.6 * (timefac or 1)
	local temp = args or {}
	local no_particles = temp.no_particles
	local blocking = temp.blocking
	self.states.visible = true
	self.states.hover.can = false
	self.dissolve = 1
	self.dissolve_colours = dissolve_colours
		or (self.ability.set == "Joker" and { G.C.RARITY[self.config.center.rarity] })
		or (self.ability.set == "Planet" and { G.C.SECONDARY_SET.Planet })
		or (self.ability.set == "Tarot" and { G.C.SECONDARY_SET.Tarot })
		or (self.ability.set == "Spectral" and { G.C.SECONDARY_SET.Spectral })
		or (self.ability.set == "Booster" and { G.C.BOOSTER })
		or (self.ability.set == "Voucher" and { G.C.SECONDARY_SET.Voucher, G.C.CLEAR })
		or (self.ability.set == "mul_Myth" and { G.C.SECONDARY_SET.mul_Myth })
		or (self.ability.set == "mul_EnchantedBook" and { G.C.SECONDARY_SET.mul_EnchantedBook })
		or (self.ability.set == "mul_Skill" and { G.C.FILTER, G.C.RED, G.C.BLUE })
		or { G.C.GREEN }
	if not no_particles then
		self.children.particles = Particles(0, 0, 0, 0, {
			timer_type = "TOTAL",
			timer = 0.025 * dissolve_time,
			scale = 0.25,
			speed = 3,
			lifespan = 0.7 * dissolve_time,
			attach = self,
			colours = self.dissolve_colours,
			fill = true,
		})
	end
	if not silent then
		if
			not G.last_materialized
			or G.last_materialized + 0.01 < G.TIMERS.REAL
			or G.last_materialized > G.TIMERS.REAL
		then
			G.last_materialized = G.TIMERS.REAL
			G.E_MANAGER:add_event(Event({
				blockable = false,
				func = function()
					play_sound("whoosh1", math.random() * 0.1 + 0.6, 0.3)
					play_sound("crumple" .. math.random(1, 5), math.random() * 0.2 + 1.2, 0.8)
					return true
				end,
			}))
		end
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		blockable = false,
		blocking = blocking,
		delay = 0.5 * dissolve_time,
		func = function()
			if self.children.particles then
				self.children.particles.max = 0
			end
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "ease",
		blockable = false,
		blocking = blocking,
		ref_table = self,
		ref_value = "dissolve",
		ease_to = 0,
		delay = 1 * dissolve_time,
		func = function(t)
			return t
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		blockable = false,
		blocking = blocking,
		delay = 1.05 * dissolve_time,
		func = function()
			self.states.hover.can = true
			if self.children.particles then
				self.children.particles:remove()
				self.children.particles = nil
			end
			return true
		end,
	}))
end

---Animation for consumable-like effects
---@param card Card The card that is applying its effect
---@param func fun(): nil The effect to apply
function Multiverse.effect_animation(card, func)
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.4,
		func = function()
			func()
			card:juice_up(0.3, 0.5)
			return true
		end,
	}))
	delay(0.6)
end

---@param trigger_card Card
---@param cards Card[]
---@param func fun(_card: Card): nil
---@param filter_func? fun(_card: Card): boolean?
---@param post? fun()
function Multiverse.apply_to_cards_animation(trigger_card, cards, func, filter_func, post)
	local all_cards = cards
	if filter_func then
		all_cards = Multiverse.filter(all_cards, filter_func)
	end
	if #all_cards == 0 then
		return
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.4,
		func = function()
			play_sound("tarot1")
			trigger_card:juice_up(0.3, 0.5)
			return true
		end,
	}))
	for i = 1, #all_cards do
		local percent = 1.15 - (i - 0.999) / (#all_cards - 0.998) * 0.3
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				all_cards[i]:flip()
				play_sound("card1", percent)
				all_cards[i]:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end
	delay(0.2)
	for i = 1, #all_cards do
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				func(all_cards[i])
				return true
			end,
		}))
	end
	for i = 1, #all_cards do
		local percent = 0.85 + (i - 0.999) / (#all_cards - 0.998) * 0.3
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				all_cards[i]:flip()
				play_sound("tarot2", percent, 0.6)
				all_cards[i]:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			if post then
				post()
			end
			return true
		end,
	}))
	delay(0.5)
end

---Checks to see if an active consumable should have particles.
---@param card Card
---@param state boolean
function Multiverse.check_active_particles(card, state)
	if state then
		card.children.active_particles = card.children.active_particles
			or Particles(0, 0, G.CARD_W, G.CARD_H, {
				timer_type = "TOTAL",
				timer = 0.025,
				scale = 0.2,
				speed = 1.5,
				lifespan = 0.7,
				attach = card,
				colours = { G.C.SET[card.ability.set], G.C.SECONDARY_SET[card.ability.set] },
				fill = true,
			})
	elseif card.children.active_particles then
		card.children.active_particles:remove()
		card.children.active_particles = nil
	end
end

---@param card Card
function Multiverse.get_stickers(card)
	local stickers = {}
	for key, _ in pairs(SMODS.Stickers) do
		if card.ability[key] then
			stickers[#stickers + 1] = key
		end
	end
	return stickers
end

---@param card Card
function Multiverse.remove_all_stickers(card)
	local keys = Multiverse.get_stickers(card)
	for _, key in ipairs(keys) do
		card:remove_sticker(key)
	end
end

---Gets the most played hand, as well as the number of times it has been played
---@return string
---@return integer
function Multiverse.get_most_played_hand()
	local _hand, _tally = nil, 0
	for _, handname in ipairs(G.handlist) do
		if SMODS.is_poker_hand_visible(handname) and G.GAME.hands[handname].played > _tally then
			_hand = handname
			_tally = G.GAME.hands[handname].played
		end
	end
	return (_hand or "High Card"), _tally
end

---@param func fun(joker: Card): nil
function Multiverse.apply_to_jokers(func)
	if G.jokers then
		for _, j in ipairs(G.jokers.cards) do
			func(j)
		end
	end
end

---@param func fun(playing_card: Card): nil
function Multiverse.apply_to_playing_cards(func)
	if G.playing_cards then
		for _, p in ipairs(G.playing_cards) do
			func(p)
		end
	end
end

---@param func fun(playing_card: Card): nil
function Multiverse.apply_to_hand(func)
	if G.hand then
		for _, p in ipairs(G.hand.cards) do
			func(p)
		end
	end
end

---Internal code taken from vanilla remade wiki
function Multiverse.create_random_tag()
	local tag_pool = SMODS.get_clean_pool("Tag")
	local selected_tag = pseudorandom_element(tag_pool, "mul_seed")
	add_tag(Tag(selected_tag, false, "Small"))
end

function Multiverse.weighted_pseudorandom(seed, weight_towards, bias, min, max)
	local val = Multiverse.clamp(pseudorandom(seed) * (1 - bias) + weight_towards * bias, 0, 1)
	if min and max then
		return math.floor(val * (max - min + 1) + min)
	else
		return val
	end
end

---@generic T
---@param t `T`[]
---@param get_weight fun(item: T): number
---@param key_append string
---@return T, integer
function Multiverse.weighted_poll(t, get_weight, key_append)
	local total_weight = 0
	for _, item in ipairs(t) do
		total_weight = total_weight + get_weight(item)
	end
	local rand_val = pseudorandom(key_append, 0, total_weight - 1)
	local curr_weight = 0
	for index, item in ipairs(t) do
		local next_weight = curr_weight + get_weight(item)
		if rand_val >= curr_weight and rand_val < next_weight then
			return item, index
		end
		curr_weight = next_weight
	end
	return nil, -1
end

---@param card Card
---@param half string
function Multiverse.convert_to_half_card(card, half)
	if not (card.playing_card and (half == "left" or half == "right")) then
		return
	end
	if not Multiverse.is_valid_half(card) then
		card.ability.extra_slots_used = card.ability.extra_slots_used - 0.5
	end
	card.ability.mul_half_card = half
	card:set_sprites()
end

function Multiverse.restore_from_half_card(card)
	if not (card.playing_card and Multiverse.is_valid_half(card)) then
		return
	end
	card.ability.extra_slots_used = card.ability.extra_slots_used + 0.5
	card.ability.mul_half_card = nil
	card:set_sprites()
end

function Multiverse.is_valid_half(card)
	if not card then
		return false
	end
	local value = (card.ability or {}).mul_half_card
	return value == "left" or value == "right"
end

---@return boolean
function Multiverse.can_halve_selected()
	if not (G.hand and G.hand.highlighted and #G.hand.highlighted > 0) then
		return false
	end
	for _, c in ipairs(G.hand.highlighted) do
		if Multiverse.can_halve_card(c) then
			return false
		end
	end
	return true
end

function Multiverse.can_halve_card(card)
	return not (SMODS.is_eternal(card, { mul_split = true }) or Multiverse.is_valid_half(card))
end

---Handles splitting card
---@param cards_to_split Card | Card[]
---@param num? integer
---@param is_random? boolean
---@param forced_half? string
---@param silent? boolean
function Multiverse.halve_cards(cards_to_split, num, is_random, forced_half, silent)
	local cards
	if not cards_to_split[1] then -- If cards_to_split is a single card
		cards = { cards_to_split }
	else
		cards = cards_to_split
	end
	for _, c in ipairs(cards) do
		if not Multiverse.can_halve_card(c) then
			return
		end
	end
	local amt = num or 2
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			local _first_dissolve = nil
			local new_cards = {}
			for _, target in ipairs(cards) do
				for i = 1, amt do
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local _card = copy_card(target, nil, nil, G.playing_card)
					_card:add_to_deck()
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, _card)
					G.hand:emplace(_card)
					_card:start_materialize(nil, _first_dissolve)
					_first_dissolve = true
					new_cards[#new_cards + 1] = _card
					if forced_half == "left" or forced_half == "right" then
						Multiverse.convert_to_half_card(_card, forced_half)
					elseif is_random then
						local rand_choice = pseudorandom("mul_random_half", 1, 2)
						if rand_choice == 1 then
							Multiverse.convert_to_half_card(_card, "left")
						else
							Multiverse.convert_to_half_card(_card, "right")
						end
					else
						if i % 2 == 1 then
							Multiverse.convert_to_half_card(_card, "left")
						else
							Multiverse.convert_to_half_card(_card, "right")
						end
					end
				end
			end
			SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
			SMODS.destroy_cards(cards, nil, true)
			if not silent then
				play_sound("slice1", 0.96 + math.random() * 0.08)
			end
			return true
		end,
	}))
end

G.FUNCS.mul_draw_from_exhausted_to_deck = function(e)
	for _, c in ipairs(G.mul_exhaust.cards) do
		c.dissolve = nil
	end
	G.E_MANAGER:add_event(Event({
		func = function()
			local exhaust_count = #G.mul_exhaust.cards
			for i = 1, exhaust_count do
				draw_card(
					G.mul_exhaust,
					G.deck,
					i * 100 / exhaust_count,
					"up",
					nil,
					nil,
					0.005,
					i % 2 == 0,
					nil,
					math.max((21 - i) / 20, 0.7)
				)
			end
			return true
		end,
	}))
end

---@param cards Card[] | Card
function Multiverse.exhaust_cards(cards)
	if not cards[1] then
		cards = { cards }
	end
	for _, card in ipairs(cards) do
		if not card.playing_card then
			error("Only Playing cards can be exhausted")
		end
	end
	play_sound("mul_exhaust", 1.4, 1)
	SMODS.calculate_context({ mul_exhaust_playing_cards = true, exhausted = cards })
	for i, card in ipairs(cards) do
		if not card.playing_card then
			error("Exhausted card is not a playing card")
		end
		card:mul_safe_dissolve({ G.C.BLUE }, true, nil, true)
		draw_card(
			card.area,
			G.mul_exhaust,
			i * 100 / #cards,
			"down",
			false,
			card,
			0.005,
			i % 2 == 0,
			nil,
			math.max((21 - i) / 20, 0.7)
		)
	end
end

function Multiverse.in_interaction()
	return G.STATE == G.STATES.MULTIVERSE_INTERACTION_CONSUMABLES
		or G.STATE == G.STATES.MULTIVERSE_INTERACTION_HAND
		or G.STATE == G.STATES.MULTIVERSE_INTERACTION_JOKERS
end

function Multiverse.explode(anchor)
	Multiverse.play_animation("explosion", {
		anchor = anchor,
	})
	play_sound("mul_deltarune_explosion", 1, 0.8)
end

function Multiverse.cannot_interrupt()
	return Multiverse.in_limbo or Multiverse.in_undyne or Multiverse.very_important_thing
end

function Multiverse.lose()
	G.STATE = G.STATES.GAME_OVER
	G:save_settings()
	G.FILE_HANDLER.force = true
	G.STATE_COMPLETE = false
end

---@param moveable Moveable
function Multiverse.get_true_coords(moveable)
	local transform = moveable.VT or moveable.T
	local scale = G.TILESIZE * G.TILESCALE
	return {
		(G.ROOM.T.x + transform.x + transform.w * 0.5) * scale,
		(G.ROOM.T.y + transform.y + transform.h * 0.5) * scale,
	}
end

function Multiverse.to_balatro_units(x)
	return x / (G.TILESIZE * G.TILESCALE)
end

function Multiverse.to_pixels(x)
	return x * (G.TILESIZE * G.TILESCALE)
end

function Multiverse.eggman_secret()
	G.E_MANAGER:add_event(Event({
		func = function()
			if G.GAME.blind.disabled then
				local rows = localize("k_mul_eggman_speech")
				for _, row in ipairs(rows) do
					local len = string.len(row)
					G.E_MANAGER:add_event(Event({
						func = function()
							attention_text({
								scale = 0.7,
								text = row,
								hold = (len * 0.05 + 0.3) * G.SETTINGS.GAMESPEED,
								align = "cm",
								offset = { x = 0, y = -1.7 },
								major = G.play,
							})
							return true
						end,
					}))
					delay((len * 0.05 + 0.5) * G.SETTINGS.GAMESPEED)
				end
				G.GAME.mul_eggman_secret = true
			end
			return true
		end,
	}))
end

function Multiverse.handle_half_cards()
	local should_handle = false
	for _, c in ipairs(G.hand.cards) do
		if Multiverse.is_valid_half(c) and not c.highlighted and c.area == G.hand then
			should_handle = true
		end
	end
	if should_handle then
		G.E_MANAGER:add_event(Event({
			func = function()
				local discarded = 0
				for _, c in ipairs(G.hand.cards) do
					if
						Multiverse.is_valid_half(c)
						and not c.highlighted
						and c.area == G.hand
						and SMODS.pseudorandom_probability(c, "mul_half_card_discard", 1, 4)
					then
						SMODS.change_discard_limit(1)
						discarded = discarded + 1
						G.hand:add_to_highlighted(c, true)
						play_sound("card1", 1)
					end
				end
				if discarded > 0 then
					G.FUNCS.discard_cards_from_highlighted(nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							SMODS.change_discard_limit(-discarded)
							return true
						end,
					}))
				end
				return true
			end,
		}))
		delay(0.7)
	end
end

function Multiverse.handle_ethereal()
	local cards = {}
	for _, c in ipairs(G.hand.cards) do
		if c.ability.set == "mul_Skill" and c.area == G.hand and c.config.center.ethereal then
			cards[#cards + 1] = c
		end
	end
	if next(cards) then
		G.E_MANAGER:add_event(Event({
			func = function()
				Multiverse.exhaust_cards(cards)
				play_sound("card1", 1)
				return true
			end,
		}))
		delay(0.7)
	end
end

function Multiverse.handle_pins(cards)
	local l_insert_index = 1
	for i, card in ipairs(cards) do
		if Multiverse.is_left_pinned(card) then
			table.insert(cards, l_insert_index, table.remove(cards, i))
			l_insert_index = l_insert_index + 1
		elseif Multiverse.is_right_pinned(card) then
			table.insert(cards, table.remove(cards, i))
		end
	end
end

function Multiverse.is_intangible(card)
	return (G.P_CENTERS[card.config.center_key] or {}).mul_intangible
end

function Multiverse.is_left_pinned(card)
	return (G.P_CENTERS[card.config.center_key] or {}).mul_left_pinned
end

function Multiverse.is_right_pinned(card)
	return (G.P_CENTERS[card.config.center_key] or {}).mul_right_pinned
end

---@param context CalcContext
---@param card Card | EnchantmentData
---@param amt integer
---@param args? {seed: string, dist_type: "random" | "even", cards: Card[]}
---@return table?
function Multiverse.handle_distributed_retriggers(context, card, amt, args)
	args = args or {}
	local cards = args.cards or context.scoring_hand
	if context.before and not context.blueprint then
		card.ability._mul_retrigger_index_cache = Multiverse.distribute_retriggers(#cards, amt, args)
	end
	if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand) then
		local i = Multiverse.get_index(context.other_card, cards)
		if i ~= -1 then
			return {
				repetitions = card.ability._mul_retrigger_index_cache[i],
			}
		end
	end
	if context.after then
		card.ability._mul_retrigger_index_cache = nil
	end
end

---Handles retrigger distribution
---@param num_cards integer
---@param amt integer
---@param args {seed: string, dist_type: "random" | "even"}
---@return integer[]
function Multiverse.distribute_retriggers(num_cards, amt, args)
	args = args or {}
	local dist_type = args.dist_type or "even"
	local seed = args.seed or "mul_rand_retriggers"
	local ret = {}
	for i = 1, num_cards do
		ret[i] = 0
	end
	if dist_type == "random" then
		for _ = 1, amt do
			local index = pseudorandom(seed, 1, num_cards)
			ret[index] = (ret[index] or 0) + 1
		end
	elseif dist_type == "even" then
		for i = 1, num_cards do
			ret[i] = math.floor(amt / num_cards)
		end
		for i = 1, amt % num_cards do
			ret[i] = ret[i] + 1
		end
	end
	return ret
end

function Multiverse.get_index(card, card_list)
	local i = -1
	if not card_list then
		return i
	end
	for j, c in ipairs(card_list) do
		if c == card then
			i = j
			break
		end
	end
	return i
end

function Multiverse.modify_passive_stacks(key, amt)
	if not blindexpander.Passives[key].mul_stackable then
		error("Attempt to stack unstackable passive")
	end
	if not G.GAME.blind then
		error("Blind does not exist")
	end
	if not G.GAME.blind.in_blind then
		error("Cannot stack passive outside of a Blind")
	end
	local index = -1
	if G.GAME.blind.passives_data then
		for i, v in ipairs(G.GAME.blind.passives_data) do
			if v.key == key then
				index = i
				break
			end
		end
	end
	if index == -1 and amt > 0 then
		G.GAME.blind:add_passive(key)
		G.GAME.blind.passives_data[#G.GAME.blind.passives_data].config.stacks = amt
	else
		local final_amt = math.max(G.GAME.blind.passives_data[index].config.stacks
			+ amt, 0)
		if final_amt == 0 then
			G.GAME.blind:remove_passive(key)
		else
			G.GAME.blind.passives_data[index].config.stacks = final_amt
		end
	end
end
