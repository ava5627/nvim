local function opts(desc, o)
    ---@type vim.keymap.set.Opts
    local default = { desc = desc, remap = false, buffer = true }
    return o and vim.tbl_extend("force", default, o) or default
end

local kmap = vim.keymap.set
kmap("n", "}", "<cmd>silent! normal! ^%j^<cr>", opts("Move to next paragraph", { silent = true }))
kmap("n", "{", "k^%^", opts("Move to previous paragraph"))
