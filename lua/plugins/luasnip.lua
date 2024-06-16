return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    lazy = false,
    keys = function()
        local lua_snip = require("luasnip")
        local snip_path = vim.fn.stdpath("config") .. "/LuaSnip"
        return {
            {
                "<C-i>",
                function ()
                    if lua_snip.choice_active() then
                        lua_snip.change_choice(1)
                    else
                        lua_snip.expand()
                    end
                end,
                desc = "Expand snippet or change choice", mode = { "i", "s" } },
            {
                "<C-l>",
                function()
                    if lua_snip.locally_jumpable(1) then
                        lua_snip.jump(1)
                    else
                        lua_snip.expand()
                    end
                end,
                desc = "Next snippet",
                mode = { "i", "s" }
            },
            {
                "<C-h>",
                function()
                    if lua_snip.locally_jumpable(-1) then
                        lua_snip.jump(-1)
                    end
                end,
                desc = "Previous snippet",
                mode = { "i", "s" }
            },
            {
                "<leader>ls",
                function() require("luasnip.loaders.from_lua").load({ paths = { snip_path } }) end
            },
        }
    end,
    config = function()
        require("luasnip/loaders/from_vscode").lazy_load()
        local snip_path = vim.fn.stdpath("config") .. "/LuaSnip"
        require("luasnip.loaders.from_lua").load({ paths = { snip_path } })
        require("luasnip").config.set_config({
            enable_autosnippets = true,
            update_events = "TextChanged,TextChangedI",
        })
    end,
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
}
