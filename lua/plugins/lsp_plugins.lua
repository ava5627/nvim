---@type LazyPluginSpec[]|string[]
return {
    { "neovim/nvim-lspconfig", lazy = false, },
    "hrsh7th/cmp-nvim-lsp",
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
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "~/.local/share/factorio_lib/",
                "lazy.nvim",
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
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
    { "j-hui/fidget.nvim",     config = true },
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
                    default_settings = {
                        ["rust-analyzer"] = opts,
                    }
                },
            }
        end
    },
    {
        "barreiroleo/ltex_extra.nvim",
        init = function()
            vim.lsp.config("ltex", {
                on_attach = function(_, _)
                    require("ltex_extra").setup({
                        path = vim.fn.stdpath("data") .. "/ltex",
                    })
                end
            })
        end,
    },
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
