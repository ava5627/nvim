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
---@diagnostic disable-next-line: undefined-field
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
        -- cond = vim.fn.has("mac") == 0,
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
            panel = {
                keymap = {
                    open = "<A-`>",
                }
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
            { "<leader>u", function() require('undotree').toggle() end, desc = "Toggle undotree" }
        },
    },
    { "SmiteshP/nvim-navic", opts = { highlight = true } },
    {
        "famiu/bufdelete.nvim",
        keys = {
            { "<leader>q", ":Bdelete<CR>", desc = "Delete buffer" },
        },
        cmd = { "Bdelete" },
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
        ---@module "ibl"
        ---@type ibl.config
        opts = { scope = { enabled = false } },
    },
    "stevearc/dressing.nvim",
    {
        "rcarriga/nvim-notify",
        init = function() vim.notify = require("notify") end,
        opts = { render = "compact", max_height = 10, max_width = 100, timeout = 500 },
    },
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
    {
        "kylechui/nvim-surround",
        config = true,
    },
    {
        "norcalli/nvim-colorizer.lua",
        opts = { "*", css = { hsl_fn = true } },
    },
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zathura"
        end,
        ft = "tex",
    },
    {
        "numToStr/Comment.nvim",
        config = true,
    },
    {
        "folke/todo-comments.nvim",
        lazy = false,
        config = true,
        keys = function()
            -- local todo = require("todo-comments")
            return {
                -- { "]t",        todo.jump_next,           desc = "Next todo" },
                -- { "[t",        todo.jump_prev,           desc = "Previous todo" },
                { "<leader>ot", "<cmd>TodoTelescope<CR>", desc = "Search todos" },
            }
        end
    },
    {
        "ava5627/ACR.nvim",
        dev = true,
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
        keys = function()
            return {
                { "<F1>", require("acr").ACRLast, desc = "Run Last" },
                { "<F2>", require("acr").ACR,     desc = "Run Choose" },
                { "<F3>", require("acr").ACRAuto, desc = "Run default" },
            }
        end,
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
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "Outer function" },
                        ["if"] = { query = "@function.inner", desc = "Inner function" },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = { query = "@function.outer", desc = "Next function start" },
                        -- ["]b"] = { query = "@attribute.outer", desc = "Next attribute"}
                    },
                    goto_next_end = {
                        ["]M"] = { query = "@function.outer", desc = "Next function end" },
                    },
                    goto_previous_start = {
                        ["[m"] = { query = "@function.outer", desc = "Previous function start" },
                        -- ["[b"] = { query = "@attribute.outer", desc = "Previous attribute"}
                    },
                    goto_previous_end = {
                        ["]M"] = { query = "@function.outer", desc = "Previous function end" },
                    },
                    goto_next = {
                    }
                },
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "nvim-treesitter/nvim-treesitter-refactor",
            {
                "drybalka/tree-climber.nvim",
                keys = function()
                    local tree_climber = require("tree-climber")
                    local hat = function(k)
                        return function()
                            vim.api.nvim_feedkeys("^", "n", true)
                            k()
                        end
                    end
                    return {
                        { "}", hat(tree_climber.goto_next), desc = "Next sibling" },
                        { "{", hat(tree_climber.goto_prev), desc = "Previous sibling" },
                        -- { "][", tree_climber.goto_child,  desc = "Child" },
                        -- { "[]", tree_climber.goto_parent, desc = "Parent" },
                    }
                end,
            },
        },
    },
    {
        'nmac427/guess-indent.nvim',
        config = true,
    },
    {
        "chrisgrieser/nvim-spider",
        keys = function()
            local spider = require("spider")
            local m = function(k) return function() spider.motion(k) end end
            return {
                { "<A-e>",         m('e'),                desc = "Spider e",            mode = { "n", "o", "x" } },
                { "<A-w>",         m('w'),                desc = "Spider w",            mode = { "n", "o", "x" } },
                { "<A-b>",         m('b'),                desc = "Spider b",            mode = { "n", "o", "x" } },
                { "<A-w>",         "x<left><C-o>dv<A-b>", desc = "Delete partial word", mode = "i",              remap = true },
                { "<A-backspace>", "x<left><C-o>dv<A-b>", desc = "Delete partial word", mode = "i",              remap = true },
                { "<A-d>",         "<C-o>d<A-e>",         desc = "Delete partial word", mode = "i",              remap = true },
                { "<A-delete>",    "<C-o>d<A-e>",         desc = "Delete partial word", mode = "i",              remap = true },
            }
        end,
    },
    {
        "johmsalas/text-case.nvim",
        opts = {
            prefix = "gm",
        }
    }
}, {
    dev = {
        path = "~/repos",
        fallback = true
    }
})
