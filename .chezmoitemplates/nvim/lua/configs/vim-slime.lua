return {
  "jpalardy/vim-slime",
  -- lazy = false,
  init = function()
    -- these two should be set before the plugin loads
    vim.g.slime_target = "neovim"
    vim.g.slime_no_mappings = true
    -- vim.g.slime_python_ipython = 1
  end,
  config = function()
    vim.g.slime_python_ipython = 1
    if vim.fn.confirm("Select target type", "&tmux\n&nvim", 2) == 1 then
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = {
        socket_name = vim.api.nvim_eval('get(split($TMUX, ","), 0)'),
        target_pane = "{top-right}",
      }
    else
      vim.g.slime_input_pid = false
      vim.g.slime_suggest_default = true
      vim.g.slime_menu_config = false
      vim.g.slime_neovim_ignore_unlisted = false
    end
  end,
  keys = {
    { "gz", "<Plug>SlimeMotionSend", mode = { "n" }, { remap = true, silent = false } },
    { "gzz", "<Plug>SlimeLineSend", mode = { "n" }, { remap = true, silent = false } },
    { "gzg", "<Plug>SlimeParagraphSend", mode = { "n" }, { remap = true, silent = false } },
    { "gz", "<Plug>SlimeRegionSend", mode = { "x" }, { remap = true, silent = false } },
    { "gzc", "<Plug>SlimeConfig", mode = { "n" }, { remap = true, silent = false } },
  },
  event = "TermOpen",
}
