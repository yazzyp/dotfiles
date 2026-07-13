return {

  -- use blink
  { import = "nvchad.blink.lazyspec" },

  { "tpope/vim-surround", lazy = false },
  { "tpope/vim-repeat", lazy = false },
  { "github/copilot.vim", lazy = false },
  { "kyoh86/vim-jsonl", event = "BufRead *.jsonl" },
  { "akinsho/git-conflict.nvim", lazy = false, version = "*", config = true },

  { require "configs.vim-slime" },
  { require "configs.dap" },
  { require "configs.snacks" },
  { require "configs.molten" },
  { require "configs.treesitter" },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require "configs.mcphub"
    end,
  },

  {
      "georgeharker/sharedserver",
      build = "cargo install --path rust",
      lazy = false,
  },

  {
      "georgeharker/mcp-companion",
      lazy = false,
      dependencies = {
          "olimorris/codecompanion.nvim",
          "georgeharker/sharedserver",
      },
      build = "cd bridge && uv sync --frozen",
      config = function()
          require("mcp_companion").setup({
              bridge = {
                  port = 9741,
                  config = vim.fn.expand("~/.config/mcp/servers.json"),
              },
              log = { level = "info", notify = "error" },
          })
      end,
  },

  {
    "olimorris/codecompanion.nvim",
    -- version = "v18.0.0",
    event = "VeryLazy",
    opts = require "configs.codecompanion",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "franco-ruggeri/codecompanion-spinner.nvim",
      -- "ravitemer/mcphub.nvim",
      "georgeharker/mcp-companion",
      "ravitemer/codecompanion-history.nvim",
    },
  },
  
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    config = function()
      require("nvim-tmux-navigation").setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        },
      }
    end,
  },
  
  {
    "Joakker/lua-json5",
    build = vim.fn.has "win32" == 1 and "powershell ./install.ps1" or "./install.sh",
    ft = { "json" },
  },

  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable "npx" then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable "npx" then
        vim.g.mkdp_filetypes = { "markdown" }
      end
    end,
  },
  
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require "configs.claude-code"
    end,
    keys = {
      {
        "<leader>cc",
        ":ClaudeCode<CR>",
        desc = "Toggle Claude Code",
        mode = { "n", "v", "t" },
      },
    },
  },

  {
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "jupyternotebook", "markdown" },
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    opts = require "configs.mason-tools",
  },

  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = require "configs.csvview",
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    keys = {
      { "<leader>cv", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV View" },
    },
  },
  
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },

  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require "configs.quarto"
    end,
  },

  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    -- ft = { "quarto", "jupyternotebook" },
    config = true,
    opts = {
      -- style = "markdown",
      -- output_extension = "md",
      -- force_ft = "markdown",
      style = "quarto",
      output_extension = "qmd",
      force_ft = "quarto",
    },
  },

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
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = require "configs.markdown",
    ft = { "markdown", "copilot-chat", "codecompanion", "quarto" },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          Snacks.picker.todo_comments { keywords = { "TODO", "FIX", "FIXME" } }
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has "nvim-0.10.0" == 1,
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
