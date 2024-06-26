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
kmap("n", "<A-q>", "<cmd>bdelete<CR>", opts("Close buffer"))
kmap("n", "<leader>we", "<cmd>checktime<CR>", opts("Reload buffer"))
kmap("n", "<leader>fq", "<cmd>q!<CR>", opts("force close buffer"))

-- navigation
kmap("n", "<A-e>", "ge", opts("Move to end of previous word"))

-- Clear search highlights
kmap("n", "<A-a>", "<cmd>nohl<CR>", opts("Clear search highlights"))

-- Insert line above/below without leaving normal mode
kmap("n", "<a-i>", "moO<esc>`o", opts("Insert line above"))
kmap("n", "<a-o>", "moo<esc>`o", opts("Insert line below"))
kmap("n", "<a-I>", "moO<esc>", opts("Insert line above and move cursor"))
kmap("n", "<a-O>", "moo<esc>", opts("Insert line below and move cursor"))

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

-- Open/Close windows
kmap("n", "<leader>v", "<C-w>v", opts("Open vertical split"))
kmap("n", "<leader>s", "<C-w>s", opts("Open horizontal split"))

-- Insert Mode
kmap("i", "<A-h>", "<left>", opts("Move cursor left"))
kmap("i", "<A-j>", "<down>", opts("Move cursor down"))
kmap("i", "<A-k>", "<up>", opts("Move cursor up"))
kmap("i", "<A-l>", "<right>", opts("Move cursor right"))

-- Delete
kmap("i", "<A-d>", "<C-o>dw", opts("Delete word"))

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
