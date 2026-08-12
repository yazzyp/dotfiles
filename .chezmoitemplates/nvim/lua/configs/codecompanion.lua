local function get_user_header()
  local user = vim.env.USER or "User"
  user = user:sub(1, 1):upper() .. user:sub(2)
  return "  " .. user .. " "
end

vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>av", function()
  require("codecompanion").toggle()
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>am", function()
  require("codecompanion").prompt "commit"
end, { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd [[cab cc CodeCompanion]]

local options = {
  display = {
    chat = {
      icons = {
        buffer_sync_all = "󰪴 ",
        buffer_sync_diff = " ",
        chat_context = " ",
        chat_fold = " ",
        tool_pending = "  ",
        tool_in_progress = "  ",
        tool_failure = "  ",
        tool_success = "  ",
      },
    },
  },
  adapters = {
    acp = {
      copilot_acp = function()
        return require("codecompanion.adapters").extend("copilot_acp", {
          defaults = {
            mcpServers = "inherit_from_config",
          },
        })
      end,
    }
  },
  interactions = {
    chat = {
      -- adapter = "copilot_acp",
      adapter = {
        name = "copilot",
        model = "claude-opus-4.7",
      },
      roles = {
        user = "  User",
        llm = function(adapter)
          local model_name
          if adapter.type == "http" then
            model_name = adapter.schema.model.default or "No Model"
          else
            model_name = adapter.model or "No Model"
          end
          return "  CodeCompanion (" .. adapter.formatted_name .. " - " .. model_name .. ")"
        end,
      },
    },
    cli = {
      agent = "opencode",
      agents = {
        opencode = {
          cmd = "opencode",
          args = {},
          description = "Opencode CLI",
          provider = "terminal",
        },
        claude_code = {
          cmd = "claude",
          args = {},
          description = "Claude Code CLI",
          provider = "terminal",
        },
      },
    },
  },
  extensions = {
    spinner = {},
    -- mcphub = {
    --   callback = "mcphub.extensions.codecompanion",
    --   opts = {
    --     make_vars = true,
    --     make_slash_commands = true,
    --     show_result_in_chat = true,
    --   },
    -- },
    mcp_companion = {
        callback = "mcp_companion.cc",
        opts = {},
    },
    history = {
      opts = {
        picker = "snacks",
        expiration_days = 30,
      },
    },
  },
}

return options
