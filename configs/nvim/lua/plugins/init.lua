return {
  { import = "nvchad.blink.lazyspec" },

  {
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      require "configs.conform"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    opts = {},
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup {
        filesystem = {
          filtered_items = {
            hide_dotfiles = true,
            hide_gitignored = false,
          },
        },
      }
    end,
  },

  {
    "williamboman/mason.nvim",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "json",
        "yaml",
        "python",
        "terraform",
        "rust",
        "nix",
      },
    },
  },

  {
    "tpope/vim-fugitive",
    lazy = false,
  },

  {
    "hashivim/vim-terraform",
    lazy = false,
  },

  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    "mrcjkb/rustaceanvim",
    lazy = false,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      cmdline = {
        view = "cmdline_popup",
        opts = {
          position = {
            row = "20%",
            col = "50%",
          },
        },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      stages = "fade",
      timeout = 3000,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
