SMODS.NFS.createDirectory("video_cache")

---@type table<string, Multiverse.Animation>
Multiverse.Animations = {}

---Registers an animation to a global table.
---@param t Multiverse.Animation
---@return Multiverse.Animation
function Multiverse.Animation(t)
	local full_key = SMODS.current_mod.prefix .. t.key
	if Multiverse.Animations[full_key] then
		error("Attempt to define a duplicate animation")
	end
	local file_data =
		assert(SMODS.NFS.newFileData(Multiverse.path .. "assets/animations/" .. t.path), "Failed to get file data")
	local image_data = assert(love.image.newImageData(file_data), "Failed to convert to image data")
	local love_image = assert(love.graphics.newImage(image_data), "Failed to create an image")
	---@type Multiverse.Animation
	local anim_data = {
		frames = t.frames,
		image = love_image,
		is_continuous = t.is_continuous or false,
		x_scale = t.x_scale or 1,
		y_scale = t.y_scale or 1,
		rotation = t.rotation or 0,
		px = t.px,
		py = t.py,
		duration = t.duration,
		frame_data = {},
		no_stretch = t.no_stretch,
		anchor = t.anchor,
	}
	for i = 1, t.frames do
		local x, y = (i - 1) % (t.columns or i), (t.columns and math.floor((i - 1) / t.columns) or 0)
		anim_data.frame_data[#anim_data.frame_data + 1] =
			love.graphics.newQuad(x * t.px, y * t.py, t.px, t.py, love_image)
	end
	Multiverse.Animations = Multiverse.Animations or {}
	Multiverse.Animations[full_key] = anim_data
	return anim_data
end

---@type table<string, Multiverse.Video>
Multiverse.Videos = {}

---Registers a video to a global table.
---@param t Multiverse.Video
---@return Multiverse.Video
function Multiverse.Video(t)
	local full_key = SMODS.current_mod.prefix .. "_" .. t.key
	if Multiverse.Videos[full_key] then
		error("Attempt to define a duplicate video")
	end
	local path = Multiverse.path .. "assets/videos/" .. t.path
	local f = SMODS.NFS.read(path)
	local cached_path = "video_cache/mul_" .. full_key .. ".ogv"
	if not love.filesystem.getInfo(cached_path) then
		love.filesystem.write(cached_path, f)
	end
	local love_video = love.graphics.newVideo(cached_path)
	if love_video:getSource() then
		love_video:getSource():setVolume(G.SETTINGS.SOUND.volume * G.SETTINGS.SOUND.game_sounds_volume / 1000)
	end
	---@type Multiverse.Video
	local v_data = {
		video = love_video,
		anchor = t.anchor,
		x_scale = t.x_scale or 1,
		y_scale = t.y_scale or 1,
		rotation = t.rotation or 0,
		px = love_video:getWidth(),
		py = love_video:getHeight(),
	}
	Multiverse.Videos = Multiverse.Videos or {}
	Multiverse.Videos[full_key] = v_data
	return v_data
end

---@type Multiverse.Drawable[]
Multiverse.drawables = {}
Multiverse.drawable_cache = {}

---@param key string
---@param args? {anchor?: Anchor}
function Multiverse.play_animation(key, args)
	args = args or {}
	Multiverse.drawables[#Multiverse.drawables + 1] = {
		key = key,
		anchor = SMODS.merge_defaults(args.anchor, Multiverse.Animations[key].anchor or {}),
		_progress = 0,
		update = function(self)
			if self.ref_obj.is_continuous then
				self._progress = self._progress + G.real_dt * self.ref_obj.frames / self.ref_obj.duration
				if self._progress >= self.ref_obj.frames then
					self._progress = self._progress - self.ref_obj.frames
				end
			else
				if self._progress < self.ref_obj.frames then
					self._progress = self._progress + G.real_dt * self.ref_obj.frames / self.ref_obj.duration
				else
					self._removed = true
					Multiverse.drawable_cache["a_" .. key] = Multiverse.drawable_cache["a_" .. key] - 1
				end
			end
		end,
		ref_obj = Multiverse.Animations[key],
		drawable = Multiverse.Animations[key].image,
	}
	Multiverse.drawable_cache["a_" .. key] = (Multiverse.drawable_cache["a_" .. key] or 0) + 1
end

function Multiverse.is_animation_playing(key)
	return Multiverse.Animations[key] and (Multiverse.drawable_cache["a_" .. key] or 0) > 0
end

function Multiverse.stop_animation(key)
	for _, drawable in ipairs(Multiverse.drawables) do
		if drawable.key == key and drawable._paused == nil then
			drawable._removed = true
			Multiverse.drawable_cache["a_" .. key] = Multiverse.drawable_cache["a_" .. key] - 1
		end
	end
end

---@param key string
---@param args? {anchor?: Anchor}
function Multiverse.play_video(key, args)
	args = args or {}
	if Multiverse.is_video_playing(key) then
		error("No")
	end
	Multiverse.drawables[#Multiverse.drawables + 1] = {
		key = key,
		anchor = SMODS.merge_defaults(args.anchor, Multiverse.Videos[key].anchor or {}),
		update = function(self)
			if not self.drawable:isPlaying() and not self._paused then
				self._removed = true
				self.drawable:pause()
				Multiverse.drawable_cache["v_" .. key] = Multiverse.drawable_cache["v_" .. key] - 1
			end
		end,
		ref_obj = Multiverse.Videos[key],
		drawable = Multiverse.Videos[key].video,
		_paused = false,
	}
	Multiverse.Videos[key].video:rewind()
	Multiverse.Videos[key].video:play()
	Multiverse.drawable_cache["v_" .. key] = (Multiverse.drawable_cache["v_" .. key] or 0) + 1
end

function Multiverse.is_video_playing(key)
	return Multiverse.Videos[key] and (Multiverse.drawable_cache["v_" .. key] or 0) > 0
end

function Multiverse.pause_video(key)
	for _, drawable in ipairs(Multiverse.drawables) do
		if drawable.key == key and drawable._paused == false then
			drawable._paused = true
			drawable.drawable:pause()
		end
	end
end

function Multiverse.resume_video(key)
	for _, drawable in ipairs(Multiverse.drawables) do
		if drawable.key == key and drawable._paused == true then
			drawable._paused = false
			drawable.drawable:play()
		end
	end
end

function Multiverse.handle_other_drawing()
	for _, drawable in ipairs(Multiverse.drawables) do
		if not drawable._removed then
			love.graphics.setColor(1, 1, 1, 1)
			if drawable.ref_obj.frame_data then
				love.graphics.draw(
					drawable.drawable,
					drawable.ref_obj.frame_data[Multiverse.clamp(
						math.floor(drawable._progress) + 1,
						1,
						drawable.ref_obj.frames
					)],
					Multiverse.get_transform(drawable)
				)
			else
				love.graphics.draw(drawable.drawable, Multiverse.get_transform(drawable))
			end
		end
	end
end

function Multiverse.update_drawables()
	local new_drawables = {}
	for _, drawable in ipairs(Multiverse.drawables) do
		drawable:update()
		if not drawable._removed then
			new_drawables[#new_drawables+1] = drawable
		end
	end
	Multiverse.drawables = new_drawables
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

Multiverse.x_offsets = {
	l = function(x)
		return x / 2
	end,
	c = function(x)
		return 0
	end,
	r = function(x)
		return -x / 2
	end,
}

Multiverse.y_offsets = {
	t = function(x)
		return -x / 2
	end,
	c = function(x)
		return 0
	end,
	b = function(x)
		return x / 2
	end,
}

---@param drawable Multiverse.Drawable
---@return love.Transform
function Multiverse.get_transform(drawable)
	local target = drawable.anchor.target
	local temp = target and Multiverse.get_true_coords(target)
		or { love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 }
	local x = temp[1]
	local y = temp[2]
	x = x + (drawable.anchor.x_offset or 0)
	y = y + (drawable.anchor.y_offset or 0)
	local x_scale = (drawable.anchor.x_scale or 1)
		* (drawable.ref_obj.no_stretch and 1 or Multiverse.get_screen_x_scale())
	local y_scale = (drawable.anchor.y_scale or 1)
		* (drawable.ref_obj.no_stretch and 1 or Multiverse.get_screen_y_scale())
	local x_align = drawable.anchor.x_alignment or "c"
	local y_align = drawable.anchor.y_alignment or "c"
	x = x
		+ Multiverse.x_offsets[x_align](
			target and Multiverse.to_pixels((target.VT or target.T).w) or love.graphics.getWidth()
		)
	y = y
		+ Multiverse.y_offsets[y_align](
			target and Multiverse.to_pixels((target.VT or target.T).h) or love.graphics.getHeight()
		)
	if drawable.anchor.inner_align then
		x = x - Multiverse.x_offsets[x_align](drawable.ref_obj.py * x_scale)
		y = y - Multiverse.y_offsets[y_align](drawable.ref_obj.py * y_scale)
	end
	return love.math.newTransform(
		x,
		y,
		drawable.anchor.rotation,
		x_scale,
		y_scale,
		drawable.ref_obj.px / 2,
		drawable.ref_obj.py / 2
	)
end
