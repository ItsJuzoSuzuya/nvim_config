return {
  "jay-babu/mason-nvim-dap.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  opts = {
    ensure_installed = {}, -- no unsupported cpptools entry
    handlers = {
      function(config)
        require("mason-nvim-dap").default_setup(config)
      end,
    },
  },
  config = function(_, opts)
    local dap = require("dap")

    -- GDB native DAP
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
}
