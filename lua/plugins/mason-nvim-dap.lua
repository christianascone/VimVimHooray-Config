return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "java", "php", "javadbg", "javatest" },
      handlers = {
        php = function(config)
          -- Uncomment this to specify the executable path
          -- local base_path = vim.fn.stdpath("config") -- or vim.fn.getcwd() if you prefer current working directory
          -- config.adapters = {
          --   type = "executable",
          --   command = string.format("%s/LSPs/vscode-php-debug/out/phpDebug.js", base_path),
          -- }
          config.configurations = {
            {
              type = "php",
              request = "launch",
              name = "(default) Listen for Xdebug",
              port = 9003,
            },
            {
              name = "(default) Launch Built-in server",
              type = "php",
              request = "launch",
              program = "",
              runtimeArgs = {
                "-S",
                "localhost:8000",
                "-dxdebug.mode=debug",
                "-dxdebug.start_with_request=yes",
              },
              env = {
                XDEBUG_MODE = "debug",
                XDEBUG_SESSION = "xdebug_is_great",
              },
              port = 9003,
            },
            {
              name = "(default) Launch Built-in server in public (laravel/symfony)",
              type = "php",
              request = "launch",
              program = "",
              runtimeArgs = {
                "-S",
                "localhost:8000",
                "-t",
                "public",
              },
              port = 9003,
            },
            {
              name = "(default) Launch Built-in server in public (laravel/symfony) with debugger",
              type = "php",
              request = "launch",
              program = "",
              runtimeArgs = {
                "-S",
                "localhost:8000",
                "-t",
                "public",
                "-dxdebug.mode=debug",
                "-dxdebug.start_with_request=yes",
              },
              env = {
                XDEBUG_MODE = "debug",
                XDEBUG_SESSION = "xdebug_is_great",
              },
              port = 9003,
            },
            {
              name = "(default) Launch Built-in spark server",
              type = "php",
              request = "launch",
              program = "",
              runtimeArgs = {
                "spark",
                "serve",
                "-dxdebug.mode=debug",
                "-dxdebug.start_with_request=yes",
              },
              env = {
                XDEBUG_MODE = "debug",
                XDEBUG_SESSION = "xdebug_is_great",
              },
              port = 9003,
            },
            {
              name = "(default) Launch phpunit",
              type = "php",
              request = "launch",
              program = "",
              runtimeArgs = {
                "bin/phpunit",
                "-dxdebug.mode=debug",
                "-dxdebug.start_with_request=yes",
              },
              env = {
                XDEBUG_MODE = "debug",
                XDEBUG_SESSION = "xdebug_is_great",
              },
              port = 9003,
            },
          }
          require("mason-nvim-dap").default_setup(config) -- don't forget this!
        end,
      },
    },
  },
}
