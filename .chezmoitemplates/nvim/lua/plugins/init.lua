return {

  { "christoomey/vim-tmux-navigator", lazy = false },
  { "tpope/vim-surround", lazy = false },
  { "Joakker/vim-antlr4", lazy = false },
  { "github/copilot.vim", lazy = false },
  { require "configs.copilot-chat" },
  { require "configs.vim-slime" },
  { require "configs.dap" },

  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      -- log_level = 'debug',
    },
  },

  {
    "rhysd/conflict-marker.vim",
    lazy = false,
    config = function()
      require "configs.conflict-marker"
    end,
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("chezmoi").setup {}
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" },
    config = function()
      require "configs.lint"
    end,
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
