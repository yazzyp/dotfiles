require("claude-code").setup {
  window = {
    split_ratio = 0.5,
    position = "vertical",
    enter_insert = false,
  },
  keymaps = {
    toggle = {
      normal = "<M-c>", -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = "<M-c>", -- Terminal mode keymap for toggling Claude Code, false to disable
    },
  },
}

vim.api.nvim_create_autocmd("BufFilePost", {
  group = vim.api.nvim_create_augroup("lazyvim_config_claude-code", { clear = true }),
  pattern = {
    "*",
  },
  callback = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    if buf_name:match "claude%-code$" or buf_name:match "claude%-code%-%-" then
      vim.bo.buflisted = false
    end
  end,
  desc = "Hide Claude Code buffer from buffer list",
})
