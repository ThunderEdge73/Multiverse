function Multiverse.show_TP_meter()
	if G.mul_TP_meter then
		G.mul_TP_meter:remove()
		G.mul_TP_meter = nil
	end
	G.mul_TP_meter = UIBox({
		definition = Multiverse.create_TP_ui(),
		config = { align = "tm", offset = { x = 3, y = -0.5 }, major = G.deck, instance_type = "CARD" },
	})
	G.E_MANAGER:add_event(Event({
		trigger = "ease",
		ref_table = G.mul_TP_meter.config.offset,
		ref_value = "x",
		ease_to = G.mul_TP_meter.config.offset.x - 3,
		timer = "REAL",
		blockable = false,
		blocking = false,
		delay = 0.125,
		ease = "inquad",
	}))
	G.mul_TP_meter:recalculate()
end

function Multiverse.hide_TP_meter()
	if G.mul_TP_meter then
		local final_x = G.mul_TP_meter.config.offset.x + 3
		G.E_MANAGER:add_event(Event({
			trigger = "ease",
			ref_table = G.mul_TP_meter.config.offset,
			ref_value = "x",
			ease_to = G.mul_TP_meter.config.offset.x + 3,
			timer = "REAL",
			blockable = false,
			blocking = false,
			delay = 0.125,
			ease = "outquad",
			func = function(n)
				if n == final_x and G.mul_TP_meter then
					G.mul_TP_meter:remove()
					G.mul_TP_meter = nil
				end
				return n
			end,
		}))
	end
end

function Multiverse.init_TP()
	---@type integer
	G.GAME.mul_TP = G.GAME.mul_TP or 0
	G.GAME._gradual_TP_amt = G.GAME.mul_TP
	---@type integer
	G.GAME.mul_TP_max_gain = G.GAME.mul_TP_max_gain or 5
	---@type integer
	G.GAME.mul_TP_min_gain = G.GAME.mul_TP_min_gain or 2
end

---Changes the current amount of TP, and also triggers the relevant context.
---This function will automatically adjust the amount of TP earned/lost if doing the modification would cause TP to be negative or more than 100.
---@param amt integer
---@param args {from_hand: boolean?, immediate: boolean?, from_skill: boolean?}
function Multiverse.ease_TP(amt, args)
	if next(SMODS.find_card("j_mul_thunderedge")) and amt < 0 then
		amt = math.floor(amt / (2 ^ #SMODS.find_card("j_mul_thunderedge")))
	end
	local actual_change = Multiverse.clamp(amt, -G.GAME.mul_TP, 100 - G.GAME.mul_TP)
	args = args or {}
	if Multiverse.has_deck_enchantment("de_mul_drain") and args.from_hand and actual_change > 0 then
		Multiverse.ease_thaumaturgy_energy(actual_change, { immediate = args.immediate, silent = true })
		return
	end
	SMODS.calculate_context({
		--True if the amount of TP was changed.
		mul_TP_altered = true,
		amount = actual_change,
		--True if the change in TP came from a played hand.
		mul_from_hand = args.from_scored_hand,
		mul_from_skill = args.from_skill,
	})
	if args.immediate then
		G.GAME.mul_TP = G.GAME.mul_TP + actual_change
		G.GAME._gradual_TP_amt = G.GAME.mul_TP
	else
		G.GAME._gradual_TP_amt = G.GAME.mul_TP
		G.GAME.mul_TP = G.GAME.mul_TP + actual_change
		G.E_MANAGER:add_event(Event({
			trigger = "ease",
			ref_table = G.GAME,
			ref_value = "_gradual_TP_amt",
			blockable = false,
			delay = 1,
			ease_to = G.GAME._gradual_TP_amt + actual_change,
			func = function(n)
				return math.floor(n)
			end,
		}))
	end
end

function Multiverse.create_TP_ui()
	local col = {}
	for _ = 1, 50 do
		col[#col + 1] = {
			n = G.UIT.R,
			config = {
				align = "cm",
				minw = 0.85,
			},
			nodes = {
				{
					n = G.UIT.B,
					config = {
						colour = G.C.DYN_UI.BOSS_DARK,
						w = 0.5,
						h = 0.06,
					},
				},
			},
		}
	end
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
										string = { localize("k_mul_TP") },
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
											--func = "mul_update_TP_bar",
											mul_custom_draw_func = function(self)
												local t = self.VT or self.T
												local offset = 0.175
												local bg_verts = {
													0, offset * G.TILESIZE,
													t.w * G.TILESIZE, 0,
													t.w * G.TILESIZE, (t.h - offset) * G.TILESIZE,
													0, t.h * G.TILESIZE
												}
												love.graphics.setColor(G.C.DYN_UI.BOSS_DARK)
												love.graphics.polygon("fill", bg_verts)
												local line_h = 0.1
												local t1 = math.max(G.GAME._gradual_TP_amt, G.GAME.mul_TP)
												local tp_bg_verts = {
													0, offset * G.TILESIZE + (100 - t1) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE, (100 - t1) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE, (t.h - offset) * G.TILESIZE,
													0, t.h * G.TILESIZE
												}
												love.graphics.setColor(lighten(G.C.FILTER, 0.4))
												love.graphics.polygon("fill", tp_bg_verts)
												local t2 = math.min(G.GAME._gradual_TP_amt, G.GAME.mul_TP)
												local tp_main_verts = {
													0, line_h * G.TILESIZE + offset * G.TILESIZE + (100 - t2) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE, line_h * G.TILESIZE + (100 - t2) / 100 * (t.h - offset - line_h) * G.TILESIZE,
													t.w * G.TILESIZE, (t.h - offset) * G.TILESIZE,
													0, t.h * G.TILESIZE
												}
												love.graphics.setColor(G.C.FILTER)
												love.graphics.polygon("fill", tp_main_verts)
											end,
											minw = 0.6,
											minh = 3.5,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = {},
								nodes = {
									{
										n = G.UIT.C,
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
			},
		},
	}
end

function G.FUNCS.mul_update_TP_bar(e)
	if e.children then
		for i = #e.children, 1, -1 do
			local rev_index = #e.children - i + 1
			local grad_TP_index = math.ceil(G.GAME._gradual_TP_amt * #e.children / 100)
			local final_TP_index = math.ceil(G.GAME.mul_TP * #e.children / 100)
			local col = G.C.DYN_UI.BOSS_DARK
			if rev_index <= math.max(final_TP_index, grad_TP_index) then
				col = G.C.FILTER
				if rev_index >= math.min(final_TP_index, grad_TP_index) then
					col = lighten(col, 0.4)
				end
			end
			e.children[i].children[1].config.colour = col
		end
	end
end
