require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- map('n', '<leader>o', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = "Open diagnostic float" })
-- vim.keymap.set("n", "<leader>cz", "<cmd> Telescope chezmoi find_files <cr>", { desc = "Find chezmoi files" })
