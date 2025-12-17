require "nvchad.autocmds"

-- Enable inlay hints once when LSP attaches (not on mode changes)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.server_capabilities.inlayHintProvider then
      -- Enable inlay hints for this buffer only once
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})
