local function indent_width()
    return vim.api.nvim_get_option_value("shiftwidth", { buf = 0 }) or ""
end

local navic_location = {
    function()
        local location = require("nvim-navic").get_location()
        if location == nil or location == "" or location == "Error" then
            return ""
        end
        return location
    end,
}

---@type LazyPluginSpec
return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            disabled_filetypes = {
                winbar = {
                    "NvimTree",
                    "dap-repl",
                    "dapui_scopes",
                    "dapui_watches",
                    "dapui_stacks",
                    "dapui_breakpoints",
                    "dapui_expressions",
                    "dapui_locals",
                    "dapui_repl",
                    "dapui_sessions",
                    "dapui_stopped_threads",
                    "dapui_widgets",
                    "dapui_win"
                }
            },
            globalstatus = true,
        },
        sections = {
            lualine_c = { "os.date('%H:%M')" },
            lualine_x = { indent_width, "fileformat", "filetype" },
        },
        inactive_sections = {},
        winbar = {
            lualine_a = { "filename" },
            lualine_c = { navic_location },
        },
        inactive_winbar = {
            lualine_a = { "filename" },
        },
        extensions = {
            "nvim-tree",
            "quickfix",
            "toggleterm",
            "nvim-dap-ui",
            "lazy",
            "mason",
        },
    }
}
