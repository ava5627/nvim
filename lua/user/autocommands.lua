local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local kmap = vim.keymap.set

augroup("easy_quit", {})
autocmd("FileType", {
    group = "easy_quit",
    pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "fugitive", "gitcommit", "git", "toggleterm", "checkhealth", "neotest-*", "gitsigns-blame" },
    callback = function()
        kmap("n", "q", ":close<CR>", { silent = true, noremap = true, buffer = true })
    end,
    desc = "map q to close for certain filetypes",
})

-- Yank
augroup("HighlightYank", {})
autocmd("TextYankPost", {
    group = "HighlightYank",
    pattern = "*",
    callback = function()
        vim.hl.on_yank({ timeout = 40 })
    end,
    desc = "Highlight on yank",
})

-- Remove trailing whitespace
augroup("trim_whitespace", {})
autocmd("BufWritePre", {
    group = "trim_whitespace",
    pattern = "*",
    -- command = "%s/\\s\\+$//e",
    callback = function()
        if vim.b[0].editorconfig and vim.b[0].editorconfig.trim_trailing_whitespace == "false" then
            return
        end
        vim.cmd([[
            %s/\s\+$//e
        ]])
    end,
    desc = "Trim trailing whitespace"
})
