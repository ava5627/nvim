---@module "lazy"

-- 󰃐 󰆩 󰙅 󰛡   󰅲 some other good icons
local kind_icons = {
    Text          = "󰉿 ",
    TabNine       = " ",
    Method        = "m ",
    Function      = "󰊕 ",
    Constructor   = " ",
    Field         = " ",
    Variable      = "󰆧 ",
    Class         = "󰌗 ",
    Interface     = " ",
    Module        = " ",
    Property      = " ",
    Unit          = " ",
    Value         = "󰎠 ",
    Enum          = " ",
    Keyword       = "󰌋 ",
    Snippet       = " ",
    Color         = "󰏘 ",
    File          = "󰈙 ",
    Reference     = " ",
    Folder        = "󰉋 ",
    EnumMember    = " ",
    Constant      = "󰇽 ",
    Struct        = " ",
    Event         = " ",
    Operator      = "󰆕 ",
    TypeParameter = "󰊄 ",
}

---@type LazyPluginSpec
return {
    "hrsh7th/nvim-cmp",
    opts = function()
        local cmp = require("cmp")
        local compare = require("cmp.config.compare")
        local luasnip = require("luasnip")
        ---@type cmp.ConfigSchema
        return {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = {
                ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                ["<A-j>"] = cmp.mapping.select_next_item({ count = 5 }),
                ["<A-k>"] = cmp.mapping.select_prev_item({ count = 5 }),
                ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(5), { "i", "c" }),
                ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-5), { "i", "c" }),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<C-e>"] = cmp.mapping.abort(),
                -- Accept currently selected item. If none selected, `select` first item.
                -- Set `select` to `false` to only confirm explicitly selected items.
                ["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        cmp_tabnine = "[TAB9]",
                        lazydev = "[LUA]",
                        luasnip = "[LSnippet]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                        spell = "[Spell]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "cmp_tabnine" },
                { name = "luasnip" },
                { name = "lazydev" },
                { name = "buffer" },
                { name = "spell" },
                { name = "path" },
            },
            confirm_opts = {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            experimental = {
                ghost_text = false,
            },
            sorting = {
                priority_weight = 2,
                comparators = {
                    compare.offset,
                    compare.exact,
                    compare.score,
                    compare.kind,
                    compare.sort_text,
                    compare.length,
                    compare.order,
                },
            },
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.setup(opts)
        cmp.setup.cmdline({ "/", "?" }, {
            completion = { autocomplete = false },
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
        })
        cmp.setup.cmdline(":", {
            completion = { autocomplete = false },
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" }, }, { { name = "cmdline" } }),
        })
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        vim.lsp.config("*", {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
    end,
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "f3fora/cmp-spell",
        {
            "tzachar/cmp-tabnine",
            build = "./install.sh",
            cond = vim.fn.has("mac") == 0,
            dependencies = "hrsh7th/nvim-cmp"
        },
    }
}
