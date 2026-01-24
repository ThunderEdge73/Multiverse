SMODS.Seal({
	key = "frozen",
	atlas = "modifiers_placeholder",
	pos = { x = 1, y = 0 },
	badge_colour = HEX("86DAF9"),
	config = { extra = { xmult = 2.5, xmult_dec = 0.05 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.seal.extra.xmult, card.ability.seal.extra.xmult_dec } }
	end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			return {
				xmult = math.max(card.ability.seal.extra.xmult, 1),
				func = function()
					if card.seal == "mul_frozen" and card.ability.seal.extra.xmult > 1 then
						SMODS.scale_card(card, {
							ref_table = card.ability.seal.extra,
							ref_value = "xmult",
							scalar_value = "xmult_dec",
							operation = "-",
							message_key = "a_xmult_minus",
						})
					end
					if card.ability.seal.extra.xmult <= 1 and not card.mul_melted then
                        card.mul_melted = true
						G.E_MANAGER:add_event(Event({
							func = function()
								card:set_seal(nil)
                                card.mul_melted = nil
								return true
							end,
						}))
						SMODS.calculate_effect({
							message = localize("k_melted_ex"),
						}, card)
					end
				end,
			}
		end
	end,
})
