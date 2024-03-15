return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "night",
        on_colors = function(colors)
            colors.git.add = colors.hint
            colors.gitSigns.add = colors.hint
            colors.git.change = colors.blue
            colors.gitSigns.change = colors.blue
        end,
        on_highlights = function(highlights, colors)
            highlights.DiagnosticUnnecessary = { fg = colors.fg_dark, undercurl = true, sp = colors.warning }
        end
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd("colorscheme tokyonight")
    end,
}
