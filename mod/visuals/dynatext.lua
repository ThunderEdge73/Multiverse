SMODS.DynaTextEffect({
    key = "rotate",
    func = function(dynatext, index, letter)
        letter.r = G.TIMERS.REAL / 1.2
        letter.scale = 1.05
        letter.offset = { x = -20, y = 10 }
        letter.dims.y = letter.dims.x
    end,
})

SMODS.DynaTextEffect({
    key = "ui_multiverse_highlight",
    func = function(dynatext, index, letter)
        local fac = math.pow(math.cos(math.pi * ((G.TIMERS.REAL - dynatext.created_time + 0.3) * 1.8 - index) / 10), 50)
        letter.colour = mix_colours(Multiverse.C.TRANSMUTED_GRADIENT, G.C.UI.TEXT_LIGHT, fac)
        letter.offset.y = 30 * fac
    end,
})