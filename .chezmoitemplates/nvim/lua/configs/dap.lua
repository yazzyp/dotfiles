return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "Cliffback/netcoredbg-macOS-arm64.nvim",
      "mfussenegger/nvim-dap-python",
    },
    event = "BufReadPost",
    config = function()
      local dap = require "dap"
      local ui = require "dapui"
      local dap_virtual_text = require "nvim-dap-virtual-text"

      -- Set up netcoredbg to work on macOS arm64
      local original_netcore_setup = require("netcoredbg-macOS-arm64").setup
      require("netcoredbg-macOS-arm64").setup = function(dap)
        original_netcore_setup(dap)

        local function dotnet_build_project()
          local default_path = vim.fn.getcwd() .. "/"
          if vim.g["dotnet_last_proj_path"] ~= nil then
            default_path = vim.g["dotnet_last_proj_path"]
          end
          local path = vim.fn.input("Path to your *proj file", default_path, "file")
          vim.g["dotnet_last_proj_path"] = path
          local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
          print ""
          print("Cmd to execute: " .. cmd)
          local f = os.execute(cmd)
          if f == 0 then
            print "\nBuild: ✔️ "
          else
            print("\nBuild: ❌ (code: " .. f .. ")")
          end
        end

        local function getCurrentFileDirName()
          local fullPath = vim.fn.expand "%:p:h" -- Get the full path of the directory containing the current file
          local dirName = fullPath:match "([^/\\]+)$" -- Extract the directory name
          return dirName
        end

        local function file_exists(name)
          local f = io.open(name, "r")
          if f ~= nil then
            io.close(f)
            return true
          else
            return false
          end
        end

        local function get_dll_path()
          local debugPath = vim.fn.expand "%:p:h" .. "/bin/Debug"
          if not file_exists(debugPath) then
            return vim.fn.getcwd()
          end
          local command = 'find "' .. debugPath .. '" -maxdepth 1 -type d -name "*net*" -print -quit'
          local handle = io.popen(command)
          local result = handle:read "*a"
          handle:close()
          result = result:gsub("[\r\n]+$", "") -- Remove trailing newline and carriage return
          if result == "" then
            return debugPath
          else
            local potentialDllPath = result .. "/" .. getCurrentFileDirName() .. ".dll"
            if file_exists(potentialDllPath) then
              return potentialDllPath
            else
              return result == "" and debugPath or result .. "/"
            end
            --        return result .. '/' -- Adds a trailing slash if a net folder is found
          end
        end

        dap.configurations.cs = {
          {
            type = "coreclr",
            name = "NetCoreDbg: Launch",
            request = "launch",
            cwd = "${fileDirname}",
            preLaunchTask = function()
              if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
                dotnet_build_project()
              end
            end,
            program = function()
              return vim.fn.input("Path to dll", get_dll_path(), "file")
            end,
            env = {
              ASPNETCORE_ENVIRONMENT = function()
                return vim.fn.input("ASPNETCORE_ENVIRONMENT: ", "Development")
              end,
              ASPNETCORE_URL = function()
                return vim.fn.input("ASPNETCORE_URL: ", "http://localhost:5000")
              end,
            },
          },
        }
      end

      require("netcoredbg-macOS-arm64").setup(require "dap")

      require("dapui").setup()

      -- to print current variables inline
      dap_virtual_text.setup {
        enabled = true, -- Enable virtual text
        highlight_changed_variables = true, -- Highlight changed variables
        highlight_new_as_changed = true, -- Highlight new variables as changed
      }

      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" }
      )
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
      vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
      -- Define the highlight group for the line highlight
      vim.cmd [[
        highlight DapStoppedLine guibg=#555555
      ]]
      -- Define the highlight group for the breakpoint sign
      vim.cmd [[
        highlight DapBreakpoint guifg=#FF0000
      ]]
      -- Define the highlight group for the conditional breakpoint sign
      vim.cmd [[
        highlight DapBreakpointCondition guifg=#CC5500
      ]]

      vim.keymap.set("n", "<space>pp", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<space>pc", dap.run_to_cursor, { desc = "Run debugging to cursor" })
      vim.keymap.set("n", "<space>po", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Set conditional breakpoint" })

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end, { desc = "Eval var under cursor" })

      vim.keymap.set("n", "<F1>", dap.continue, { desc = "Start/Continue debugging" })
      vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Step back" })
      vim.keymap.set("n", "<F9>", ui.close, { desc = "Close DAP UI" })
      vim.keymap.set("n", "<F10>", dap.terminate, { desc = "Terminate debugging session" })
      vim.keymap.set("n", "<F12>", dap.restart, { desc = "Restart" })
      vim.keymap.set("n", "<F6>", function ()
        ui.open({reset = true})
      end, { desc = "Reset UI display" })
      vim.keymap.set("n", "<F7>", dap.focus_frame, { desc = "Jump to current execution point" })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   ui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   ui.close()
      -- end


      local dap_python = require("dap-python")
      dap_python.setup("python3")

      -- Function to find the project root directory
      local function get_project_root()
        local markers = {".git", "setup.py", "pyproject.toml", "requirements.txt"}
        local cwd = vim.fn.getcwd()
        for _, marker in ipairs(markers) do
          local root = vim.fn.finddir(marker, cwd .. ";")
          if root ~= "" then
            return vim.fn.fnamemodify(root, ":h")
          end
        end
        return cwd
      end

      -- Force project root as cwd for all Python configurations
      for _, config in pairs(dap.configurations.python or {}) do
        config.cwd = get_project_root
      end

      table.insert(require('dap').configurations.python, {
        type = "python",
        request = "launch",
        name = "src:module:args",
        module = function()
          local file = vim.fn.expand('%:p') -- Get the full path of the current file
          local src_index = file:find("/src/")
          if src_index then
            local relative_path = file:sub(src_index + 5) -- Get the path after 'src/'
            local module_path = relative_path:gsub("/", "."):gsub("%.py$", "") -- Replace '/' with '.' and remove '.lua' extension
            return "src." .. module_path
          else
            return nil -- Handle the case where 'src' is not in the path
          end
        end,
        cwd = get_project_root,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          local utils = require("dap.utils")
          if utils.splitstr and vim.fn.has("nvim-0.10") == 1 then
            return utils.splitstr(args_string)
          end
          return vim.split(args_string, " +")
        end;
      })

    end,
  },
}
