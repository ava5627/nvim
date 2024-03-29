return {
    "neovim/nvim-lspconfig",
    lazy = false,
    keys = function()
        local telescope = require("telescope.builtin")
        return {
            { "gd",         telescope.lsp_definitions,      desc = "Go to definition" },
            { "gi",         telescope.lsp_implementations,  desc = "Go to implementation" },
            { "grf",        telescope.lsp_references,       desc = "Go to references" },
            { "gt",         telescope.lsp_type_definitions, desc = "Go to type definition" },
            { "<leader>pc", telescope.diagnostics,          desc = "Go to diagnostics" },
            { "gD",         vim.lsp.buf.declaration,        desc = "Go to declaration" },
            { "gs",         vim.lsp.buf.signature_help,     desc = "Signature help" },
            { "gh",         vim.lsp.buf.hover,              desc = "Hover" },
            { "grn",        vim.lsp.buf.rename,             desc = "Rename" },
            { "ga",         vim.lsp.buf.code_action,        desc = "Code Action" },
            { "<C-g><C-k>", vim.lsp.buf.signature_help,     desc = "Signature help" },
            { "<A-f>",      vim.lsp.buf.format,             desc = "Format" },
            {
                "gv",
                function()
                    local vt = vim.diagnostic.config()["virtual_text"]
                    vim.diagnostic.config({ virtual_text = not vt })
                end,
                desc = "Toggle virtual text"
            },
            {
                "[d",
                function() vim.diagnostic.goto_prev({ border = "rounded" }) end,
                desc = "Go to previous diagnostic"
            },
            {
                "gl",
                function() vim.diagnostic.open_float({ border = "rounded" }) end,
                desc = "Open diagnostic window"
            },
            {
                "]d",
                function() vim.diagnostic.goto_next({ border = "rounded" }) end,
                desc = "Go to next diagnostic"
            },
        }
    end,
    opts = {
        diagnostics = {
            virtual_text = false,
            signs = {
                active = {
                    { name = "DiagnosticSignError", text = "" },
                    { name = "DiagnosticSignWarn", text = "" },
                    { name = "DiagnosticSignHint", text = "" },
                    { name = "DiagnosticSignInfo", text = "" },
                },
            },
            update_in_insert = true,
            underline = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        },
        servers = {
            "jsonls",
            "lua_ls",
            "pylsp",
            "bashls",
            "texlab",
            "ltex",
            "gopls",
            "tsserver",
            "nil_ls"
        },
        on_attach = function(client, bufnr)
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd("CursorHold", {
                    pattern = "<buffer>",
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    pattern = "<buffer>",
                    callback = vim.lsp.buf.clear_references,
                })
            end
            require("lsp-inlayhints").on_attach(client, bufnr)
            require("nvim-navic").attach(client, bufnr)
        end,
        settings = {
            pylsp = {
                configurationSources = { "flake8" },
                plugins = {
                    pycodestyle = {
                        enabled = false,
                    },
                    jedi_completion = {
                        eager = true,
                    },
                    mccabe = {
                        enabled = false,
                    },
                    pyflakes = {
                        enabled = false,
                    },
                    flake8 = {
                        enabled = true,
                        maxLineLength = 120,
                        extendIgnore = { "E265" },
                    },
                    rope_autoimport = {
                        enabled = false,
                        completions = {
                            enabled = false
                        }
                    },
                }
            },
            ["rust-analyzer"] = {
                lens = {
                    enable = true,
                },
                hover = {
                    links = {
                        enable = false,
                    }
                }
            },
            ["nil"] = {
                formatting = {
                    command = { "alejandra" }
                },
                nix = {
                    maxMemoryMB = 6144,
                    flake = {
                        autoArchive = true,
                        autoEvalInputs = true,
                    }
                }
            },
        },
    },
    config = function(_, opts)
        vim.diagnostic.config(opts.diagnostics)
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
        })
        for _, sign in pairs(opts.diagnostics.signs.active) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end
        local lspconfig = require("lspconfig")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local server_opts = {
            on_attach = opts.on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
            settings = opts.settings,
        }
        for _, server in pairs(opts.servers) do
            lspconfig[server].setup(server_opts)
        end
        vim.g.rustaceanvim = { server = server_opts }
    end,
    dependencies = {
        {
            "folke/neodev.nvim",
            opts = {
                override = function(root, library)
                    if root:find("nvim") then
                        library.enabled = true
                        library.plugins = true
                    end
                end
            }
        },
        {
            "williamboman/mason.nvim",
            opts = { ui = { border = "rounded" } }
        },
        { "williamboman/mason-lspconfig.nvim", config = true },
        {
            "ray-x/lsp_signature.nvim",
            opts = {
                floating_window = false,
                hint_enable = true, -- virtual hint enable
                hint_prefix = "󰏫 ", -- Pencil for parameter
                hint_scheme = "String",
                hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
            }
        },
        { 'j-hui/fidget.nvim',            config = true },
        { "lvimuser/lsp-inlayhints.nvim", config = true },
        { 'mrcjkb/rustaceanvim',          ft = 'rust' },
    }
}
