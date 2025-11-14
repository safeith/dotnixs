require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- Git signs mappings
map("n", "<leader>gb", "<cmd> Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Current Line Blame" })

-- NeoTree mappings
map("n", "<leader>e", "<cmd> Neotree toggle<CR>", { desc = "Toggle NeoTree" })
map("n", "<C-n>", "<cmd> Neotree toggle<CR>", { desc = "Toggle NeoTree" })

-- Tmux navigation
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Navigate to left Tmux pane" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Navigate to down Tmux pane" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Navigate to up Tmux pane" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Navigate to right Tmux pane" })

-- Flash mappings
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash Jump" })

map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

map("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })

map({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

map("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
