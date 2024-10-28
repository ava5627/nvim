local function opts(desc, o)
    local default = { desc = desc, remap = false }
    return o and vim.tbl_extend("force", default, o) or default
end

local kmap = vim.keymap.set

local function rust_lsp(cmd_opts)
    return function()
        vim.cmd.RustLsp(cmd_opts)
    end
end

local dap = require("dap")
local function rust_debug()
    if dap.status() == "" then
        vim.cmd.RustLsp({ "debuggables" })
    else
        dap.continue()
    end
end
kmap("n", "<F5>", rust_debug, opts("Debug"))
kmap("n", "<S-F5>", rust_lsp({ "debuggables", bang = true }), opts("Previous debug"))
-- vim.g.rustaceanvim.dap.autoload_configurations = true

kmap("n", "J", rust_lsp("joinLines"), opts("Join lines"))
kmap("n", "<F1>", rust_lsp({ "runnables", bang = true }), opts("Previous run"))
kmap("n", "<F2>", rust_lsp({ "runnables" }), opts("Run"))

-- diagnostics
kmap("n", "gl", rust_lsp("renderDiagnostic"), opts("Current diagnostic"))
kmap("n", "ge", rust_lsp("explainError"), opts("Explain error"))

-- open cargo.toml
-- kmap("n", "<A-b>", rust_lsp("openCargo"), opts("Open Cargo.toml"))
