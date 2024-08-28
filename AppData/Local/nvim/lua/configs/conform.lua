local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  },

  formatters = {
    my_formatter = {
      command = "<leader>fm",
    },
  },
}
-- vim.keymap.set({ "n", "v" }, "<leader>lp", function()
--   conform.format({
--     lsp_fallback = true,
--     async = false,
--     timeout_ms = 500
--   })
-- end, {desc = "Format file or range (in visual mode)"})

return options
