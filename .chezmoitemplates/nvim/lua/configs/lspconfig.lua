-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- filetypes and language registrations
vim.filetype.add {
  extension = {
    tmpl = "gotmpl",
    ipynb = "jupyternotebook",
  },
  pattern = {
    [".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
    [".*/.github/actions/.*%.yml"] = "yaml.ghaction",
    [".env"] = "dotenv",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
}
vim.treesitter.language.register("bash", { "dotenv" })
-- vim.treesitter.language.register("zsh", "zsh"),

local servers = {
  "html",
  "cssls",
  "basedpyright",
  "bashls",
  "yamlls",
  "jsonls",
  "lemminx",
  "cypher_ls",
  -- "docker_compose_language_service",
  "docker_language_server",
  -- "ty",
  "omnisharp",
  "vtsls",
  "marksman",
  "jinja_lsp",
  "sqls",
  -- "copilot",
}

vim.lsp.config("Omnisharp", {
  -- cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
  -- cmd = {
  --     -- vim.fn.executable('OmniSharp') == 1 and 'OmniSharp' or 'omnisharp',
  --     "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll",
  --     '-z', -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
  --     '--hostPID',
  --     tostring(vim.fn.getpid()),
  --     'DotNet:enablePackageRestore=false',
  --     '--encoding',
  --     'utf-8',
  --     '--languageserver',
  -- },

  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    MsBuild = {
      -- LoadProjectsOnDemand = nil,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      -- AnalyzeOpenDocumentsOnly = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
})

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
      },
    },
  },
})

vim.lsp.enable(servers)
