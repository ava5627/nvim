vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})
local mason_lspconfig = require("mason-lspconfig")
local installed = mason_lspconfig.get_installed_servers()
if vim.fn.executable("pylsp") and not vim.tbl_contains(installed, "pylsp") then
    table.insert(installed, "pylsp")
end
if vim.fn.executable("nixd") and not vim.tbl_contains(installed, "nixd") then
    table.insert(installed, "nixd")
end

for _, server in pairs(installed) do
    if server ~= "rust-analyzer" then
        vim.lsp.enable(server)
    end
end
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if not client then
            return
        end
        if client:supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("my.lsp.document_highlight", {clear = false})
            vim.api.nvim_create_autocmd("CursorHold", {
                group = group,
                buffer = args.buf,
                callback = vim.lsp.buf.document_highlight,
                desc = "Highlight symbol under cursor",
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = group,
                buffer = args.buf,
                callback = vim.lsp.buf.clear_references,
                desc = "Clear Highlight",
            })
        end
        if client:supports_method("textDocument/documentSymbol") then
            require("nvim-navic").attach(client, args.buf)
        end
    end,
    desc = "LSP attach",
})
