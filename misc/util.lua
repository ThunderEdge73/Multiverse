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
function Multiverse.filter(t, func)
	local ret = {}
	for _, v in pairs(t) do
		if func(v) then
			table.insert(ret, v)
		end
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

---@param card Card
function Multiverse.get_card_x_pos(card)
	return 155 * Multiverse.get_screen_x_scale() + card.children.center.CT.x * card.children.center.scale.x / 1.0445
end

function Multiverse.get_card_y_pos(card)
	return 127.5 * Multiverse.get_screen_y_scale() + card.children.center.CT.y * card.children.center.scale.y / 1.39
end

---Basically just Card:start_dissolve but doesnt destroy the card
function Card:mul_safe_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
	local dissolve_time = 0.7 * (dissolve_time_fac or 1)
	self.dissolve = 0
	self.dissolve_colours = dissolve_colours or { G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY }
	if not no_juice then
		self:juice_up()
	end
	local childParts = Particles(0, 0, 0, 0, {
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
			childParts:fade(0.3 * dissolve_time)
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

function Card:mul_no_juice_materialize(dissolve_colours, silent, timefac)
	local dissolve_time = 0.6 * (timefac or 1)
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
		or { G.C.GREEN }
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

---@param card Card
---@param func fun(playing_card: Card): nil
---@param filter_func? fun(playing_card: Card): boolean?
function Multiverse.apply_to_hand_animation(card, func, filter_func)
	local cards = {}
	if not filter_func then
		cards = G.hand.highlighted
	else
		Multiverse.apply_to_hand(function(playing_card)
			if filter_func(playing_card) then
				cards[#cards + 1] = playing_card
			end
		end)
	end
	if #cards == 0 then
		return
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.4,
		func = function()
			play_sound("tarot1")
			card:juice_up(0.3, 0.5)
			return true
		end,
	}))
	for i = 1, #cards do
		local percent = 1.15 - (i - 0.999) / (#cards - 0.998) * 0.3
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				cards[i]:flip()
				play_sound("card1", percent)
				cards[i]:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end
	delay(0.2)
	for i = 1, #cards do
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				func(cards[i])
				return true
			end,
		}))
	end
	for i = 1, #cards do
		local percent = 0.85 + (i - 0.999) / (#cards - 0.998) * 0.3
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				cards[i]:flip()
				play_sound("tarot2", percent, 0.6)
				cards[i]:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			if #G.hand.highlighted > 0 then
				G.hand:unhighlight_all()
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

---If `operation` is a number, then it will be added to current blind size
---Otherwise, sets blind size equal to the result of the operation
---@param operation number | fun(chips: number): number
function Multiverse.change_blind_size(operation)
	if G.GAME.facing_blind then
		local returns = {}
		local amt = type(operation) == "function" and operation(G.GAME.blind.chips) or (G.GAME.blind.chips + operation)
		G.GAME.blind.chips = math.floor(amt + 0.5)
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	end
end

---Internal code taken from vanilla remade wiki
function Multiverse.create_random_tag()
	local tag_pool = get_current_pool("Tag")
	local selected_tag = pseudorandom_element(tag_pool, "mul_seed")
	local it = 1
	while selected_tag == "UNAVAILABLE" do
		it = it + 1
		selected_tag = pseudorandom_element(tag_pool, "mul_seed_resample" .. it)
	end
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

function Multiverse.is_valid_frankenstein(card)
	if not card then
		return false
	end
	return type((card.ability or {}).extra) == "table"
		and card.ability.extra.enhancement1
		and card.ability.extra.enhancement2
		and card.ability.extra.enhancement1 ~= card.ability.extra.enhancement2
end

---@return boolean
function Multiverse.can_frankenstein_fuse_selected()
	return G.hand ~= nil
		and G.hand.highlighted
		and #G.hand.highlighted == 2
		and not SMODS.is_eternal(G.hand.highlighted[1], { mul_fusion = true })
		and not SMODS.is_eternal(G.hand.highlighted[2], { mul_fusion = true })
		and G.hand.highlighted[1].config.center.key ~= "c_base"
		and G.hand.highlighted[2].config.center.key ~= "c_base"
		and G.hand.highlighted[1].config.center.key ~= G.hand.highlighted[2].config.center.key
		and Multiverse.is_valid_half(G.hand.highlighted[1])
		and Multiverse.is_valid_half(G.hand.highlighted[2])
		and G.hand.highlighted[1].ability.mul_half_card ~= G.hand.highlighted[2].ability.mul_half_card
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
---@param forced_half? boolean
function Multiverse.halve_cards(cards_to_split, num, is_random, forced_half)
	local cards
	if not cards_to_split[1] then -- If cards_to_split is a single card
		cards = { cards_to_split }
	else
		cards = cards_to_split
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
			play_sound("slice1", 0.96 + math.random() * 0.08)
			return true
		end,
	}))
end

function Multiverse.frankenstein_fuse()
	local c1 = G.hand.highlighted[1]
	local c2 = G.hand.highlighted[2]
	local left_enh_key = c1.ability.mul_half_card == "left" and c1.config.center.key or c2.config.center.key
	local right_enh_key = c1.ability.mul_half_card == "left" and c2.config.center.key or c1.config.center.key
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			local new_card = SMODS.add_card({ set = "Enhanced", key = "m_mul_frankenstein", no_edition = true })
			new_card.ability.extra.enhancement1 = left_enh_key
			new_card.ability.extra.enhancement2 = right_enh_key
			SMODS.calculate_context({ playing_card_added = true, cards = new_card })
			SMODS.destroy_cards({ c1, c2 }, nil, true)
			return true
		end,
	}))
end

G.FUNCS.mul_draw_from_exhausted_to_deck = function(e)
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
