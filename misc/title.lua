-- Do main menu stuff here
-- Yoinked from Maximus (Thanks Astra)
local main_menu_hook = Game.main_menu
function Game:main_menu(change_context, ...)
	local ret = main_menu_hook(self, change_context, ...)
	G.SPLASH_MULTIVERSE_LOGO = Sprite(
		0,
		0,
		6,
		6 * G.ASSET_ATLAS["mul_mod_logo"].py / G.ASSET_ATLAS["mul_mod_logo"].px,
		G.ASSET_ATLAS["mul_mod_logo"],
		{ x = 0, y = 0 }
	)
	G.SPLASH_MULTIVERSE_LOGO:set_alignment({
		major = G.title_top,
		type = "cm",
		bond = "Strong",
		offset = { x = 0, y = 3.75 },
	})
	G.SPLASH_MULTIVERSE_LOGO:define_draw_steps({ {
		shader = "dissolve",
	} })
	G.SPLASH_MULTIVERSE_LOGO.tilt_var = { mx = 0, my = 0, dx = 0, dy = 0, amt = 0 }
	G.SPLASH_MULTIVERSE_LOGO.states.collide.can = true
	G.SPLASH_MULTIVERSE_LOGO.dissolve = 1
	G.mul_loaded_timer = 0
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = change_context == "splash" and 3.6 or change_context == "game" and 4 or 1,
		blockable = false,
		blocking = false,
		func = function()
			play_sound("whoosh1", 0.2, 0.8)
			ease_value(
				G.SPLASH_MULTIVERSE_LOGO,
				"dissolve",
				-1,
				nil,
				nil,
				nil,
				change_context == "splash" and 2.3 or 0.9
			)
			G.VIBRATION = G.VIBRATION + 1.5
			return true
		end,
	}))
	function G.SPLASH_MULTIVERSE_LOGO:click()
		play_sound("button", 1, 0.3)
		G.FUNCS["openModUI_Multiverse"]()
	end
	function G.SPLASH_MULTIVERSE_LOGO:hover()
		G.SPLASH_MULTIVERSE_LOGO:juice_up(0.1, 0.1)
		Node.hover(self)
	end
	function G.SPLASH_MULTIVERSE_LOGO:stop_hover()
		Node.stop_hover(self)
	end
	return ret
end

function Multiverse.update_main_menu()
	if G.SPLASH_MULTIVERSE_LOGO and G.SPLASH_MULTIVERSE_LOGO.dissolve == 0 then
		G.mul_loaded_timer = (G.mul_loaded_timer or 0)
		if not G.SETTINGS.paused then
			G.mul_loaded_timer = G.mul_loaded_timer + G.real_dt
		end
		G.SPLASH_MULTIVERSE_LOGO:set_alignment({
			major = G.title_top,
			type = "cm",
			bond = "Strong",
			offset = { x = 8 * math.sin(G.mul_loaded_timer * 0.075), y = 3.7 * math.cos(G.mul_loaded_timer * 0.075) },
		})
	end
end

SMODS.Atlas({
	key = "mod_logo",
	px = 575,
	py = 250,
	path = "multiverse_logo.png",
})
-- im a dumbass
