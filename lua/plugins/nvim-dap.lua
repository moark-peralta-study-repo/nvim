return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local keymap = vim.keymap

    dapui.setup()

    -- Automatically open and close the DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Java debug configuration
    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Launch Java Program",
        mainClass = "${file}",
        projectName = "MyProject",
      },
    }

    -- Keymaps
    keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Debug Toggle Breakpoint" })
    keymap.set("n", "<leader>ds", dap.continue, { desc = "Debug Start" })
    keymap.set("n", "<leader>dx", function()
      dap.terminate()
      dapui.close()
    end, { desc = "Debug Stop & Close UI" })
    keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debug UI" })
  end,
}
