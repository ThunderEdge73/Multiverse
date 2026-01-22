---@type Multiverse.limbo_key[]
Multiverse.limbo_keys = {}

local key_file = assert(NFS.newFileData(Multiverse.path .. "assets/misc/limbo_key.png"))
local key_data = assert(love.image.newImageData(key_file))
Multiverse.LIMBO_KEY_SPRITE = assert(love.graphics.newImage(key_data))

local blunder_file = assert(NFS.newFileData(Multiverse.path .. "assets/misc/blunder.png"))
local blunder_data = assert(love.image.newImageData(blunder_file))
Multiverse.BLUNDER_SPRITE = assert(love.graphics.newImage(blunder_data))

-- local limbo_instructions_file = assert(NFS.newFileData(Multiverse.path .. "assets/misc/limbo_instructions.png"))
-- local limbo_instructions_data = assert(love.image.newImageData(limbo_instructions_file))
-- Multiverse.LIMBO_INSTRUCTIONS_SPRITE = assert(love.graphics.newImage(limbo_instructions_data))

Multiverse.LIMBO_KEY_COLORS = {
	{ 236 / 255, 0, 0, 1 },
	{ 1, 115 / 255, 0, 1 },
	{ 1, 233 / 255, 0, 1 },
	{ 0, 1, 1 / 255, 1 },
	{ 0, 234 / 255, 1, 1 },
	{ 0, 20 / 255, 240 / 255, 1 },
	{ 155 / 255, 0, 1, 1 },
	{ 241 / 255, 0, 1, 1 },
}

---@class Multiverse.limbo_key
---@field x number
---@field y number
---@field id number?
---@field end_color number[]
---@field is_correct boolean
---@field current_color number[]

Multiverse.HIDDEN_KEY_COLOR = { 224 / 255, 85 / 255, 32 / 255, 1 }
Multiverse.CORRECT_KEY_COLOR = { 115 / 255, 232 / 255, 69 / 255, 1 }
function Multiverse.add_limbo_keys()
	for i = 1, 2 do
		for j = 1, 4 do
			table.insert(Multiverse.limbo_keys, {
				x = j,
				y = i,
				id = nil,
				end_color = Multiverse.LIMBO_KEY_COLORS[(i - 1) * 4 + j],
				is_correct = false,
				current_color = Multiverse.HIDDEN_KEY_COLOR,
			})
		end
	end
	Multiverse.limbo_keys[pseudorandom("bl_limbo", 1, 8)].is_correct = true
end

function Multiverse.limbo_keys_intro()
	G.GAME.failed_limbo = false
	Multiverse.has_guessed = false
	Multiverse.in_limbo = "start"
	if Multiverse.config.music["Isolation"] then
		play_sound("mul_isolation_limbo", 1, 0.65)
	end
	Multiverse.limbo_anim_prog = 0
	G.E_MANAGER:add_event(
		Event({
			delay = 4.75 * G.SPEEDFACTOR,
			trigger = "ease",
			ease_to = 1,
			ref_table = Multiverse,
			ref_value = "limbo_anim_prog",
			func = function(n)
				for _, key in ipairs(Multiverse.limbo_keys) do
					if key.is_correct then
						key.current_color = math.fmod(n * 30, 2) < 1 and Multiverse.HIDDEN_KEY_COLOR
							or Multiverse.CORRECT_KEY_COLOR
					end
				end
				if n == 1 then
					Multiverse.limbo_keys_swapping()
				end
				return n
			end,
		}),
		"other"
	)
end

Multiverse.swaps = {}
function Multiverse.limbo_keys_swapping()
	for i = 1, 32 do
		Multiverse.swaps["s" .. i] = 0
	end
	Multiverse.limbo_keys_swap(1)
end

function Multiverse.limbo_keys_swap(count)
	ease_background_colour({
		new_colour = lighten(mix_colours(count % 2 == 0 and HEX("F2994B") or G.C.BLACK, G.C.BLACK, 0.3), 0.1),
		special_colour = count % 2 == 0 and HEX("F2994B") or G.C.BLACK,
		contrast = 2,
	})
	Multiverse.in_limbo = "swapping"
	local selection = math.random(1, 8)
	Multiverse.assign_limbo_key_ids()
	G.E_MANAGER:add_event(
		Event({
			delay = 0.278 * G.SPEEDFACTOR,
			trigger = "ease",
			ease_to = 1,
			ease = "quad",
			ref_table = Multiverse.swaps,
			ref_value = "s" .. count,
			func = function(n)
				if selection == 1 then
					Multiverse.limbo_keys_cross(n)
				elseif selection == 2 then
					Multiverse.limbo_keys_rotate_ccw(n)
				elseif selection == 3 then
					Multiverse.limbo_keys_rotate_halves_ccw(n)
				elseif selection == 4 then
					Multiverse.limbo_keys_rotate_cw(n)
				elseif selection == 5 then
					Multiverse.limbo_keys_rotate_halves_cw(n)
				elseif selection == 6 then
					Multiverse.limbo_keys_swap_cols(n)
				elseif selection == 7 then
					Multiverse.limbo_keys_swap_rows(n)
				else
					Multiverse.limbo_keys_swap_halves(n)
				end
				if n == 1 then
					if count < 32 then
						Multiverse.limbo_keys_swap(count + 1)
					else
						Multiverse.limbo_keys_end()
					end
				end
				return n
			end,
		}),
		"other"
	)
end

function Multiverse.limbo_keys_end()
	Multiverse.in_limbo = "end"
	ease_background_colour({
		new_colour = lighten(G.C.BLACK, 0.1),
		special_colour = G.C.BLACK,
		contrast = 2,
	})
	G.E_MANAGER:add_event(
		Event({
			trigger = "after",
			delay = 4 * G.SPEEDFACTOR,
			func = function()
				if not Multiverse.has_guessed then
					Multiverse.change_blind_size(function(chips)
						return chips * 3
					end)
					G.GAME.failed_limbo = true
					Multiverse.start_animation("explosion")
					play_sound("mul_deltarune_explosion", 1, 0.8)
				end
				Multiverse.in_limbo = nil
				Multiverse.limbo_keys = {}
				Multiverse.has_guessed = false
				return true
			end,
		}),
		"other"
	)
end

function Multiverse.assign_limbo_key_ids()
	for _, key in ipairs(Multiverse.limbo_keys) do
		key.id = (key.x + (key.y - 1) * 4)
	end
end

function Multiverse.limbo_keys_rotate_cw(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id <= 3 then
			key.x = key.id + n
		elseif key.id == 4 then
			key.y = 1 + n
		elseif key.id >= 6 then
			key.x = key.id - 4 - n
		else
			key.y = 2 - n
		end
	end
end

function Multiverse.limbo_keys_rotate_ccw(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id == 1 then
			key.y = 1 + n
		elseif key.id <= 4 then
			key.x = key.id - n
		elseif key.id <= 7 then
			key.x = key.id - 4 + n
		else
			key.y = 2 - n
		end
	end
end

function Multiverse.limbo_keys_cross(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id <= 4 then
			key.y = 1 + n
		else
			key.y = 2 - n
		end
		if key.id % 2 == 1 then
			key.x = key.id % 4 + n
		else
			key.x = (key.id + 2) % 4 + 2 - n
		end
	end
end

function Multiverse.limbo_keys_rotate_halves_cw(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id == 1 or key.id == 3 then
			key.x = key.id + n
		elseif key.id == 2 or key.id == 4 then
			key.y = 1 + n
		elseif key.id == 5 or key.id == 7 then
			key.y = 2 - n
		else
			key.x = key.id - 4 - n
		end
	end
end

function Multiverse.limbo_keys_rotate_halves_ccw(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id == 1 or key.id == 3 then
			key.y = 1 + n
		elseif key.id == 2 or key.id == 4 then
			key.x = key.id - n
		elseif key.id == 5 or key.id == 7 then
			key.x = key.id - 4 + n
		else
			key.y = 2 - n
		end
	end
end

function Multiverse.limbo_keys_swap_cols(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id % 4 == 1 or key.id % 4 == 3 then
			key.x = key.id % 4 + n
		else
			key.x = (key.id + 2) % 4 + 2 - n
		end
	end
end

function Multiverse.limbo_keys_swap_rows(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id <= 4 then
			key.y = 1 + n
		else
			key.y = 2 - n
		end
	end
end

function Multiverse.limbo_keys_swap_halves(n)
	for _, key in ipairs(Multiverse.limbo_keys) do
		if key.id % 4 == 1 or key.id % 4 == 2 then
			key.x = key.id % 4 + 2 * n
		else
			key.x = (key.id + 1) % 4 + 3 - 2 * n
		end
	end
end

function Multiverse.detect_key_click(x, y)
	local width, height = love.graphics.getDimensions()
	local x_factor = width / 1536
	local y_factor = height / 864
	for _, key in ipairs(Multiverse.limbo_keys) do
		local cx = love.graphics.getWidth() / 2 + (key.x - 2.5) * 150 * x_factor
		local cy = love.graphics.getHeight() / 2 + (key.y - 1.5) * 150 * y_factor
		if x > cx - 30 * x_factor and x < cx + 30 * x_factor and y > cy - 21 * y_factor and y < cy + 21 * y_factor then
			return key
		end
	end
end

function Multiverse.handle_limbo_drawing(x_factor, y_factor)
	if Multiverse.in_limbo and not G.SETTINGS.paused then
		-- love.graphics.setColor(1, 1, 1, 1)
		-- love.graphics.draw(
		-- 	Multiverse.LIMBO_INSTRUCTIONS_SPRITE,
		-- 	love.graphics.getWidth() - 50 * x_factor,
		-- 	love.graphics.getHeight() / 2,
		-- 	0,
		-- 	x_factor,
		-- 	y_factor,
		-- 	200,
		-- 	150,
		-- 	0,
		-- 	0
		-- )
		if Multiverse.in_limbo == "end" then
			for _, key in ipairs(Multiverse.limbo_keys) do
				love.graphics.setColor(key.end_color)
				love.graphics.draw(
					Multiverse.secret_limbo and Multiverse.BLUNDER_SPRITE or Multiverse.LIMBO_KEY_SPRITE,
					love.graphics.getWidth() / 2 + (key.x - 2.5) * 150 * x_factor,
					love.graphics.getHeight() / 2 + (key.y - 1.5) * 150 * y_factor,
					0,
					x_factor * (Multiverse.secret_limbo and 1 / 9 or 1),
					y_factor * (Multiverse.secret_limbo and 1 / 9 or 1),
					Multiverse.secret_limbo and 237.5 or 30.5,
					Multiverse.secret_limbo and 237.5 or 21.5,
					0,
					0
				)
			end
		else
			for _, key in ipairs(Multiverse.limbo_keys) do
				love.graphics.setColor(key.current_color)
				love.graphics.draw(
					Multiverse.secret_limbo and Multiverse.BLUNDER_SPRITE or Multiverse.LIMBO_KEY_SPRITE,
					love.graphics.getWidth() / 2 + (key.x - 2.5) * 150 * x_factor,
					love.graphics.getHeight() / 2 + (key.y - 1.5) * 150 * y_factor,
					0,
					x_factor * (Multiverse.secret_limbo and 1 / 9 or 1),
					y_factor * (Multiverse.secret_limbo and 1 / 9 or 1),
					Multiverse.secret_limbo and 237.5 or 30.5,
					Multiverse.secret_limbo and 237.5 or 21.5,
					0,
					0
				)
			end
		end
	end
end
