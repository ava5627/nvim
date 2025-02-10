local function on_attach(client, bufnr)
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
    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
    if client.name == "ltex" then
        require("ltex_extra").setup({
            path = vim.fn.stdpath("data") .. "/ltex",
        })
    end
end

---@type LazyPluginSpec
return {
    "neovim/nvim-lspconfig",
    lazy = false,
    keys = {
        { "gD",         vim.lsp.buf.declaration,    desc = "Go to declaration" },
        { "gs",         vim.lsp.buf.signature_help, desc = "Signature help" },
        { "gh",         vim.lsp.buf.hover,          desc = "Hover" },
        { "grn",        vim.lsp.buf.rename,         desc = "Rename" },
        { "ga",         vim.lsp.buf.code_action,    desc = "Code Action" },
        { "<C-g><C-k>", vim.lsp.buf.signature_help, desc = "Signature help" },
        { "<A-f>",      vim.lsp.buf.format,         desc = "Format" },
        {
            "<leader>gv",
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
    },
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
        settings = {
            Lua = {
                workspace = {
                    library = {
                        ["~/.local/share/factorio_lib/"] = true,
                    },
                },
            },
            pylsp = {
                configurationSources = { "flake8" },
                plugins = {
                    autopep8 = {
                        enabled = false,
                    },
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
                        extendIgnore = { "E265", "E203", "E741" },
                    },
                    rope_autoimport = {
                        enabled = false,
                        completions = {
                            enabled = false
                        }
                    },
                    black = {
                        enabled = true,
                    },
                }
            },
            nixd = {
                nixpkgs = {
                    expr = "import <nixpkgs> {}"
                },
                formatting = {
                    command = { "alejandra" }
                },
                options = {
                    nixos = {
                        expr = "(builtins.getFlake \"" .. vim.fn.expand("~") .. "/nixfiles\").nixosConfigurations." .. vim.fn.hostname() .. ".config"
                    },
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
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local server_opts = {
            on_attach = on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
            settings = opts.settings,
        }
        local installed = mason_lspconfig.get_installed_servers()
        if vim.fn.executable("pylsp") and not vim.tbl_contains(installed, "pylsp") then
            table.insert(installed, "pylsp")
        end
        if vim.fn.executable("nixd") and not vim.tbl_contains(installed, "nixd") then
            table.insert(installed, "nixd")
        end

        for _, server in pairs(installed) do
            if server ~= "rust_analyzer" then
                lspconfig[server].setup(server_opts)
            end
        end
    end,
    dependencies = {
        {

            "chrisgrieser/nvim-lsp-endhints",
            event = "LspAttach",
            config = true,
            keys = function()
                return {
                    { "<leader>i", require("lsp-endhints").toggle, desc = "Toggle LSP end hints" },
                }
            end,
        },
        {
            "folke/neodev.nvim",
            config = true,
        },
        {
            "williamboman/mason.nvim",
            opts = { ui = { border = "rounded" } }
        },
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = {
                    "jsonls",
                    "lua_ls",
                    "bashls",
                }
            }
        },
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
        { "j-hui/fidget.nvim",          config = true },
        {
            "mrcjkb/rustaceanvim",
            opts = {
                lens = {
                    enable = true,
                },
                hover = {
                    links = {
                        enable = false,
                    }
                },
            },
            config = function(_, opts)
                ---@type rustaceanvim.Executor
                local toggleterm_exec = {
                    execute_command = function(cmd, args, cwd, _)
                        local Terminal = require("toggleterm.terminal").Terminal
                        local shell = require("rustaceanvim.shell")
                        local term = Terminal:new({
                            dir = cwd,
                            cmd = shell.make_command_from_args(cmd, args),
                            close_on_exit = false,
                            direction = "horizontal",
                            on_open = function()
                                require("nvim-tree.api").tree.close()
                                require("nvim-tree.api").tree.toggle({ focus = false })
                            end
                        })
                        term:toggle()
                    end,
                }
                vim.g.rustaceanvim = {
                    tools = {
                        executor = toggleterm_exec,
                    },
                    server = {
                        on_attach = on_attach,
                        default_settings = {
                            ["rust-analyzer"] = opts,
                        }
                    },
                    dap = {}
                }
            end
        },
        { "barreiroleo/ltex_extra.nvim" },
        {
            "nvim-neotest/neotest",
            opts = function()
                return {
                    adapters = {
                        require("rustaceanvim.neotest"),
                        require("neotest-python")
                    }
                }
            end,
            keys = function()
                local neotest = require("neotest")
                return {
                    { "<leader>tt", function() neotest.run.run() end,                                    desc = "run nearest test" },
                    { "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,                  desc = "run file" },
                    { "<leader>td", function() neotest.run.run({ suite = false, strategy = "dap" }) end, desc = "debug nearest test" },
                    { "<leader>ts", function() neotest.summary.toggle() end,                             desc = "toggle summary" },
                    { "<leader>to", function() neotest.output_panel.toggle() end,                        desc = "toggle output panel" },
                    { "]f",         function() neotest.jump.next({ status = "failed" }) end,             desc = "jump to next failed test" },
                    { "[f",         function() neotest.jump.prev({ status = "failed" }) end,             desc = "jump to previous failed test" },
                    { "]t",         function() neotest.jump.next() end,                                  desc = "jump to next test" },
                    { "[t",         function() neotest.jump.prev() end,                                  desc = "jump to previous test" },
                }
            end,
            dependencies = {
                "nvim-neotest/neotest-python",
                "nvim-neotest/nvim-nio",
                "nvim-lua/plenary.nvim",
                "antoinemadec/FixCursorHold.nvim",
                "nvim-treesitter/nvim-treesitter",
                "mrcjkb/rustaceanvim",
            }
        },
    }
}
