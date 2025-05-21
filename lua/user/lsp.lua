vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})
if vim.fn.executable("pylsp") then
    vim.lsp.enable("pylsp")
end
if vim.fn.executable("nixd") then
    vim.lsp.enable("nixd")
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
