---@type LazyPluginSpec
return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "night",
        on_colors = function(colors)
            colors.git.add = colors.hint
            colors.git.change = colors.blue
        end,
        on_highlights = function(highlights, colors)
            highlights.DiagnosticUnnecessary = { undercurl = true, sp = colors.warning }
        end,
        transparent = true,
        terminal_colors = false,
    },
    init = function()
        vim.cmd.colorscheme("tokyonight")
    end,
}
