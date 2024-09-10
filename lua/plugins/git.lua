---@type LazyPluginSpec[]
return {
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
        },
        keys = {
            { "]c", ":Gitsigns next_hunk<CR>", desc = "Next hunk" },
            { "[c", ":Gitsigns prev_hunk<CR>", desc = "Previous hunk" },
        }
    },
    {

        "sindrets/diffview.nvim",
        lazy = false,
        opts = function()
            local quit = {
                { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "close diffview" } }
            }
            return {
                keymaps = {
                    view = quit,
                    file_panel = quit,
                    file_history_panel = quit
                }
            }
        end,
        keys = function()
            local diffview = require("diffview")
            return {
                { "<leader>gd", diffview.open,                                      desc = "open diff" },
                { "<leader>gh", diffview.file_history,                              desc = "open history" },
                { "<leader>gf", function() diffview.file_history(nil, { "%" }) end, desc = "open file history" },
            }
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            commit_editor = {
                kind = "vsplit",
            }
        },
        lazy = false,
        keys = function()
            local neogit = require("neogit")
            return {
                { "<leader>gs", neogit.open, desc = "Git status" },
            }
        end
    },
    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        config = true,
        keys = {
            { "<leader>gb", "<cmd>BlameToggle<CR>",         desc = "Git Blame" },
            { "<leader>gB", "<cmd>BlameToggle virtual<CR>", desc = "Git Blame Virtual Text" }
        }
    },
}
