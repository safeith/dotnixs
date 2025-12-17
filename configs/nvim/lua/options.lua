require "nvchad.options"

-- Custom options
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Treesitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldenable = false  -- Disable folding by default (open all folds)
