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
        keys = function()
            local gitsigns = require("gitsigns")
            local function nav_hunk(direction)
                local key = direction == "next" and "]c" or "[c"
                return function()
                    if vim.wo.diff then
                        vim.cmd.normal({ key, bang = true })
                    else
                        gitsigns.nav_hunk(direction)
                    end
                end
            end
            ---@type LazyKeysSpec[]
            return {
                { "]c", nav_hunk("next"), desc = "Next hunk" },
                { "[c", nav_hunk("prev"), desc = "Previous hunk" }
            }
        end
    },
    {

        "sindrets/diffview.nvim",
        lazy = false,
        opts = function()
            local quit = {
                { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "close diffview" } }
            }
            return {
                view = {
                    merge_tool = {
                        layout = "diff3_mixed"
                    }
                },
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
        ---@type NeogitConfig
        opts = {
            commit_editor = {
                kind = "vsplit",
            },
            graph_style = "kitty",
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
