-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. ".ipynb"
  local file = io.open(path, "w")
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd("edit " .. path)
  else
    print "Error: Could not open new notebook file for writing."
  end
end

vim.api.nvim_create_user_command("NewNotebook", function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = "file",
})

-- Function to select code inside a markdown code block
local function select_code_block()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Check if current line is a backtick line
  local on_backticks = lines[current_line]:match("^```")

  -- Find the opening backticks (search upward from cursor)
  local start_line = nil

  -- If on backticks, we need to search above to find if there's an opening
  -- If we find one, then current line is closing; if not, current line is opening
  if on_backticks then
    for i = current_line - 1, 1, -1 do
      if lines[i]:match("^```") then
        start_line = i
        break
      end
    end
    -- If no backticks found above, current line is the opening
    if not start_line then
      start_line = current_line
    end
  else
    -- Not on backticks, search upward normally
    for i = current_line, 1, -1 do
      if lines[i]:match("^```") then
        start_line = i
        break
      end
    end
  end

  if not start_line then
    vim.notify("Not inside a code block", vim.log.levels.WARN)
    return false
  end

  -- Find the closing backticks (search downward from start)
  local end_line = nil
  for i = start_line + 1, #lines do
    if lines[i]:match("^```") then
      end_line = i
      break
    end
  end

  if not end_line then
    vim.notify("Code block not closed", vim.log.levels.WARN)
    return false
  end

  -- Select the code inside (excluding the backtick lines)
  local code_start = start_line + 1
  local code_end = end_line - 1

  if code_start > code_end then
    vim.notify("Empty code block", vim.log.levels.WARN)
    return false
  end

  -- Enter visual line mode and select
  vim.api.nvim_win_set_cursor(0, { code_start, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { code_end, 0 })

  return true
end

return {
  {
    "benlubas/molten-nvim",
    lazy = false,
    -- version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "folke/snacks.nvim", "quarto-dev/quarto-nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "snacks.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_auto_open_html_in_browser = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<CR>", mode = { "n" }, desc = "Initialise the plugin", { silent = true } },
      {
        "<leader>e",
        ":MoltenEvaluateOperator<CR>",
        mode = { "n" },
        desc = "run operator selection",
        { silent = true },
      },
      { "<leader>rl", ":MoltenEvaluateLine<CR>", mode = { "n" }, desc = "evaluate line", { silent = true } },
      { "<leader>rr", ":MoltenReevaluateCell<CR>", mode = { "n" }, desc = "re-evaluate cell", { silent = true } },
      {
        "<leader>r",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        mode = { "v" },
        desc = "evaluate visual selection",
        { silent = true },
      },
      { "<leader>rd", ":MoltenDelete<CR>", mode = { "n" }, desc = "delete cell", { silent = true } },
      { "<leader>oh", ":MoltenHideOutput<CR>", mode = { "n" }, desc = "hide output", { silent = true } },
      {
        "<leader>os",
        ":noautocmd MoltenEnterOutput<CR>",
        mode = { "n" },
        desc = "show/enter output",
        { silent = true },
      },
      -- {
      --   "<leader>rc",
      --   function()
      --     if select_code_block() then
      --       -- We're now in visual mode, execute the command
      --       local escaped = vim.api.nvim_replace_termcodes(":<C-u>MoltenEvaluateVisual<CR>gv", true, false, true)
      --       vim.api.nvim_feedkeys(escaped, "n", false)
      --     end
      --   end,
      --   mode = { "n" },
      --   desc = "evaluate code block",
      --   { silent = true },
      -- },
    },
  },
  -- {
  --   -- see the image.nvim readme for more information about configuring this plugin
  --   "3rd/image.nvim",
  --   build = false,
  --   opts = {
  --     backend = "kitty", -- whatever backend you would like to use
  --     processor = "magick_cli",
  --     max_width = 100,
  --     max_height = 12,
  --     max_height_window_percentage = math.huge,
  --     max_width_window_percentage = math.huge,
  --     window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
  --     tmux_show_only_in_active_window = true,
  --     -- window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --   },
  -- },
}
