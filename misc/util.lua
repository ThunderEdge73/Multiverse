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