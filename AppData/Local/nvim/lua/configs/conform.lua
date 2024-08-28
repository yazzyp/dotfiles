local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    sql = { "sqlfmt" },
    bash = { "shfmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  },

  vim.keymap.set({ "n", "v" }, "<leader>fm", function()
    local conform = require("conform")
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000000
    })
  end, {desc = "Format file or range (in visual mode)"})
}

return options
