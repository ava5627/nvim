local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local kmap = vim.keymap.set

augroup("easy_quit", {})
autocmd("FileType", {
    group = "easy_quit",
    pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir", "fugitive", "gitcommit", "git", "toggleterm", "checkhealth", "neotest-*" },
    callback = function()
        kmap("n", "q", ":close<CR>", { silent = true, noremap = true, buffer = true })
    end,
})

-- Yank
augroup("HighlightYank", {})
autocmd("TextYankPost", {
    group = "HighlightYank",
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
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
})

augroup("neogit", {})
autocmd("FileType", {
    group = "neogit",
    pattern = { "NeogitStatus" },
    callback = function()
        kmap("n", ")", "}j", { silent = true, noremap = true, buffer = true })
        kmap("n", "(", "{{j", { silent = true, noremap = true, buffer = true })
    end
})
