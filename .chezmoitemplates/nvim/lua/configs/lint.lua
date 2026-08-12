local lint = require "lint"
local linters = require("lint").linters

lint.linters_by_ft = {
  python = { "ruff" },
  bash = { "shellcheck" },
  sql = { "sqlfluff" },
  yaml = { "yamllint" },
  ["yaml.ghaction"] = { "actionlint" }, -- for gha
  typescript = { "eslint" },
  javascript = { "eslint" },
  typescriptreact = { "eslint" },
  javascriptreact = { "eslint" },
  markdown = { "vale" },
  ["dotenv"] = { "dotenv_linter" },
}

-- -- Extend ruff linter args
local default_ruff_args = linters.ruff.args
linters.ruff.args = vim.list_extend(vim.deepcopy(default_ruff_args), {
  "--extend-select",
  -- "E,F,I,W,B,C4,UP,D,ANN,DOC",
  "ALL",
  "--ignore",
  "W191,E111,E114,E117,D206,D300,Q000,Q001,Q002,Q003,COM812,COM819,ISC002",
  "--extend-per-file-ignores",
  "tests/**/*.py:S101,test/**/*.py:S101,**/tests/**/*.py:S101,**/test/**/*.py:S101",
  "--config",
  "lint.pydocstyle = { convention='google' }",
})

linters.sqlfluff.args = {
  "lint",
  "--format=json",
  "--dialect=athena",
}

-- linters.sqlfluff = {
--   cmd = "sqlfluff", -- Command to run the linter
--   args = {
--     "lint",
--     "--format=json",
--     "--dialect=athena",
--   },
--   ignore_exitcode = true,
--   stdin = false,
--   parser = function(output, _)
--     local per_filepath = {}
--     if #output > 0 then
--       local status, decoded = pcall(vim.json.decode, output)
--       if not status then
--         per_filepath = {
--           {
--             filepath = "stdin",
--             violations = {
--               {
--                 source = "sqlfluff",
--                 line_no = 1,
--                 line_pos = 1,
--                 code = "jsonparsingerror",
--                 description = output,
--               },
--             },
--           },
--         }
--       else
--         per_filepath = decoded
--       end
--     end
--     local diagnostics = {}
--     for _, i_filepath in ipairs(per_filepath) do
--       for _, violation in ipairs(i_filepath.violations) do
--         table.insert(diagnostics, {
--           source = "sqlfluff",
--           lnum = (violation.line_no or violation.start_line_no) - 1,
--           col = (violation.line_pos or violation.start_line_pos) - 1,
--           severity = vim.diagnostic.severity.ERROR,
--           message = violation.description,
--           user_data = { lsp = { code = violation.code } },
--         })
--       end
--     end
--     return diagnostics
--   end,
-- }

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

-- Set up key mapping to trigger linting
vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
  -- print("Triggering linting...")
end, { desc = "Trigger linting for current file" })

-- Add autocmd to trigger linting on text change and save
vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})
