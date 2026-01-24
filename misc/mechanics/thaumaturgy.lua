---Changes the current amount of Thaumaturgy Energy, and also triggers the relevant context.
---@param amt number
---@param args? {immediate: boolean?, silent: boolean?, from_philosophers_stone: boolean?, from_charge: boolean?}
function Multiverse.ease_thaumaturgy_energy(amt, args)
	args = args or {}
	if G.GAME.mul_time_machine_active and amt >= 0 then
		return
	end
	if G.GAME.mul_unicorn_protections >= 1 and amt < 0 then
		G.GAME.mul_unicorn_protections = G.GAME.mul_unicorn_protections - 1
		return
	end
	SMODS.calculate_context({
		--True if the amount of Thaumaturgy Energy was changed.
		mul_thaumaturgy_energy_altered = true,
		amount = amt,
		--True if the change in Thaumaturgy Energy came from the creation of a Philosopher's Stone.
		mul_from_philosophers_stone = args.from_philosophers_stone,
		--True if the change in Thaumaturgy Energy came from the natural end of round bonus.
		mul_from_charge = args.from_charge,
	})
	local function change_thaumaturgy_energy(num)
		num = num or 0
		if num == 0 then
			return
		end
		local thaum_UI = G.hand_text_area.mul_thaumaturgy_energy
		local text = "+"
		local col = Multiverse.C.TRANSMUTED_GRADIENT
		if num < 0 then
			text = "-"
			col = G.C.RED
		end
		G.GAME.mul_thaumaturgy_energy = G.GAME.mul_thaumaturgy_energy + num
		thaum_UI.config.object:update()
		G.HUD:recalculate()
		attention_text({
			text = text .. tostring(math.abs(num)),
			scale = 0.6,
			hold = 0.7,
			cover = thaum_UI.parent,
			cover_colour = col,
			align = "cm",
		})
		if not args.silent then
			play_sound("generic1")
		end
	end
	if args.immediate then
		change_thaumaturgy_energy(amt)
	else
		G.E_MANAGER:add_event(Event({
			func = function()
				change_thaumaturgy_energy(amt)
				return true
			end,
		}))
	end
end

function Multiverse.init_thaumaturgy()
	---@type integer
	G.GAME.mul_thaumaturgy_energy = G.GAME.mul_thaumaturgy_energy or 0
	---@type integer
	G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate or 2
	---@type integer
	G.GAME.mul_thaumaturgy_energy_per_joker = G.GAME.mul_thaumaturgy_energy_per_joker or 10
end

function Multiverse.thaumaturgy_UI_row(temp_col, temp_col2, scale)
	return {
		n = G.UIT.R,
		config = { align = "cm", id = "row_thaumaturgy" },
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "cm",
					padding = 0.05,
					minw = 1.45,
					minh = 0.55,
					colour = temp_col,
					emboss = 0.05,
					r = 0.1,
					detailed_tooltip = { set = "Other", key = "mul_thaumaturgy_desc" },
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.05 },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("k_mul_thaumaturgy_energy") .. ":",
									minh = 0.33,
									scale = 0.85 * scale,
									colour = G.C.UI.TEXT_LIGHT,
									shadow = true,
								},
							},
							{ n = G.UIT.C, config = { minw = 0.05 } },
							{
								n = G.UIT.C,
								config = {
									align = "cm",
									r = 0.1,
									minw = 1.5,
									colour = temp_col2,
									id = "col_thaumaturgy_text",
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = DynaText({
												string = "+",
												colours = { Multiverse.C.TRANSMUTED_GRADIENT },
												shadow = true,
												scale = 1.4 * scale,
												text_effect = "mul_rotate",
												font = SMODS.Fonts["mul_thaum_icon"],
												y_offset = -10,
											}),
										},
									},
									{ n = G.UIT.B, config = { h = 0.08, w = 0.08 } },
									{
										n = G.UIT.O,
										config = {
											object = DynaText({
												string = { { ref_table = G.GAME, ref_value = "mul_thaumaturgy_energy" } },
												colours = { Multiverse.C.TRANSMUTED_GRADIENT },
												shadow = true,
												scale = 1.4 * scale,
											}),
											id = "thaumaturgy_UI_count",
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
