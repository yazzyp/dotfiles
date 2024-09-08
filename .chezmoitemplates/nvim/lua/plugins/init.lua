return {
  { "christoomey/vim-tmux-navigator", lazy = false },
  { "tpope/vim-surround", lazy = false },

  {
    "jpalardy/vim-slime",
    lazy = false,
    init = function()
      vim.g.slime_target = "neovim"
      vim.g.slime_no_mappings = true
    end,
    config = function()
      require "configs.vim-slime"
    end,
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

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mufusseneger/nvim-lint",
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
