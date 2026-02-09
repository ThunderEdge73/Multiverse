---@param card Card
---@param info_queue table
function Multiverse.transmute_info_queue(card, info_queue)
	if Multiverse.can_receive_transmutable(card) then
		local transmute_vars = {}
		if type(card.ability.extra.transmute_progress) == "table" then
			transmute_vars[#transmute_vars + 1] = card.ability.extra.transmute_progress.n
		else
			transmute_vars[#transmute_vars + 1] = card.ability.extra.transmute_progress
		end
		transmute_vars[#transmute_vars + 1] = card.config.center.transmute_req
		info_queue[#info_queue + 1] = {
			set = "Other",
			key = string.sub(card.config.center.key, 3) .. "_hint",
			vars = transmute_vars,
		}
	end
end

function Multiverse.increment_transmute_progress(card, amt, percent)
	if Multiverse.can_receive_transmutable(card) then
		if not amt then
			amt = math.floor(card.config.center.transmute_req * (percent or 0) / 100)
		end
		if type(card.ability.extra.transmute_progress) == "table" then
			card.ability.extra.transmute_progress.n = card.ability.extra.transmute_progress.n + amt
		else
			card.ability.extra.transmute_progress = card.ability.extra.transmute_progress + amt
		end
		Multiverse.transmute_check(card)
	end
end

function Multiverse.check_philosophers_stone()
	if G.GAME.mul_thaumaturgy_energy >= 100 then
		if #G.consumeables.cards < G.consumeables.config.card_limit then
			Multiverse.ease_thaumaturgy_energy(-G.GAME.mul_thaumaturgy_energy, { from_philosophers_stone = true })
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.add_card({
						key = "c_mul_philosophers_stone",
						key_append = "mul_thaumaturgy_charge",
					})
					return true
				end,
			}))
		else
			delay(2.2 * G.SETTINGS.GAMESPEED)
			attention_text({
				scale = 1.4,
				text = localize("k_no_room_ex"),
				hold = 2 * G.SETTINGS.GAMESPEED,
				align = "cm",
				offset = { x = 0, y = -1.7 },
				major = G.play,
			})
			attention_text({
				scale = 0.7,
				text = localize("k_mul_make_room"),
				hold = 2 * G.SETTINGS.GAMESPEED,
				align = "cm",
				offset = { x = 0, y = -0.5 },
				major = G.play,
			})
			attention_text({
				scale = 0.7,
				text = localize("k_mul_make_room2"),
				hold = 2 * G.SETTINGS.GAMESPEED,
				align = "cm",
				offset = { x = 0, y = 0.3 },
				major = G.play,
			})
		end
	end
end

function Multiverse.set_transmute_requirements(base)
	return Multiverse.config.debug and 1 or base
end

function Multiverse.can_receive_transmutable(card)
	return card
		and card.ability
		and type(card.ability.extra) == "table"
		and card.config.center.transmute_req
		and card.ability.extra.transmute_progress
end

---Will now safely return and do nothing if the card cannot become transmutable
---@param card Card
function Multiverse.transmute_check(card)
	if not Multiverse.can_receive_transmutable(card) then
		return
	end
	local progress = (
		type(card.ability.extra.transmute_progress) == "table" and card.ability.extra.transmute_progress.n
	) or card.ability.extra.transmute_progress
	if progress >= card.config.center.transmute_req and not card.ability.mul_transmutable then
		if not card.children.transmutable_target then
			card.children.transmutable_target = AnimatedSprite(
				card.T.x,
				card.T.y,
				card.T.w,
				card.T.h,
				G.ANIMATION_ATLAS["mul_transmutable_target"],
				{ x = 0, y = 0 }
			)
			card.children.transmutable_target.role.draw_major = card
			card.children.transmutable_target.states.hover.can = false
			card.children.transmutable_target.states.click.can = false
		end
		card:add_sticker("mul_transmutable", true)
	end
end