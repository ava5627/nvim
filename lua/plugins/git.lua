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
                { "]c",         nav_hunk("next"), desc = "Next hunk" },
                { "[c",         nav_hunk("prev"), desc = "Previous hunk" },
                { "<leader>gb", gitsigns.blame,   desc = "Git blame" },
            }
        end
    },
    {

        "sindrets/diffview.nvim",
        lazy = false,
        opts = function()
            local actions = require("diffview.actions")
            local quit = { "n", "q", actions.close, { desc = "close diffview" } }

            return {
                view = {
                    merge_tool = {
                        layout = "diff3_mixed"
                    }
                },
                keymaps = {
                    view = { quit },
                    file_panel = { quit },
                    file_history_panel = { quit },
                    diff3 = {
                        -- Mappings in 3-way diff layouts
                        { { "n", "x" }, "dh", actions.diffget("ours"),               { desc = "Obtain the diff hunk from the OURS version of the file" } },
                        { { "n", "x" }, "dl", actions.diffget("theirs"),             { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
                        { { "n", "x" }, "dH", actions.conflict_choose_all("ours"),   { desc = "Choose the OURS version of a conflict for the whole file" } },
                        { { "n", "x" }, "dL", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
                    },
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
}
