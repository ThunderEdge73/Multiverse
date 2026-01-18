SMODS.DynaTextEffect({
    key = "rotate",
    func = function(dynatext, index, letter)
        letter.r = G.TIMERS.REAL / 1.2
        letter.scale = 1.05
        letter.offset = { x = -20, y = 10 }
        letter.dims.y = letter.dims.x
    end,
})