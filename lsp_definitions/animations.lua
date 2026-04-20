---@meta

---@class Anchor
---@field x_alignment "l" | "c" | "r"
---@field y_alignment "b" | "c" | "t"
---@field x_offset number?
---@field y_offset number?

---@class Multiverse.Animation
---@field path string The name of the file where the animation is stored
---@field frames integer The number of frames the animation has
---@field columns integer? The number of columns the spritesheet has. Do not include if the spritesheet is all in one row.
---@field px integer The width of an individual frame of the animation
---@field py integer The height of an individual frame of the animation
---@field key string The key of the animation
---@field is_continuous boolean? Whether or not this animation is supposed to run continuously
---@field anchor Anchor The place on the screen where the animation is
---@field duration number The amount of time that one animation loop will take
---@field x_scale number? The factor that the animation will be scaled horizontally
---@field y_scale number? The factor that the animation will be scaled vertically
---@field rotation number? The rotation of the animation in radians
---@field absolute boolean? 

---@class Multiverse.AnimationData
---@field frames love.Quad[] The quadrants of the file that each represent a single frame
---@field image love.Image The image where all the quadrants are derived from
---@field is_active boolean Whether or not the animation is displayed on screen
---@field progress number Represents the completion progress of the animation
---@field px integer The width of an individual frame of the animation
---@field py integer The height of an individual frame of the animation
---@field is_continuous boolean? Whether or not this animation is supposed to run continuously
---@field anchor Anchor The place on the screen where the animation is
---@field duration number The amount of time that one animation loop will take
---@field x_scale number? The factor that the animation will be scaled horizontally
---@field y_scale number? The factor that the animation will be scaled vertically
---@field rotation number? The rotation of the animation in radians
---@field forced_anchor Anchor?

---@class Multiverse.Video
---@field path string The name of the file where the video is stored
---@field key string The key of the video.
---@field anchor Anchor The place on the screen where the video is
---@field x_scale number? The factor that the video will be scaled horizontally
---@field y_scale number? The factor that the video will be scaled vertically
---@field rotation number? The rotation of the video in radians
---@field volume number? The volume of the video

---@class Multiverse.VideoData
---@field video love.Video The video to be displayed
---@field anchor Anchor The place on the screen where the video is
---@field x_scale number? The factor that the video will be scaled horizontally
---@field y_scale number? The factor that the video will be scaled vertically
---@field rotation number? The rotation of the video in radians
---@field px integer The width of an individual frame of the video
---@field py integer The height of an individual frame of the video
---@field is_visible boolean Whether or not the video is visible on screen

