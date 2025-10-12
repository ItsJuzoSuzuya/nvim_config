return {
  "jay-babu/mason-nvim-dap.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  opts = {
    ensure_installed = { "cpptools" }, -- mason name for vscode-cpptools adapter
    handlers = {
      function(config)
        -- All default handlers get passed here
        require("mason-nvim-dap").default_setup(config)
      end,
      cpp = function()
        local dap = require("dap")
        dap.adapters.cpp = {
          type = "executable",
          command = "gdb",
          args = { "--interpreter=dap" },
        }
        dap.configurations.cpp = {
          {
            name = "Launch file",
            type = "cpp",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
        }
      end,
    },
  },
}
