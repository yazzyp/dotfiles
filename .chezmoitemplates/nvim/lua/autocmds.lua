require "nvchad.autocmds"

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

-- auto apply chezmoi changes when file is editted
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { os.getenv("HOME" .. "/.local/share/chezmoi/*") },
  callback = function(ev)
    local bufnr = ev.buf
    local edit_watch =
      function()
        require("chezmoi.commands.__edit").watch(bufnr)
      end, vim.schedule(edit_watch)
  end,
})

-- auto load buffer when file changed on disk
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd "checktime"
    end
  end,
})
