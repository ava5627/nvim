local layout_config = {
    preview_cutoff = 1, -- Preview should always show (unless previewer = false)
    prompt_position = "top",
    width = function(_, max_columns, _)
        return math.min(max_columns, 80)
    end,

    height = function(_, _, max_lines)
        return math.min(max_lines, 15)
    end,
}

return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
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
                            ["<C-S-j>"] = function(b) require("telescope.actions.set").shift_selection(b, 10) end,
                            ["<C-S-k>"] = function(b) require("telescope.actions.set").shift_selection(b, -10) end,
                            ["<A-j>"] = function(b) require("telescope.actions.set").shift_selection(b, 10) end,
                            ["<A-k>"] = function(b) require("telescope.actions.set").shift_selection(b, -10) end,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        }
                    },
                },
                pickers = {
                    find_files = {
                        previewer = false,
                        sorting_strategy = "ascending",
                        layout_config = layout_config,
                    },
                    buffers = {
                        previewer = false,
                        sorting_strategy = "ascending",
                        layout_config = layout_config,
                    },
                },
                extensions = {
                    harpoon = {
                        initial_mode = "insert",
                        layout_config = layout_config,
                    }
                },
            }
        end,
        keys = {
            { "<leader>oo", "<cmd>Telescope find_files<cr>",           desc = "Find files" },
            { "<leader>og", "<cmd>Telescope live_grep<cr>",            desc = "Grep" },
            { "<leader>os", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
            { "<leader>op", "<cmd>Telescope project project<cr>",      desc = "Projects" },
            { "<leader>oi", "<cmd>Telescope buffers<cr>",              desc = "Buffers" },
        }
    },
    {
        "ThePrimeagen/harpoon",
        dependencies = "nvim-telescope/telescope.nvim",
        config = function()
            require("telescope").load_extension("harpoon")
        end,
        keys = function()
            local telescope_harpoon = require("telescope").extensions.harpoon.marks
            return {
                {
                    "<leader>h",
                    function()
                        telescope_harpoon(require("telescope.themes").get_dropdown {
                            previewer = false, initial_mode = "normal", prompt_title = "Harpoon"
                        })
                    end,
                    desc = "Harpoon marks"
                },
                { "mm",    require("harpoon.mark").add_file,                 desc = "Add file to harpoon" },
                { "<A-1>", function() require("harpoon.ui").nav_file(1) end, desc = "Open harpoon 1" },
                { "<A-2>", function() require("harpoon.ui").nav_file(2) end, desc = "Open harpoon 2" },
                { "<A-3>", function() require("harpoon.ui").nav_file(3) end, desc = "Open harpoon 3" },
                { "<A-4>", function() require("harpoon.ui").nav_file(4) end, desc = "Open harpoon 4" },
            }
        end
    },
}
