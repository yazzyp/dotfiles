local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    sql = { "sqlfluff" },
    bash = { "shfmt" },
    yaml = { "yamlfmt" },
    cs = { "csharpier" },
    json = { "prettier" },
    toml = { "pyproject-fmt" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    markdown = { "mdformat", "injected" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   async = false,
  --   lsp_fallback = true,
  -- },

  formatters = {
    ruff_format = {
      prepend_args = { "--config", "format = { docstring-code-format=true }" },
    },
    pyproject_fmt = {
      condition = function(self, ctx)
        return vim.fs.basename(ctx.filename) == "pyproject.toml"
      end,
    },
    yamlfmt = {
      prepend_args = {
        "-formatter",
        "type=basic,max_line_length=80,pad_line_comments=2,trim_trailing_whitespace=true,retain_line_breaks=true",
      },
    },
    mdformat = {
      prepend_args = { "--number" },
    },
    sqlfluff = {
      args = { "fix", "--dialect=athena", "-" },
    },
  },

  vim.keymap.set("", "<leader>fm", function()
    require("conform").format {
      lsp_fallback = true,
      async = true,
      timeout_ms = 1000000, -- Set to nil to prevent timeout_ms
    }
  end, { desc = "Format file or range (in visual mode)" }),
}

return options
