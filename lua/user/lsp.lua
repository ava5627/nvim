vim.diagnostic.config({
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
    },
})
vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = {
                    ["~/.local/share/factorio_lib/"] = true,
                },
            },
        }
    }
})
vim.lsp.config("pylsp", {
    settings = {
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
    }
})
vim.lsp.config("nixd", {
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> {}"
            },
            formatting = {
                command = { "alejandra" }
            },
            options = {
                nixos = {
                    expr = "(builtins.getFlake \"" ..
                        vim.fn.expand("~") .. "/nixfiles\").nixosConfigurations." .. vim.fn.hostname() .. ".config"
                },
            }
        },
    }
})
local mason_lspconfig = require("mason-lspconfig")
local installed = mason_lspconfig.get_installed_servers()
if vim.fn.executable("pylsp") and not vim.tbl_contains(installed, "pylsp") then
    table.insert(installed, "pylsp")
end
if vim.fn.executable("nixd") and not vim.tbl_contains(installed, "nixd") then
    table.insert(installed, "nixd")
end

for _, server in pairs(installed) do
    if server ~= "rust_analyzer" then
        vim.lsp.enable(server)
    end
end
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("my.lsp.document_highlight", {})
            vim.api.nvim_create_autocmd("CursorHold", {
                group = group,
                buffer = args.buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = group,
                buffer = args.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
        if client:supports_method("textDocument/documentSymbol") then
            require("nvim-navic").attach(client, args.buf)
        end
    end,
})
