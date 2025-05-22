---@module "lazy"

---@type LazyPluginSpec
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    lazy = false,
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
                    ["am"] = { query = "@function.outer", desc = "Outer function" },
                    ["im"] = { query = "@function.inner", desc = "Inner function" },
                    ["ia"] = { query = "@parameter.inner", desc = "Inner parameter" },
                    ["aa"] = { query = "@parameter.outer", desc = "outer parameter" },
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = { query = "@function.outer", desc = "Next function start" },
                },
                goto_next_end = {
                    ["]M"] = { query = "@function.outer", desc = "Next function end" },
                },
                goto_previous_start = {
                    ["[m"] = { query = "@function.outer", desc = "Previous function start" },
                },
                goto_previous_end = {
                    ["[M"] = { query = "@function.outer", desc = "Previous function end" },
                },
            },
        },
    },
    keys = function()
        local ts_to = require("nvim-treesitter.textobjects.move")
        return {
            { "<C-.>", function() ts_to.goto_next_start("@parameter.inner") end,     desc = "Next parameter",     mode = { "n", "v", "i", "o" } },
            { "<C-,>", function() ts_to.goto_previous_start("@parameter.inner") end, desc = "Previous parameter", mode = { "n", "v", "i", "o" } },
        }
    end,
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
                    { "[[", hat(tree_climber.goto_prev), desc = "Previous sibling" },
                    { "]]", hat(tree_climber.goto_next), desc = "Next sibling" },
                    { "]s", tree_climber.goto_child,     desc = "Child" },
                    { "[s", tree_climber.goto_parent,    desc = "Parent" },
                }
            end,
        },
    },
}
