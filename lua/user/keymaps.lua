local function opts(desc, o)
    local default = { desc = desc, remap = false }
    return o and vim.tbl_extend("force", default, o) or default
end

local kmap = vim.keymap.set

kmap({ "n", "v", "o" }, "<Space>", "<Nop>", opts("Disable space"))
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.cmd("nmap <BS> <Space>")
kmap({ "n", "v", "o" }, "<BS>", "<Space>", opts("Secondary leader", { remap = true }))

-- save and quit
kmap("n", "<leader>ww", "<cmd>w<CR>", opts("Save"))
kmap("n", "<leader>wq", "<cmd>bdelete<CR>", opts("Save and close buffer"))
kmap("n", "<leader>wa", "<cmd>noa w<CR>", opts("Save without autocommands"))
kmap("n", "<A-q>", "<cmd>bdelete<CR>", opts("Close buffer"))
kmap("n", "<leader>we", "<cmd>checktime<CR>", opts("Reload buffer"))
kmap("n", "<leader>f", "<cmd>q!<CR>", opts("force close buffer"))

-- lsp
kmap("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
kmap("n", "gs", function() vim.lsp.buf.signature_help({ anchor_bias = "above" }) end, opts("Signature help"))
kmap("n", "gh", function() vim.lsp.buf.hover({ border = "rounded" }) end, opts("Hover"))
kmap("n", "ga", vim.lsp.buf.code_action, opts("Code Action"))
kmap("n", "<A-f>", vim.lsp.buf.format, opts("Format"))
kmap("n", "gl", function() vim.diagnostic.open_float({ border = "rounded" }) end, opts("Open diagnostic window"))
kmap({ "i", "s" }, "<C-s>",
    function() vim.lsp.buf.signature_help({ border = "rounded", anchor_bias = "above" }) end,
    opts("Signature help")
)
kmap("n", "<leader>gv",
    function()
        local vt = vim.diagnostic.config()["virtual_text"]
        vim.diagnostic.config({ virtual_text = not vt })
    end,
    opts("Toggle virtual text")
)
kmap("n", "<leader>gk",
    function()
        local vl = vim.diagnostic.config()["virtual_lines"]
        vim.diagnostic.config({ virtual_lines = not vl })
    end,
    opts("Toggle virtual lines")
)

-- navigation
kmap({ "o", "v", "x" }, "ir", "i]", opts("[] block"))
kmap({ "o", "v", "x" }, "ar", "a]", opts("[] block"))
kmap({ "o", "v", "x" }, "iq", "i\"", opts("\" string"))
kmap({ "o", "v", "x" }, "aq", "a\"", opts("\" string"))

kmap("c", "<A-Backspace>", "<C-w>", opts("Delete previous word"))
kmap({ "c", "i" }, "<A-h>", "<C-left>", opts("Move cursor left"))
kmap({ "c", "i" }, "<A-j>", "<C-down>", opts("Move cursor down"))
kmap({ "c", "i" }, "<A-k>", "<C-up>", opts("Move cursor up"))
kmap({ "c", "i" }, "<A-l>", "<C-right>", opts("Move cursor right"))

-- Clear search highlights
kmap("n", "<A-a>", "<cmd>nohl<CR>", opts("Clear search highlights"))

-- Insert line above/below without leaving normal mode
kmap("n", "<a-i>", "[<space>", opts("Insert line above", { remap = true }))
kmap("n", "<a-o>", "]<space>", opts("Insert line below", { remap = true }))
kmap("n", "<a-I>", "O<esc>", opts("Insert line above and move cursor"))
kmap("n", "<a-O>", "o<esc>", opts("Insert line below and move cursor"))
kmap("i", "<a-CR>", "<C-o>o", opts("Insert newline without leaving insert mode"))

-- Better window navigation
kmap("n", "<C-h>", "<C-w>h", opts("Window left"))
kmap("n", "<C-j>", "<C-w>j", opts("Window down"))
kmap("n", "<C-k>", "<C-w>k", opts("Window up"))
kmap("n", "<C-l>", "<C-w>l", opts("Window right"))
kmap("n", "<C-p>", "<C-w>p", opts("Previous window"))
kmap("n", "<C-q>", "<C-w>q", opts("Close window"))

-- Quick fix list
kmap("n", "<leader>co", "<cmd>copen<CR><C-w>p", opts("Open quickfix list"))
kmap("n", "<leader>cc", "<cmd>cclose<CR>", opts("Close quickfix list"))
kmap("n", "<leader>cn", "<cmd>cnext<CR>", opts("Next quickfix item"))
kmap("n", "<leader>cp", "<cmd>cprev<CR>", opts("Previous quickfix item"))

-- Resize windows with arrow keys
kmap("n", "<A-Up>", "<cmd>resize +5<CR>", opts("Resize window up"))
kmap("n", "<A-Down>", "<cmd>resize -5<CR>", opts("Resize window down"))
kmap("n", "<A-Left>", "<cmd>vertical resize +5<CR>", opts("Resize window left"))
kmap("n", "<A-Right>", "<cmd>vertical resize -5<CR>", opts("Resize window right"))

-- Open windows
kmap("n", "<leader>v", "<C-w>v", opts("Open vertical window"))
kmap("n", "<leader>s", "<C-w>s", opts("Open horizontal window"))

-- Paste in insert mode
kmap("i", "<C-p>", "<left><C-o>p", opts("Paste"))

-- Visual
kmap("v", "<", "<gv", opts("Shift left"))
kmap("v", ">", ">gv", opts("Shift right"))

-- Move selection up/down
kmap("v", "J", "<cmd>m '>+1<CR>gv=gv", opts("Move selection down"))
kmap("v", "K", "<cmd>m '<-2<CR>gv=gv", opts("Move selection up"))

-- paste without copying selection
kmap("v", "p", '"_dP', opts("Paste"))

-- select all
kmap("n", "<leader>av", "ggVG", opts("Select all"))
kmap("n", "<leader>ad", "ggVGd", opts("Delete all"))
kmap("n", "<leader>ay", "myggVGy`y", opts("Yank all"))
