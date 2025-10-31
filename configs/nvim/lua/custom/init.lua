vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.cmd "Copilot disable"
  end,
})
