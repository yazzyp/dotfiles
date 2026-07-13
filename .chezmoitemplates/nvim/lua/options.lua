require "nvchad.options"

-- add yours here!

local opt = vim.opt
local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

opt.rnu = true

o.tabstop = 4

-- for better session saving
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local enable_providers = {
  "python3_provider",
}

for _, plugin in pairs(enable_providers) do
  vim.g["loaded_" .. plugin] = nil
  vim.cmd("runtime " .. plugin)
end
