local options = {
  lspFeatures = {
    languages = { "python" },
    chunks = "all",
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  keymap = {
    hover = "K",
    definition = "gd",
    references = "gr",
    format = "<leader>fm",
  },
  codeRunner = {
    enabled = true,
    default_method = "molten",
  },
}

require("quarto").setup(options)

local runner = require "quarto.runner"
local map = vim.keymap.set

vim.api.nvim_create_autocmd("FileType", {
  pattern = "quarto",
  callback = function(ev)
    local opts = function(desc)
      return { desc = desc, silent = true, buffer = ev.buf }
    end
    map("n", "<leader>rc", runner.run_cell, opts "run cell")
    map("n", "<leader>ra", runner.run_above, opts "run cell and above")
    map("n", "<leader>rA", runner.run_all, opts "run all cells")
    map("n", "<leader>rl", runner.run_line, opts "run line")
    map("v", "<leader>r", runner.run_range, opts "run visual range")
    map("n", "<leader>RA", function()
      runner.run_all(true)
    end, opts "run all cells of all languages")
  end,
})
