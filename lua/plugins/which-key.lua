---@module "lazy"
---@module "which-key"
---@type LazyPluginSpec
return {
    "folke/which-key.nvim",
    lazy = false,
    opts = {
        icons = {
            ---@type wk.IconRule[]
            rules = {
                { plugin = "nvim-lspconfig", icon = " ", color = "orange" },
                { plugin = "copilot.lua", icon = " " },
                { plugin = "nvim-dap", pattern = "dap", icon = " ", color = "red" },
                { plugin = "nvim-dap-ui", icon = "󰙵 ", color = "cyan" },
                { plugin = "gitsigns.nvim", cat = "filetype", name = "git" },
                { plugin = "diffview.nvim", cat = "filetype", name = "git" },
                { plugin = "neogit", cat = "filetype", name = "git" },
                { plugin = "blame.nvim", cat = "filetype", name = "git" },
                { plugin = "nvim-tree.lua", icon = "󰉋 " },
                { plugin = "harpoon", icon = "", color = "blue" },
                { plugin = "toggleterm.nvim", icon = " ", color = "blue" },
                { plugin = "ACR.nvim", icon = " ", color = "blue" },
                { plugin = "LuaSnip", icon = " ", color = "cyan" },
                { plugin = "bufdelete.nvim", icon = "󰈆 " },
                { pattern = "lsp", icon = " ", color = "orange" },
                { pattern = "save", icon = " ", color = "azure" },
                { pattern = "close", icon = "󰈆 " },
                { pattern = "todo", cat = "file", name = "TODO" },
                { pattern = "buffer", icon = " ", color = "blue" },
                { pattern = "text-case", icon = " " },
            },
        },
        spec = {
            {
                { "<leader>a", group = "select", icon = " " },
                { "<leader>d", group = "dap" },
                { "<leader>w", group = "window" },
                { "<leader>o", group = "telescope" },
                { "<leader>c", group = "quickfix" },
                { "<leader>g", group = "git" },
                { "<leader>t", group = "git" },
            }
        }
    },
}
