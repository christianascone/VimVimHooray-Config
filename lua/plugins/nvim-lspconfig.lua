local Util = require "util.init"
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        jdtls = function()
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              -- Use Mason to get the installation paths
              local jdtls_install = require("mason-registry").get_package("jdtls"):get_install_path()
              local java_debug_install = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
              local java_test_install = require("mason-registry").get_package("java-test"):get_install_path()
              local lombok_path = jdtls_install .. "/lombok.jar"
              local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
              local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name
              -- Determine the platform configuration path
              local platform_config_path
              if vim.fn.has("mac") == 1 then
                platform_config_path = jdtls_install .. "/config_mac"
              elseif vim.fn.has("unix") == 1 then
                platform_config_path = jdtls_install .. "/config_linux"
              else
                platform_config_path = jdtls_install .. "/config_win"
              end
              -- Bundles for Java debugging
              local bundles = {
                vim.fn.glob(java_debug_install .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"),
              }
              vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_install .. "/extension/server/*.jar"), "\n"))
              local config = {
                cmd = {
                  "/usr/bin/java",
                  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                  "-Dosgi.bundles.defaultStartLevel=4",
                  "-Declipse.product=org.eclipse.jdt.ls.core.product",
                  "-Dlog.protocol=true",
                  "-Dlog.level=ALL",
                  "-javaagent:" .. lombok_path,
                  "-Xms1g",
                  "--add-modules=ALL-SYSTEM",
                  "--add-opens",
                  "java.base/java.util=ALL-UNNAMED",
                  "--add-opens",
                  "java.base/java.lang=ALL-UNNAMED",
                  "-jar",
                  vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                  "-configuration",
                  platform_config_path,
                  "-data",
                  workspace_dir,
                },
                root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
                settings = {
                  java = {},
                },
                handlers = {
                  ["language/status"] = function(_, result)
                    -- print(result)
                  end,
                  ["$/progress"] = function(_, result, ctx)
                    -- disable progress updates.
                  end,
                },
                init_options = {
                  bundles = bundles,
                },
                test = true,
              }
              config["on_init"] = function(client, bufnr)
                Util.callDotenv()
              end
              config["on_attach"] = function(client, bufnr)
                require("jdtls").setup_dap({ hotcodereplace = "auto", config_overrides = {} })
                require("jdtls.dap").setup_dap_main_class_configs()
              end
              config["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
              require("jdtls").start_or_attach(config)
            end,
          })
          return true
        end,
      })
    end,
  },
}
