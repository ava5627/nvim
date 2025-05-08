---@module "tokyonight"
---@module "catppuccin"
---@alias Colorscheme
---| '"Tokyo Night"'
---| '"Catppuccin"'

---@type Colorscheme
local colorscheme = os.getenv("COLORSCHEME") or "Tokyo Night"

---@type LazyPluginSpec[]
return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        ---@type tokyonight.Config
        opts = {
            style = "night",
            on_colors = function(colors)
                colors.git.add = colors.hint
                colors.git.change = colors.blue
            end,
            on_highlights = function(highlights, colors)
                highlights.DiagnosticUnnecessary = { undercurl = true, sp = colors.warning }
                highlights["@keyword.import"] = highlights["@keyword"]
            end,
            transparent = true,
            terminal_colors = false,
        },
        init = function()
            if colorscheme == "Tokyo Night" then
                vim.cmd.colorscheme("tokyonight")
            end
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        ---@type CatppuccinOptions
        opts = {
            custom_highlights = function(colors)
                return {
                    DiagnosticUnnecessary = { undercurl = true, sp = colors.yellow },
                    GitSignsChange = { fg = colors.blue },
                    NvimTreeGitNew = { fg = colors.green },
                    NvimTreeGitDirty = { fg = colors.blue },
                }
            end,
            integrations = {
                diffview = true,
                fidget = true,
                harpoon = true,
                mason = true,
                neotest = true,
                notify = true,
                which_key = true,
                nvimtree = true,
            }
        },
        init = function()
            if colorscheme == "Catppuccin" then
                vim.cmd.colorscheme("catppuccin")
            end
        end,
    },
}
