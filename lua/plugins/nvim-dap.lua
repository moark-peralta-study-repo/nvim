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

    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end

    dap.configurations.java = {
      {
        type = "java",
        request = "launch",
        name = "Launch Java Program",
        mainClass = "${file}",
        projectName = "MyProject",
      },
    }

    --Keymaps
    keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Debug Toggle Breakpoint" })
    keymap.set("n", "<leader>ds", dap.continue, { desc = "Debug Start" })
    keymap.set("n", "<leader>dc", dap.close, { desc = "Debug Close" })
  end,
}
