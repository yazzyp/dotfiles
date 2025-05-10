vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = '#2d3148' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = '#37343c' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = '#33383e' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = '#2a3643' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = '#323048' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH6Bg', { bg = '#373146' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH1', { fg = '#8aa9f9' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH2', { fg = '#f6c983' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH3', { fg = '#cae797' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH4', { fg = '#77d3bf' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH5', { fg = '#ba9bf8' })
vim.api.nvim_set_hl(0, 'RenderMarkdownH6', { fg = '#f0abe6' })
vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { fg = '#8aa9f9' })
vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', { fg = '#f6c983' })
vim.api.nvim_set_hl(0, '@markup.heading.3.markdown', { fg = '#cae797' })
vim.api.nvim_set_hl(0, '@markup.heading.4.markdown', { fg = '#77d3bf' })
vim.api.nvim_set_hl(0, '@markup.heading.5.markdown', { fg = '#ba9bf8' })
vim.api.nvim_set_hl(0, '@markup.heading.6.markdown', { fg = '#f0abe6' })

local markdown = require "render-markdown"

markdown.setup({
  filetypes = { "markdown", "copilot-chat" },
  heading = {
    icons = {
        "█ ",
        "██ ",
        "███ ",
        "████ ",
        "█████ ",
        "██████ ",
      },
  }
})
