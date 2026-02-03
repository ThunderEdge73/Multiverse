---@type table<string, Multiverse.AnimationData>
Multiverse.all_animations = {}

---Registers an animation to a global table.
---Access this animation with Multiverse.all_animations[key].
---@param t Multiverse.Animation
---@return Multiverse.AnimationData
function Multiverse.Animation(t)
	local file_data =
		assert(NFS.newFileData(Multiverse.path .. "assets/animations/" .. t.path), "Failed to get file data")
	local image_data = assert(love.image.newImageData(file_data), "Failed to convert to image data")
	local love_image = assert(love.graphics.newImage(image_data), "Failed to create an image")
	---@type Multiverse.AnimationData
	local anim_data = {
		frames = {},
		image = love_image,
		is_active = false,
		progress = 0,
		is_continuous = t.is_continuous or false,
		anchor = t.anchor,
		x_scale = t.x_scale or 1,
		y_scale = t.y_scale or 1,
		rotation = t.rotation or 0,
		px = t.px,
		py = t.py,
		duration = t.duration,
	}
	for i = 1, t.frames do
		local x, y = (i - 1) % (t.columns or i), (t.columns and math.floor((i - 1) / t.columns) or 0)
		anim_data.frames[#anim_data.frames + 1] = love.graphics.newQuad(x * t.px, y * t.py, t.px, t.py, love_image)
	end
	Multiverse.all_animations = Multiverse.all_animations or {}
	Multiverse.all_animations[t.key] = anim_data
	return anim_data
end

---@type table<string,table<string, number>>>
Multiverse.anchors = {
	x = {
		l = 0,
		c = love.graphics.getWidth() / 2,
		r = love.graphics.getWidth(),
	},
	y = {
		t = 0,
		c = love.graphics.getHeight() / 2,
		b = love.graphics.getHeight(),
	},
}
---Gets the correct offset for love.draw based on the animation's dimensions
---using a function that takes in AnimationData or VideoData and returns a number.
---The functions are grouped by axis and then by alignment type.
---@type table<string, table<string, fun(a: Multiverse.AnimationData | Multiverse.VideoData): number>>
Multiverse.base_offsets = {
	x = {
		l = function(a)
			return 0
		end,
		c = function(a)
			return a.px / 2
		end,
		r = function(a)
			return a.px
		end,
	},
	y = {
		t = function(a)
			return 0
		end,
		c = function(a)
			return a.py / 2
		end,
		b = function(a)
			return a.py
		end,
	},
}

---Starts the animation with the given key.
---@param key string The key of the animation to start
function Multiverse.start_animation(key)
	if Multiverse.all_animations[key] then
		Multiverse.all_animations[key].progress = 0
		Multiverse.all_animations[key].is_active = true
	else
		error("No animation for " .. key .. " exists")
	end
end

---Ends the animation with the given key.
---@param key string
function Multiverse.end_animation(key)
	if Multiverse.all_animations[key] then
		Multiverse.all_animations[key].progress = 0
		Multiverse.all_animations[key].is_active = false
	else
		error("No animation for " .. key .. " exists")
	end
end

---@type table<string, Multiverse.VideoData>
Multiverse.all_videos = {}

---Registers a video to a global table.
---Access this video with Multiverse.all_videos[key].
---@param t Multiverse.Video
---@return Multiverse.VideoData
function Multiverse.Video(t)
	local path = Multiverse.path .. "assets/videos/" .. t.path
	local f = NFS.read(path)
		love.filesystem.write("mul_" .. t.key .. ".ogv", f)
	local love_video = love.graphics.newVideo("mul_" .. t.key .. ".ogv")
	if love_video:getSource() then
		love_video:getSource():setVolume(G.SETTINGS.SOUND.volume * G.SETTINGS.SOUND.game_sounds_volume / 1000)
	end
	---@type Multiverse.VideoData
	local v_data = {
		video = love_video,
		anchor = t.anchor,
		x_scale = t.x_scale or 1,
		y_scale = t.y_scale or 1,
		rotation = t.rotation or 0,
		px = love_video:getWidth(),
		py = love_video:getHeight(),
		is_visible = false,
	}
	Multiverse.all_videos = Multiverse.all_videos or {}
	Multiverse.all_videos[t.key] = v_data
	return v_data
end

function Multiverse.play_video(key)
	if Multiverse.all_videos[key] then
		Multiverse.all_videos[key].video:rewind()
		Multiverse.all_videos[key].video:play()
		Multiverse.all_videos[key].is_visible = true
	else
		error("No video for " .. key .. " exists")
	end
end

function Multiverse.pause_video(key)
	if Multiverse.all_videos[key] then
		Multiverse.all_videos[key].video:pause()
	else
		error("No video for " .. key .. " exists")
	end
end

function Multiverse.stop_video(key)
	if Multiverse.all_videos[key] then
		Multiverse.all_videos[key].is_visible = false
		Multiverse.all_videos[key].video:pause()
		Multiverse.all_videos[key].video:rewind()
	else
		error("No video for " .. key .. " exists")
	end
end

function Multiverse.handle_other_drawing(x_factor, y_factor)
	for key, anim in pairs(Multiverse.all_animations) do
		if anim.is_active then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(
				anim.image,
				anim.frames[Multiverse.clamp(math.floor(anim.progress) + 1, 1, #anim.frames)],
				Multiverse.anchors.x[anim.anchor.x_alignment] + (anim.anchor.x_offset or 0) * x_factor,
				Multiverse.anchors.y[anim.anchor.y_alignment] + (anim.anchor.y_offset or 0) * y_factor,
				anim.rotation,
				anim.x_scale * x_factor,
				anim.y_scale * y_factor,
				Multiverse.base_offsets.x[anim.anchor.x_alignment](anim),
				Multiverse.base_offsets.y[anim.anchor.y_alignment](anim),
				0,
				0
			)
		end
	end
	for key, video in pairs(Multiverse.all_videos) do
		if video.is_visible then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(
				video.video,
				Multiverse.anchors.x[video.anchor.x_alignment] + (video.anchor.x_offset or 0) * x_factor,
				Multiverse.anchors.y[video.anchor.y_alignment] + (video.anchor.y_offset or 0) * y_factor,
				video.rotation,
				video.x_scale * x_factor,
				video.y_scale * y_factor,
				Multiverse.base_offsets.x[video.anchor.x_alignment](video),
				Multiverse.base_offsets.y[video.anchor.y_alignment](video),
				0,
				0
			)
		end
	end
end

function Multiverse.update_animations()
	Multiverse.anchors = {
		x = {
			l = 0,
			c = love.graphics.getWidth() / 2,
			r = love.graphics.getWidth(),
		},
		y = {
			t = 0,
			c = love.graphics.getHeight() / 2,
			b = love.graphics.getHeight(),
		},
	}
	for key, anim in pairs(Multiverse.all_animations) do
		if anim.is_active then
			if anim.is_continuous then
				anim.progress = anim.progress + G.real_dt * #anim.frames / anim.duration
				if anim.progress >= #anim.frames then
					anim.progress = anim.progress - #anim.frames
				end
			else
				if anim.progress < #anim.frames then
					anim.progress = anim.progress + G.real_dt * #anim.frames / anim.duration
				else
					anim.is_active = false
				end
			end
		end
	end
end

function Multiverse.get_screen_x_scale()
	return love.graphics.getWidth() / 1536
end

function Multiverse.get_screen_y_scale()
	return love.graphics.getHeight() / 864
end

function Multiverse.get_screen_scale()
	return Multiverse.get_screen_x_scale(), Multiverse.get_screen_y_scale()
end
