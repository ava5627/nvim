---@module "lazy"

local function on_attach(bufnr)
    local nt_api = require("nvim-tree.api")
    local function opts(desc, o)
        local default = { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        return o and vim.tbl_extend("force", default, o) or default
    end

    nt_api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "l", nt_api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "v", nt_api.node.open.vertical, opts("Open Vertical Split"))
    vim.keymap.set("n", "s", nt_api.node.open.horizontal, opts("Open Horizontal Split"))
    vim.keymap.set("n", "h", nt_api.node.navigate.parent_close, opts("Close"))
    vim.keymap.set("n", "<BS>", "<leader>", opts("Backspace Leader", { remap = true }))
    vim.keymap.set("n", "]d", nt_api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    vim.keymap.set("n", "[d", nt_api.node.navigate.diagnostics.prev, opts("Previous Diagnostic"))
end

---@type LazyPluginSpec
return {
    "nvim-tree/nvim-tree.lua",
    opts = {
        hijack_cursor = true,
        sync_root_with_cwd = true,
        on_attach = on_attach,
        renderer = {
            indent_markers = {
                enable = true,
            },
            icons = {
                git_placement = "after",
                show = {
                    folder_arrow = false,
                },
                glyphs = {
                    default = "󰈔",
                    git = {
                        unstaged = "●",
                        ignored = "●",
                    },
                },
            },
        },
        update_focused_file = {
            enable = true,
            exclude = function(event)
                return vim.api.nvim_get_option_value("filetype", { buf = event.buf }) == "gitcommit" or
                    vim.fn.expand("%"):match("site%-packages")
            end,
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
    },
    keys = {
        {
            "<leader>e",
            function()
                require("nvim-tree.api").tree.toggle({ focus = false })
            end,
            desc = "Toggle file explorer"
        }
    },
    lazy = false,
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end
}
