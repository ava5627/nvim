---@type LazyPluginSpec[]
return {
    {
        "mfussenegger/nvim-dap",
        init = function()
            local sd = vim.fn.sign_define
            sd("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
            sd("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
        end,
        keys = function()
            local dap = require("dap")
            return {
                { "<leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
                { "<F9>",       dap.toggle_breakpoint, desc = "Toggle breakpoint" },
                {
                    "<leader>dB",
                    function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end,
                    desc = "Set conditional breakpoint",
                },
                { "<leader>dc", dap.continue,    desc = "Continue F5" },
                { "<F5>",       dap.continue,    desc = "Continue" },
                { "<leader>do", dap.step_over,   desc = "Step over F6" },
                { "<F6>",       dap.step_over,   desc = "Step over" },
                { "<leader>di", dap.step_into,   desc = "Step into F7" },
                { "<F7>",       dap.step_into,   desc = "Step into" },
                { "<leader>dO", dap.step_out,    desc = "Step out" },
                { "<F19>",      dap.step_out,    desc = "Step out S-F7" },
                { "<leader>dr", dap.repl.toggle, desc = "Toggle repl" },
                { "<leader>dl", dap.run_last,    desc = "Run last" },
                { "<leader>dt", dap.terminate,   desc = "Terminate F8" },
                { "<F8>",       dap.terminate,   desc = "Terminate" },
            }
        end
    },

    {
        "rcarriga/nvim-dap-ui",
        opts = {
            layouts = {
                {
                    elements = { "scopes", "watches", "breakpoints", "stacks", },
                    size = .25, -- 100 columns
                    position = "left",
                },
                {
                    elements = { "repl", "console", },
                    size = 0.25,
                    position = "bottom",
                },
            },
        },
        init = function()
            local dapui = require("dapui")
            local dap = require("dap").listeners.after
            dap.event_initialized["dapui_config"] = function()
                dapui.open()
                require("nvim-tree.api").tree.close()
            end
            dap.event_terminated["dapui_config"] = function()
                dapui.close()
                require("nvim-tree.api").tree.toggle({ focus = false })
            end
        end,
        keys = function()
            local dapui = require("dapui")
            return {
                { "<leader>du", dapui.toggle, desc = "Toggle UI" },
                { "<leader>de", dapui.eval,   desc = "Eval" },
            }
        end,
        dependencies = {
            "nvim-neotest/nvim-nio",
        }
    },
    { "theHamsta/nvim-dap-virtual-text", config = true },
}
