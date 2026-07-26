Wallet.Currency({
	key = "thaumaturgy_energy",
	colour = Multiverse.C.TRANSMUTED_GRADIENT,
	font = "mul_m6x11",
	currency_prefix = "*",
	pre_ease_func = function(self, mod)
		local amt = mod
		if amt < 0 and next(SMODS.find_card("j_mul_thunderedge")) then
			amt = math.floor(amt / (2 ^ #SMODS.find_card("j_mul_thunderedge")))
		end
		if G.GAME.mul_time_machine_active and amt >= 0 then
			amt = 0
		end
		if G.GAME.mul_unicorn_protections >= 1 and amt < 0 then
			G.GAME.mul_unicorn_protections = G.GAME.mul_unicorn_protections - 1
			amt = 0
		end
		return amt
	end,
	post_ease_func = function(self, mod)
		SMODS.calculate_context({
			mul_thaumaturgy_energy_altered = true,
			amount = mod,
			mul_from_philosophers_stone = Multiverse.context_flags.from_philosophers_stone,
			mul_from_charge = SMODS.money_from_cashout,
		})
	end,
	cashout_always_number = true,
})

function Multiverse.init_thaumaturgy()
	---@type integer
	G.GAME.mul_thaumaturgy_energy_rate = G.GAME.mul_thaumaturgy_energy_rate or 2
	---@type integer
	G.GAME.mul_thaumaturgy_energy_per_joker = G.GAME.mul_thaumaturgy_energy_per_joker or 10
end
