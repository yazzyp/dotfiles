-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

-- M.base46 = {
M = {
  base46 = {
    theme = "catppuccin",
  },
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },

  term = {
    winopts = { number = false },
    sizes = { sp = 0.3, vsp = 0.4, ["bo sp"] = 0.3, ["bo vsp"] = 0.4 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },
}

return M
