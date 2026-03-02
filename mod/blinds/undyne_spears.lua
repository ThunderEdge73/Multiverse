local near_spear_file = assert(Multiverse.NFS.newFileData(Multiverse.path .. "assets/misc/near_spear.png"))
local near_spear_data = assert(love.image.newImageData(near_spear_file))
Multiverse.NEAR_SPEAR_SPRITE = assert(love.graphics.newImage(near_spear_data))

local far_spear_file = assert(Multiverse.NFS.newFileData(Multiverse.path .. "assets/misc/far_spear.png"))
local far_spear_data = assert(love.image.newImageData(far_spear_file))
Multiverse.FAR_SPEAR_SPRITE = assert(love.graphics.newImage(far_spear_data))

local reverse_spear_file = assert(Multiverse.NFS.newFileData(Multiverse.path .. "assets/misc/reverse_spear.png"))
local reverse_spear_data = assert(love.image.newImageData(reverse_spear_file))
Multiverse.REVERSE_SPEAR_SPRITE = assert(love.graphics.newImage(reverse_spear_data))

local green_soul_file = assert(Multiverse.NFS.newFileData(Multiverse.path .. "assets/misc/green_soul.png"))
local green_soul_data = assert(love.image.newImageData(green_soul_file))
Multiverse.GREEN_SOUL_SPRITE = assert(love.graphics.newImage(green_soul_data))

local soul_background_file = assert(Multiverse.NFS.newFileData(Multiverse.path .. "assets/misc/soul_background.png"))
local soul_background_data = assert(love.image.newImageData(soul_background_file))
Multiverse.SOUL_BACKGROUND_SPRITE = assert(love.graphics.newImage(soul_background_data))

local shield_file = assert(Multiverse.NFS.newFileData(Multiverse.path .. "assets/misc/shield.png"))
local shield_data = assert(love.image.newImageData(shield_file))
Multiverse.SHIELD_SPRITE = assert(love.graphics.newImage(shield_data))

-- local undying_instructions_file = assert(Multiverse.NFS.newFileData(Multiverse.path .. "assets/misc/undying_instructions.png"))
-- local undying_instructions_data = assert(love.image.newImageData(undying_instructions_file))
-- Multiverse.UNDYING_INSTRUCTIONS_SPRITE = assert(love.graphics.newImage(undying_instructions_data))

---@class Multiverse.undyne_spear
---@field velocity number
---@field dir "left" | "right" | "up" | "down"
---@field is_reversed boolean
---@field is_reversing boolean
---@field r number
---@field theta number
---@field active boolean
---@field opacity number

Multiverse.in_undyne = false
Multiverse.shield_dir = nil

---@type Multiverse.undyne_spear[]
Multiverse.undyne_spears = {}

Multiverse.shield_rotations = {
	up = 0,
	right = math.pi / 2,
	down = math.pi,
	left = 3 * math.pi / 2,
}

Multiverse.spear_rotations = {
	left = 0,
	up = math.pi / 2,
	right = math.pi,
	down = 3 * math.pi / 2,
}

Multiverse.opposite_sides = {
	left = "right",
	right = "left",
	up = "down",
	down = "up",
}

---@type {[1]: number, [2]: "left" | "up" | "down" | "right", [3]: boolean, [4]: number}[][]
Multiverse.undyne_attacks = {
	{ -- 1
		{ 800, "right", false, 0.35 },
		{ 800, "left", true, 0.35 },
		{ 800, "left", false, 0.35 },
		{ 800, "right", true, 0.35 },
		{ 800, "up", false, 0.35 },
		{ 800, "down", true, 0.35 },
		{ 800, "down", false, 0.35 },
		{ 800, "up", true, 0.35 },
		{ 1000, "up", false, 1.2 },
		{ 1000, "right", false, 0.2 },
		{ 1000, "down", false, 0.2 },
		{ 1000, "left", false, 0.2 },
	},
	{ -- 2
		{ 500, "right", false, 0.25 },
		{ 500, "right", true, 0.25 },
		{ 500, "right", false, 0.25 },
		{ 500, "right", true, 0.25 },
		{ 800, "left", false, 1.4 },
		{ 800, "left", false, 0.2 },
		{ 800, "down", true, 0.4 },
		{ 800, "up", true, 0.4 },
		{ 800, "right", true, 0.4 },
		{ 800, "left", true, 0.4 },
		{ 1500, "up", false, 2 },
	},
	{ -- 3
		{ 200, "right", false, 0.25 },
		{ 200, "up", false, 0.25 },
		{ 200, "right", false, 0.25 },
		{ 200, "down", false, 0.25 },
		{ 200, "left", true, 0.25 },
		{ 200, "left", false, 0.25 },
		{ 200, "up", false, 0.25 },
		{ 200, "down", false, 0.25 },
		{ 200, "up", true, 0.25 },
		{ 200, "down", true, 0.25 },
		{ 200, "right", false, 0.25 },
		{ 200, "left", false, 0.25 },
		{ 200, "right", false, 0.25 },
		{ 200, "left", false, 0.25 },
		{ 200, "up", true, 0.25 },
		{ 200, "down", true, 0.25 },
		{ 200, "up", true, 0.25 },
		{ 200, "down", true, 0.25 },
	},
	{ -- 4
		{ 1000, "up", false, 0.25 },
		{ 1000, "down", false, 0.25 },
		{ 1000, "right", false, 0.25 },
		{ 1000, "right", false, 0.25 },
		{ 1000, "left", false, 0.25 },
		{ 1000, "down", false, 0.25 },
		{ 1000, "up", false, 0.25 },
		{ 1000, "up", false, 0.25 },
		{ 1000, "down", false, 0.25 },
		{ 1000, "left", false, 0.25 },
		{ 1000, "up", false, 0.25 },
		{ 1000, "right", false, 0.25 },
		{ 1000, "up", false, 0.25 },
		{ 1000, "down", false, 0.25 },
		{ 1000, "left", false, 0.25 },
		{ 1000, "right", false, 0.25 },
	},
	{ -- 5
		{ 800, "up", false, 0.4 },
		{ 800, "up", false, 0.2 },
		{ 800, "up", false, 0.2 },
		{ 800, "up", false, 0.2 },
		{ 800, "left", true, 0.2 },
		{ 800, "up", false, 0.4 },
		{ 800, "up", false, 0.2 },
		{ 800, "up", false, 0.2 },
		{ 800, "up", false, 0.2 },
		{ 800, "right", true, 0.2 },
		{ 800, "up", true, 0.4 },
		{ 800, "up", true, 0.2 },
		{ 800, "up", true, 0.2 },
		{ 800, "up", true, 0.2 },
		{ 800, "up", false, 0.2 },
	},
	{ -- 6
		{ 700, "down", false, 0.3 },
		{ 300, "left", true, 0.3 },
		{ 700, "right", false, 0.3 },
		{ 700, "down", false, 0.3 },
		{ 700, "left", false, 0.3 },
		{ 700, "up", false, 0.3 },
		{ 700, "left", false, 0.3 },
		{ 700, "up", false, 0.3 },
		{ 700, "down", false, 0.3 },
		{ 300, "right", true, 0.3 },
		{ 700, "up", false, 0.3 },
		{ 700, "right", false, 0.3 },
		{ 700, "up", false, 0.3 },
		{ 700, "down", false, 0.3 },
		{ 700, "left", false, 0.3 },
		{ 700, "right", false, 0.3 },
	},
	{ -- 7
		{ 800, "left", false, 0.3 },
		{ 800, "right", false, 0.3 },
		{ 800, "up", false, 0.3 },
		{ 800, "left", false, 0.3 },
		{ 800, "right", false, 0.3 },
		{ 800, "down", true, 0.3 },
		{ 800, "right", true, 0.3 },
		{ 800, "left", false, 0.3 },
		{ 800, "down", false, 0.3 },
		{ 800, "left", true, 0.3 },
		{ 800, "right", true, 0.3 },
		{ 800, "right", false, 0.3 },
		{ 800, "left", false, 0.3 },
		{ 1500, "right", false, 2 },
	},
	{ -- 8
		{ 700, "left", false, 0.3 },
		{ 400, "right", true, 0.6 },
		{ 700, "right", true, 0.3 },
		{ 500, "down", true, 0.4 },
		{ 700, "right", false, 0.6 },
		{ 700, "down", false, 0.3 },
		{ 700, "left", false, 0.5 },
		{ 700, "down", false, 0.3 },
		{ 700, "down", false, 0.3 },
		{ 1000, "left", true, 0.5 },
	},
	{ -- 9
		{ 550, "up", false, 0.4 },
		{ 600, "down", true, 0.4 },
		{ 625, "left", false, 0.7 },
		{ 650, "right", true, 0.4 },
		{ 700, "down", false, 0.7 },
		{ 800, "up", true, 0.4 },
		{ 550, "up", false, 0.4 },
		{ 600, "down", true, 0.4 },
		{ 625, "left", false, 0.7 },
		{ 650, "right", true, 0.4 },
		{ 700, "down", false, 0.7 },
		{ 800, "up", true, 0.4 },
		{ 900, "up", true, 2.5 },
		{ 900, "down", true, 0.2 },
	},
	{ -- 10
		{ 800, "up", false, 0.4 },
		{ 1200, "up", false, 0.08 },
		{ 1195, "up", false, 0.08 },
		{ 1190, "up", false, 0.08 },
		{ 1185, "up", false, 0.2 },
		{ 1180, "up", false, 0.08 },
		{ 1075, "up", false, 0.08 },
		{ 1070, "up", false, 0.08 },
		{ 1065, "up", false, 0.1 },
		{ 1200, "left", false, 0.23 },
		{ 1195, "left", false, 0.08 },
		{ 1190, "left", false, 0.08 },
		{ 1185, "left", false, 0.08 },
		{ 1180, "left", false, 0.08 },
		{ 1075, "left", false, 0.08 },
		{ 1070, "left", false, 0.08 },
		{ 1065, "left", false, 0.08 },
		{ 1200, "up", true, 0.45 },
		{ 1195, "up", true, 0.08 },
		{ 1190, "down", false, 0.08 },
		{ 1185, "up", true, 0.08 },
		{ 1180, "down", false, 0.08 },
		{ 1075, "up", true, 0.08 },
		{ 1070, "up", true, 0.08 },
		{ 1065, "up", true, 0.08 },
		{ 900, "right", true, 0.5 },
		{ 1100, "left", true, 0.5 },
	},
	{ -- 11
		{ 150, "up", false, 0.4 },
		{ 150, "down", false, 0.336 },
		{ 150, "left", false, 0.64 },
		{ 150, "down", false, 0.336 },
		{ 150, "up", false, 0.336 },
		{ 150, "down", false, 0.336 },
		{ 150, "down", false, 0.128 },
		{ 150, "right", false, 0.208 },
		{ 150, "down", false, 0.336 },
		{ 300, "up", false, 3 },
		{ 1200, "up", true, 2.25 },
	},
	{ -- 12
		{ 125, "up", true, 0.4 },
		{ 400, "down", false, 0.3 },
		{ 400, "right", false, 0.4 },
		{ 410, "left", false, 0.3 },
		{ 400, "left", false, 0.08 },
		{ 600, "up", false, 0.28 },
		{ 400, "down", false, 0.3 },
		{ 1000, "left", true, 1 },
		{ 800, "left", true, 0.3 },
		{ 600, "up", false, 0.35 },
		{ 400, "down", false, 0.35 },
		{ 400, "left", false, 0.4 },
	},
	{ -- 13
		{ 190, "up", false, 0.2 },
		{ 195, "right", false, 0.2 },
		{ 200, "left", false, 0.15 },
		{ 200, "down", true, 0.7 },
		{ 190, "down", false, 0.9 },
		{ 195, "left", false, 0.425 },
		{ 200, "up", false, 0.175 },
		{ 300, "up", true, 0.2 },
		{ 125, "down", false, 0.8 },
		{ 450, "right", false, 0.1 },
		{ 400, "left", false, 0.3 },
		{ 300, "up", false, 0.8 },
		{ 300, "down", false, 0.6 },
	},
	{ -- 14
		{ 600, "up", false, 0.5 },
		{ 610, "right", false, 0.05 },
		{ 610, "left", false, 0.6 },
		{ 600, "down", false, 0.05 },
		{ 580, "up", false, 0.4 },
		{ 620, "down", false, 0 },
		{ 640, "left", false, 0.8 },
		{ 680, "right", false, 0.05 },
		{ 800, "up", true, 0.8 },
		{ 800, "down", false, 0.05 },
	},
	{ -- 15
		{ 800, "up", true, 0.6 },
		{ 850, "up", true, 0.1 },
		{ 900, "up", true, 0.1 },
		{ 800, "left", false, 0.25 },
		{ 850, "right", true, 0.2 },
		{ 900, "right", true, 0.2 },
		{ 800, "down", true, 0.35 },
		{ 850, "down", true, 0.1 },
		{ 900, "down", true, 0.1 },
		{ 800, "right", true, 0.375 },
		{ 850, "right", true, 0.1 },
		{ 1100, "right", false, 0.275 },
		{ 1300, "left", false, 0.375 },
	},
}

---@param i integer?
---@param p integer | {[1]: number, [2]: "left" | "up" | "down" | "right", [3]: boolean, [4]: number}[]?
Multiverse.start_undyne_attack = function(i, p)
	local index = i or 1
	local pattern = p or Multiverse.undyne_attacks[math.random(#Multiverse.undyne_attacks)]
	if type(p) == "number" then
		pattern = Multiverse.undyne_attacks[p]
	end
	G.E_MANAGER:add_event(
		Event({
			trigger = "after",
			delay = pattern[index][4],
			timer = "REAL",
			func = function()
				local spear = {
					r = 850,
					theta = Multiverse.spear_rotations[pattern[index][2]],
					velocity = pattern[index][1],
					is_reversed = pattern[index][3],
					active = true,
					is_reversing = false,
					dir = pattern[index][2],
					opacity = 1,
				}
				table.insert(Multiverse.undyne_spears, spear)
				if pattern[index + 1] then
					Multiverse.start_undyne_attack(index + 1, pattern)
				else
					G.E_MANAGER:add_event(
						Event({
							func = function()
								local should_end = true
								for _, s in ipairs(Multiverse.undyne_spears) do
									if s.active then
										should_end = false
										break
									end
								end
								if should_end then
									ease_value(
										Multiverse,
										"dark_bg_percent",
										1,
										nil,
										"REAL",
										true,
										0.5
									)
									G.E_MANAGER:add_event(
										Event({
											trigger = "after",
											delay = 0.51,
											timer = "REAL",
											func = function()
												Multiverse.shield_dir = nil
												Multiverse.dark_bg_active = false
												Multiverse.in_undyne = false
												return true
											end,
										}),
										"other"
									)
									return true
								end
								return false
							end,
						}),
						"other"
					)
				end
				return true
			end,
		}),
		"other"
	)
	return #pattern
end

function Multiverse.handle_undyne_drawing(x_factor, y_factor)
	if Multiverse.in_undyne and not G.SETTINGS.paused and G.STATE ~= G.STATES.GAME_OVER then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(
			Multiverse.SOUL_BACKGROUND_SPRITE,
			love.graphics.getWidth() / 2,
			love.graphics.getHeight() / 2,
			0,
			x_factor,
			y_factor,
			74,
			74,
			0,
			0
		)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(
			Multiverse.GREEN_SOUL_SPRITE,
			love.graphics.getWidth() / 2,
			love.graphics.getHeight() / 2,
			0,
			x_factor,
			y_factor,
			74,
			74,
			0,
			0
		)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(
			Multiverse.SHIELD_SPRITE,
			love.graphics.getWidth() / 2,
			love.graphics.getHeight() / 2,
			Multiverse.shield_rotations[Multiverse.shield_dir or "up"] or 0,
			x_factor,
			y_factor,
			74,
			74,
			0,
			0
		)
		for _, spear in ipairs(Multiverse.undyne_spears) do
			if spear.active then
				love.graphics.setColor(1, 1, 1, spear.opacity)
				local current_sprite
				if spear.is_reversed then
					current_sprite = Multiverse.REVERSE_SPEAR_SPRITE
				elseif spear.r <= 300 then
					current_sprite = Multiverse.NEAR_SPEAR_SPRITE
				else
					current_sprite = Multiverse.FAR_SPEAR_SPRITE
				end
				love.graphics.draw(
					current_sprite,
					love.graphics.getWidth() / 2 - spear.r * math.cos(spear.theta) * x_factor,
					love.graphics.getHeight() / 2 - spear.r * math.sin(spear.theta) * y_factor,
					Multiverse.spear_rotations[spear.dir],
					x_factor,
					y_factor,
					22,
					14,
					0,
					0
				)
			end
		end
	end
end

function Multiverse.update_spears()
	for i, spear in pairs(Multiverse.undyne_spears) do
		if spear.active and not G.SETTINGS.paused then
			if spear.r < 35 then
				Multiverse.process_undyne_hit(10)
				spear.active = false
			elseif spear.r < 75 then
				local check_dir = spear.is_reversed and Multiverse.opposite_sides[spear.dir] or spear.dir
				if check_dir == Multiverse.shield_dir then
					spear.active = false
					play_sound("mul_block_spear", 1, 0.75)
				end
			end
			if
				spear.is_reversed
				and not spear.is_reversing
				and spear.r < Multiverse.clamp(spear.velocity / 4 + 150, 250, 350)
			then
				spear.is_reversing = true
				G.E_MANAGER:add_event(
					Event({
						trigger = "ease",
						delay = math.min(0.2, 0.3 - spear.velocity / 10000),
						timer = "REAL",
						ease_to = spear.theta + math.pi,
						ref_table = spear,
						ref_value = "theta",
						blockable = false,
						blocking = false,
					}),
					"other",
					true
				)
			end
			if G.STATE ~= G.STATES.GAME_OVER then
				spear.r = spear.r - G.real_dt * spear.velocity
			end
		end
	end
end

function Multiverse.process_undyne_hit(percent)
	play_sound("mul_take_damage", 1, 2.0)
	Multiverse.modify_current_score(-G.GAME.blind.chips / (percent * G.GAME.mul_undyne_damage_mult), true)
	local target = pseudorandom_element(G.hand.cards, "undying_target")
	SMODS.juice_up_blind()
	if target then
		SMODS.destroy_cards(target, nil, true)
	end
	if
		(G.GAME.challenge == "c_mul_monsoon" and G.GAME.chips < -G.GAME.blind.chips / 2)
		or G.GAME.challenge == "c_mul_cant_touch_this"
	then
		Multiverse.in_undyne = nil
		Multiverse.undyne_spears = {}
		Multiverse.lose()
	end
end
