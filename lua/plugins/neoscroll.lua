---@type LazyPluginSpec
return {
    "karb94/neoscroll.nvim",
    opts = {
        mappings = { '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = false,      -- Hide cursor while scrolling
        stop_eof = false,         -- Stop at <EOF> when scrolling downwards
        easing_function = 'sine', -- Default easing function
    },
    keys = function()
        local ns = require('neoscroll')
        local modes = { 'n', 'v', 'x' }
        return {
            { "<C-u>", function() ns.ctrl_u({ duration = 200, easing = nil }) end, mode = modes },
            { "<C-d>", function() ns.ctrl_d({ duration = 200, easing = nil }) end, mode = modes },
            { "<C-b>", function() ns.ctrl_b({ duration = 350 }) end,               mode = modes },
            { "<C-f>", function() ns.ctrl_f({ duration = 350 }) end,               mode = modes },
            { "<A-k>", function() ns.scroll(-10, { duration = 50 }) end,           mode = modes },
            { "<A-j>", function() ns.scroll(10, { duration = 50 }) end,            mode = modes },
        }
    end
}
