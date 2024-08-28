local lint = require "lint"
local linters = require("lint").linters

lint.linters_by_ft = {
  python = { "flake8" },
  bash = { "shellcheck" },
  sql = { "sqlfluff" },
}


-- path/to/file:line:col: code message
local pattern = "[^:]+:(%d+):(%d+):(%w+):(.+)"
local groups = { "lnum", "col", "code", "message" }

-- set up flake8
linters.flake8 = {
  cmd = "flake8",
  stdin = true,
  args = {
    "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
    "--no-show-source",
    "--max-line-length=88",
    "--stdin-display-name",
    function()
      return vim.api.nvim_buf_get_name(0)
    end,
    "-",
  },
  ignore_exitcode = true,
  parser = require("lint.parser").from_pattern(pattern, groups, nil, {
    ["source"] = "flake8",
    ["severity"] = vim.diagnostic.severity.WARN,
  }),
}

-- set up sqlfluff
linters.sqlfluff = {
  cmd = "sqlfluff",
  args = {
    "lint",
    "--format=json",
    -- note: users will have to replace the --dialect argument accordingly
    "--dialect=ansi",
  },
  ignore_exitcode = true,
  stdin = false,
  parser = function(output, _)
    local per_filepath = {}
    if #output > 0 then
      local status, decoded = pcall(vim.json.decode, output)
      if not status then
        per_filepath = {
          {
            filepath = "stdin",
            violations = {
              {
                source = "sqlfluff",
                line_no = 1,
                line_pos = 1,
                code = "jsonparsingerror",
                description = output,
              },
            },
          },
        }
      else
        per_filepath = decoded
      end
    end
    local diagnostics = {}
    for _, i_filepath in ipairs(per_filepath) do
      for _, violation in ipairs(i_filepath.violations) do
        table.insert(diagnostics, {
          source = "sqlfluff",
          lnum = (violation.line_no or violation.start_line_no) - 1,
          col = (violation.line_pos or violation.start_line_pos) - 1,
          severity = vim.diagnostic.severity.ERROR,
          message = violation.description,
          user_data = { lsp = { code = violation.code } },
        })
      end
    end
    return diagnostics
  end,
}


-- set up key mapping to trigger linting
vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })

-- Add autocmd to trigger linting on text change, insert leave and save
vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
