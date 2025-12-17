require("nvchad.configs.lspconfig").defaults()

vim.lsp.config.rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        enable = false,
        renderColons = false,
        parameterHints = { enable = false },
        typeHints = { enable = false },
        chainingHints = { enable = false },
        closingBraceHints = { enable = false },
      },
    },
  },
}

vim.lsp.config.gopls = {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = false,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
      },
    },
  },
}

local servers = { "yamlls", "rust_analyzer", "terraformls", "gopls", "pyright" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
