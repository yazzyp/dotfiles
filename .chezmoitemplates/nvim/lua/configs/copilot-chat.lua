-- local IS_DEV = false

local prompts = {
  -- Code related prompts
  Explain = "Please explain how the following code works.",
  Review = "Please review the following code and provide suggestions for improvement.",
  Tests = "Please explain how the selected code works, then generate unit tests for it.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
  FixCode = "Please fix the following code to make it work as intended.",
  FixError = "Please explain the error in the following text and provide a solution.",
  BetterNamings = "Please provide better names for the following variables and functions.",
  Documentation = "Please provide documentation for the following code.",
  SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
  SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
  -- Text related prompts
  Summarize = "Please summarize the following text.",
  Spelling = "Please correct any grammar and spelling errors in the following text.",
  Wording = "Please improve the grammar and wording of the following text.",
  Concise = "Please rewrite the following text to make it more concise.",
}

local function get_user_header()
  local user = vim.env.USER or "User"
  user = user:sub(1, 1):upper() .. user:sub(2)
  return "  " .. user .. " "
end

return {
  -- { import = "plugins.extras.copilot-vim" }, -- Or use { import = "lazyvim.plugins.extras.coding.copilot" },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>gm", group = "Copilot Chat" },
      },
    },
  },
  {
    -- dir = IS_DEV and "~/Projects/research/CopilotChat.nvim" or nil,
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    -- version = "v3.3.0", -- use specific version to prevent breaking changes
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
      { "nvim-lua/plenary.nvim" },
      { "MeanderingProgrammer/render-markdown.nvim" },
    },
    build = "make tiktoken",
    opts = {
      -- model = "claude-4-sonnet",
      -- tools = 'copilot',
      sticky = {"@copilot", "$claude-sonnet-4"},

      auto_follow_cursor = false, -- Don't follow the cursor after getting response

      -- selection = "visual",

      headers = {
        user = get_user_header(),
        assistant = "  Copilot ",
        tool = "  Tool "
      },

      -- prompts = prompts,

      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<C-b> or /<C-b> for options.",
          insert = "<C-b>",
        },
        -- Accept the diff
        accept_diff = {
          normal = "<C-a>",
          insert = "<C-a>",
        },
        -- Show help
        show_diff = {
          normal = "gi",
        },
      },
    },
    config = function(_, opts)
      local chat = require "CopilotChat"
      chat.setup(opts)

      vim.api.nvim_set_hl(0, "CopilotChatHeader", { link = "@markup.heading.1.markdown" })
      -- vim.opt.completeopt:append({ "noinsert", "noselect", "popup" })

      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = "visual" })
        chat.open()
      end, { nargs = "*", range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = "visual",
        })
        chat.open({
          window = {
            layout = "float",
            relative = "cursor",
            width = 0.6,
            height = 0.4,
            row = 1,
            blend = 30,
          },
        })
      end, { nargs = "*", range = true })

      vim.api.nvim_create_user_command("CopilotQuickChat", function()
        vim.ui.input({ prompt = "Quick Chat: " }, function(input)
          if input and input ~= "" then
            chat.ask(input, { resources = "buffer" })
            chat.open()
          end
        end)
      end, { nargs = "*", range = true })

      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { resources = "buffer" })
        chat.open()
      end, { nargs = "*", range = true })

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          -- Get current filetype and set it to markdown if the current filetype is copilot-chat
          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })
    end,
    event = "VeryLazy",
    keys = {
      -- Show prompts actions with telescope
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt {
            resources = "buffers"
          }
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        mode = "x",
        desc = "CopilotChat - Prompt actions",
      },
      -- Code related commands
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
      -- Chat with Copilot in visual mode
      {
        "<leader>av",
        ":CopilotChatVisual<cr>",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>ax",
        ":CopilotChatInline<cr>",
        mode = "x",
        desc = "CopilotChat - Inline chat",
      },
      -- Custom input for CopilotChat
      -- {
      --   "<leader>ai",
      --   function()
      --     local input = vim.fn.input "Ask Copilot: "
      --     if input ~= "" then
      --       vim.cmd("CopilotChat " .. input)
      --     end
      --   end,
      --   desc = "CopilotChat - Ask input",
      -- },
      -- Generate commit message based on the git diff
      {
        "<leader>am",
        "<cmd>CopilotChatCommit<cr>",
        desc = "CopilotChat - Generate commit message for all changes",
      },
      -- Quick chat with Copilot
      {
        "<leader>aq",
        "<cmd>CopilotQuickChat<cr>",
        mode = "n",
        desc = "CopilotChat - Quick chat",
      },
      -- Fix the issue with diagnostic
      { "<leader>af", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
      -- Clear buffer and chat history
      { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
      -- Toggle Copilot Chat Vsplit
      { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
      -- Copilot Chat Models
      { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
      -- Copilot Chat Agents
      { "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
    },
  },
}
