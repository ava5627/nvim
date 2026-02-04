---@module "lazy"

local picker_theme = {
    previewer = false,
    sorting_strategy = "ascending",
    layout_config = {
        preview_cutoff = 1, -- Preview should always show (unless previewer = false)
        prompt_position = "top",
        width = function(_, max_columns, _)
            return math.min(max_columns, 80)
        end,

        height = function(_, _, max_lines)
            return math.min(max_lines, 15)
        end,
    }
}

---@type LazyPluginSpec[]
return {
    {
        "nvim-telescope/telescope.nvim",
        -- branch = "0.1.x",
        lazy = false,
        opts = function()
            local actions = require("telescope.actions")
            return {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                    mappings = {
                        i = {
                            ["<C-esc>"] = actions.close,
                            ["<C-q>"] = actions.close,
                            ["<C-CR>"] = actions.select_default,
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-d>"] = actions.delete_buffer,
                            ["<C-S-j>"] = function(b) require("telescope.actions.set").shift_selection(b, 10) end,
                            ["<C-S-k>"] = function(b) require("telescope.actions.set").shift_selection(b, -10) end,
                            ["<A-j>"] = function(b) require("telescope.actions.set").shift_selection(b, 5) end,
                            ["<A-k>"] = function(b) require("telescope.actions.set").shift_selection(b, -5) end,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        }
                    },
                },
                pickers = {
                    find_files = picker_theme,
                    buffers = picker_theme,
                    git_status = picker_theme,
                },
            }
        end,
        keys = function()
            local telescope = require("telescope.builtin")
            return {
                { "<leader>oo", telescope.find_files,           desc = "Find files" },
                { "<leader>og", telescope.live_grep,            desc = "Grep" },
                { "<leader>os", telescope.lsp_document_symbols, desc = "Document symbols" },
                { "<leader>oi", telescope.buffers,              desc = "Buffers" },
                { "<leader>oc", telescope.git_status,           desc = "Changed Files" },
                { "<leader>od", telescope.diagnostics,          desc = "Go to diagnostics" },
                { "gd",         telescope.lsp_definitions,      desc = "Go to lsp definition" },
                { "gi",         telescope.lsp_implementations,  desc = "Go to lsp implementation" },
                { "grf",        telescope.lsp_references,       desc = "Go to lsp references" },
                { "gt",         telescope.lsp_type_definitions, desc = "Go to lsp type definition" },
            }
        end,
    },
}
