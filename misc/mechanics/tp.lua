function Multiverse.show_TP_meter()
	if G.mul_tp_meter then
		G.mul_tp_meter:remove()
		G.mul_tp_meter = nil
	end
	G.mul_tp_meter = UIBox({
		definition = Multiverse.create_TP_ui(),
		config = { align = "tm", offset = { x = 3, y = -0.5 }, major = G.deck, instance_type = "CARD" },
	})
	G.E_MANAGER:add_event(Event({
		trigger = "ease",
		ref_table = G.mul_tp_meter.config.offset,
		ref_value = "x",
		ease_to = G.mul_tp_meter.config.offset.x - 3,
		timer = "REAL",
		blockable = false,
		blocking = false,
		delay = 0.125,
		ease = "inquad",
	}))
end

function Multiverse.hide_TP_meter()
	if G.mul_tp_meter then
		local final_x = G.mul_tp_meter.config.offset.x + 3
		G.E_MANAGER:add_event(Event({
			trigger = "ease",
			ref_table = G.mul_tp_meter.config.offset,
			ref_value = "x",
			ease_to = G.mul_tp_meter.config.offset.x + 3,
			timer = "REAL",
			blockable = false,
			blocking = false,
			delay = 0.125,
			ease = "outquad",
			func = function(n)
				if n == final_x and G.mul_tp_meter then
					G.mul_tp_meter:remove()
					G.mul_tp_meter = nil
				end
				return n
			end,
		}))
	end
end

Wallet.Currency({
	key = "tp",
	colour = G.C.FILTER,
	currency_prefix = "",
	currency_suffix = "% TP",
	no_ui = true,
	custom_ease_func = function(self, mod)
		G.GAME._gradual_TP_amt = G.GAME.mul_tp
		G.GAME.mul_tp = G.GAME.mul_tp + mod
		G.E_MANAGER:add_event(Event({
			trigger = "ease",
			ref_table = G.GAME,
			ref_value = "_gradual_TP_amt",
			delay = 0.7 + G.SPEEDFACTOR * 0.1,
			ease_to = G.GAME._gradual_TP_amt + mod,
			blockable = false,
			blocking = false,
			func = function(n)
				return math.floor(n)
			end,
		}))
	end,
	pre_ease_func = function(self, mod, instant)
		local amt = mod
		if next(SMODS.find_card("j_mul_thunderedge")) and amt < 0 then
			amt = math.floor(amt / (2 ^ #SMODS.find_card("j_mul_thunderedge")))
		end
		local curr_tp = G.GAME.mul_tp + G.GAME.mul_tp_buffer
		local actual_change = Multiverse.clamp(amt, -curr_tp, 100 - curr_tp)
		if
			Multiverse.has_deck_enchantment("de_mul_drain")
			and Multiverse.context_flags.from_scored_hand
			and actual_change > 0
		then
			ease_mul_thaumaturgy_energy(actual_change, instant)
			return 0
		end
		return actual_change
	end,
	post_ease_func = function(self, mod)
		SMODS.calculate_context({
			mul_tp_altered = true,
			amount = mod,
			mul_from_hand = Multiverse.context_flags.from_scored_hand,
			mul_from_skill = Multiverse.context_flags.from_skill,
		})
	end,
})

function Multiverse.init_TP()
	---@type number
	G.GAME._gradual_TP_amt = G.GAME._gradual_TP_amt or 0
	---@type integer
	G.GAME.mul_tp_max_gain = G.GAME.mul_tp_max_gain or 5
	---@type integer
	G.GAME.mul_tp_min_gain = G.GAME.mul_tp_min_gain or 2
end

function Multiverse.create_TP_ui()
	local display = {
		n = G.UIT.R,
		config = { padding = 0.05, align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = { padding = 0.05, align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = DynaText({
										string = { localize("k_mul_tp") },
										colours = { G.C.UI.TEXT_LIGHT },
										shadow = true,
										scale = 0.35,
									}),
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { colour = G.C.DYN_UI.BOSS_DARK, padding = 0.05, align = "cm", minw = 0.75, r = 0.05 },
						nodes = {
							{
								n = G.UIT.C,
								config = { padding = 0.01, align = "cm" },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.O,
												config = {
													object = DynaText({
														string = {
															{ ref_table = G.GAME, ref_value = "_gradual_TP_amt" },
														},
														colours = { G.C.IMPORTANT },
														scale = 0.35,
														shadow = true,
														bump = true,
													}),
													id = "TP_display",
													align = "cm",
												},
											},
										},
									},
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.O,
												config = {
													object = DynaText({
														string = { "%" },
														colours = { G.C.IMPORTANT },
														scale = 0.35,
														shadow = true,
													}),
													align = "cm",
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					r = 0.1,
					colour = lighten(G.C.JOKER_GREY, 0.5),
					padding = 0.05,
					detailed_tooltip = Multiverse.DummyCenters["du_mul_tp_info"],
					detailed_tooltip_align = "cl",
					detailed_tooltip_offset = { x = -0.1, y = 0 },
				},
				nodes = {
					{
						n = G.UIT.C,
						config = {
							align = "cm",
							r = 0.1,
							colour = G.C.DYN_UI.BOSS_MAIN,
							emboss = 0.05,
							padding = 0.01,
						},
						nodes = {
							display,
							{
								n = G.UIT.R,
								config = { align = "cm", minh = 3.6 },
								nodes = {
									{
										n = G.UIT.C,
										config = {
											align = "cm",
											mul_custom_draw_func = function(self)
												local t = self.VT or self.T
												local offset = 0.175
												local bg_verts = {
													0,
													offset * G.TILESIZE,
													t.w * G.TILESIZE,
													0,
													t.w * G.TILESIZE,
													(t.h - offset) * G.TILESIZE,
													0,
													t.h * G.TILESIZE,
												}
												love.graphics.setColor(G.C.DYN_UI.BOSS_DARK)
												love.graphics.polygon("fill", bg_verts)
												local line_h = 0.1
												local t1 = math.max(G.GAME._gradual_TP_amt, G.GAME.mul_tp)
												local tp_bg_verts = {
													0,
													offset * G.TILESIZE
														+ (100 - t1) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE,
													(100 - t1) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE,
													(t.h - offset) * G.TILESIZE,
													0,
													t.h * G.TILESIZE,
												}
												love.graphics.setColor(lighten(G.C.FILTER, 0.4))
												love.graphics.polygon("fill", tp_bg_verts)
												local t2 = math.min(G.GAME._gradual_TP_amt, G.GAME.mul_tp)
												local tp_main_verts = {
													0,
													line_h * G.TILESIZE
														+ offset * G.TILESIZE
														+ (100 - t2) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE,
													line_h * G.TILESIZE
														+ (100 - t2) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE,
													(t.h - offset) * G.TILESIZE,
													0,
													t.h * G.TILESIZE,
												}
												love.graphics.setColor(G.C.FILTER)
												love.graphics.polygon("fill", tp_main_verts)
											end,
											minw = 0.55,
											minh = 3.5,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm" },
								nodes = {
									{
										n = G.UIT.B,
										config = { h = 0.05, w = 0.05 },
									},
								},
							},
						},
					},
				},
			},
		},
	}
end
