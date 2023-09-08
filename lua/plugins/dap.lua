return {
  {
    "mfussenegger/nvim-dap",
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "php", "java" },
      handlers = {
        php = function(config)
          config.adapters = {
            type = "executable",
            command = "node",
            args = { "/Applications/LSPs/vscode-php-debug/out/phpDebug.js" },
          }
          config.configurations = {
            {
              type = "php",
              request = "launch",
              name = "Listen for Xdebug",
              port = 9003,
            },
          }
          require("mason-nvim-dap").default_setup(config) -- don't forget this!
        end,
      },
    },
  },
}
