local home = vim.fn.expand("~")
-- Automatically install lazy.nvim if not found
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.notify("Installing lazy.nvim", vim.log.levels.INFO)
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("Missing lazy.nvim", vim.log.levels.ERROR)
    return
end

-- Install your plugins here
lazy.setup({
    -- Dependencies
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    { "kyazdani42/nvim-web-devicons", config = true },
    { import = "plugins" },
    {
        "zbirenbaum/copilot.lua",
        cond = vim.fn.has("mac") == 0,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-f>",
                    accept_word = "<A-f>",
                    accept_line = "<A-g>",
                    next = "<A-]>",
                    prev = "<A-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                ["*"] = true,
            },
        },
    },
    "f3fora/cmp-spell",
    {
        "windwp/nvim-autopairs",
        opts = {
            check_ts = true,
            fast_wrap = {
                end_key = "g",
                keys = "asdfjkleiwo",
            },
        }
    },
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
            float_diff = false,
            position = "right",
        },
        keys = {
            {
                "<leader>u",
                function()
                    require('undotree').toggle()
                end
            }
        },
    },
    { "SmiteshP/nvim-navic",  opts = { highlight = true } },
    {
        "famiu/bufdelete.nvim",
        keys = {
            { "<leader>q", ":Bdelete<CR>",       desc = "Delete buffer" },
            { "<leader>f", ":Bdelete force<CR>", desc = "Force delete buffer" },
        },
        cmd = { "Bdelete", "Bdelete force" },
    },
    {
        "ghillb/cybu.nvim",
        opts = {
            position = {
                anchor = "topright",
                vertical_offset = 5,
                horizontal_offset = 5,
            },
            exclude = { "NvimTree" },
        },
        keys = {
            { "<A-h>", function() require('cybu').cycle("prev") end, desc = "Previous buffer" },
            { "<A-l>", function() require('cybu').cycle("next") end, desc = "Next buffer" },
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = { scope = { enabled = false } },
    },
    "stevearc/dressing.nvim",
    {
        "rcarriga/nvim-notify",
        init = function() vim.notify = require("notify") end,
        opts = { render = "compact", max_height = 10, max_width = 100, timeout = 500 },
    },
    { "folke/which-key.nvim", config = true },
    "tpope/vim-surround",
    {
        "monaqa/dial.nvim",
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group {
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.constant.alias.bool,
                    augend.constant.new { elements = { "True", "False" } },
                    augend.constant.new { elements = { "Yes", "No" } },
                    augend.constant.new { elements = { "yes", "no" } },
                },
            }
        end,
        keys = function()
            return {
                { "<C-a>",  require("dial.map").inc_normal(),  desc = "Dial up" },
                { "<C-x>",  require("dial.map").dec_normal(),  desc = "Dial down" },
                { "g<C-a>", require("dial.map").inc_gvisual(), desc = "Dial up",   mode = "v" },
                { "g<C-x>", require("dial.map").dec_gvisual(), desc = "Dial down", mode = "v" },
                { "<C-a>",  require("dial.map").inc_visual(),  desc = "Dial up",   mode = "v" },
                { "<C-x>",  require("dial.map").dec_visual(),  desc = "Dial down", mode = "v" },
            }
        end
    },
    "tpope/vim-repeat",
    {
        "norcalli/nvim-colorizer.lua",
        opts = { "*", css = { hsl_fn = true } },
    },
    {
        "lervag/vimtex",
        config = function()
            vim.g.vimtex_view_method = "zathura"
            vim.api.nvim_create_autocmd({ "User" }, {
                pattern = "VimtexEventQuit",
                command = "VimtexClean"
            })
        end,
        ft = "tex",
    },
    { "numToStr/Comment.nvim", config = true },
    {
        "folke/todo-comments.nvim",
        lazy = false,
        config = true,
        keys = function()
            local todo = require("todo-comments")
            return {
                { "]t",         todo.jump_next,           desc = "Next todo" },
                { "[t",         todo.jump_prev,           desc = "Previous todo" },
                { "<leader>tt", "<cmd>TodoTelescope<CR>", desc = "Search todos" },
            }
        end
    },
    {
        "ava5627/ACR.nvim",
        dir = "~/repos/ACR",
        dev = vim.loop.fs_stat(home .. "/repos/ACR") ~= nil,
        main = "acr",
        opts = {
            term_opts = {
                direction = "horizontal",
                on_open = function()
                    require("nvim-tree.api").tree.toggle({ focus = false })
                    require("nvim-tree.api").tree.toggle({ focus = false })
                end
            }
        },
        keys = {
            { "<F1>", function() require("acr").ACRLast() end, desc = "Run Last" },
            { "<F2>", function() require("acr").ACR() end,     desc = "Run Choose" },
            { "<F3>", function() require("acr").ACRAuto() end, desc = "Run default" },
        },
        dependencies = {
            "akinsho/toggleterm.nvim",
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = "all",
            autopairs = { enable = true, },
            highlight = { enable = true, },
            indent = { enable = true, },
        }
    },
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-refactor",
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

        "sindrets/diffview.nvim", -- optional - Diff integration
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
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>",          desc = "open diff" },
            { "<leader>gh", "<cmd>DiffviewFileHistory<CR>",   desc = "open history" },
            { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "open file history" },
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true,
        lazy = false,
        keys = {
            { "<leader>gs", "<cmd>Neogit<CR>", desc = "Git status" },
        }
    },
}, {
    dev = {
        path = "~/repos"
    }
})
