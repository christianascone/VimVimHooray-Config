return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local Config = require("config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
    dependencies = {
      {
        "nvim-neotest/nvim-nio",
      },
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<leader>du",
            function()
              require("dapui").toggle({})
            end,
            desc = "Dap UI",
          },
          {
            "<leader>dE",
            function()
              require("dapui").eval()
            end,
            desc = "Eval",
            mode = { "n", "v" },
          },
        },
        opts = {},
        config = function(_, opts)
          -- setup dap config by VsCode launch.json file
          -- require("dap.ext.vscode").load_launchjs()
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      -- virtual text for the debugger
      { -- plugin
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      { -- plugin
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
    },
  },
}
