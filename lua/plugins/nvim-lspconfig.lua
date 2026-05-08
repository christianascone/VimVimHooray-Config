local Util = require("util.init")
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
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "jdtls@v1.58.0", "phpactor", "copilot" },
        automatic_installation = true,
        -- Avoid auto-enabling via vim.lsp.enable() because some default configs
        -- expose nested root_markers that currently break :checkhealth lsp.
        -- We configure/attach servers explicitly below instead.
        automatic_enable = false,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local mlsp = require("mason-lspconfig")
      local servers = {}
      if mlsp.get_installed_servers then
        servers = mlsp.get_installed_servers()
      elseif mlsp.get_installed then
        servers = mlsp.get_installed()
      end

      local function normalize_root_markers(root_markers)
        if type(root_markers) ~= "table" or type(root_markers[1]) ~= "table" then
          return root_markers
        end

        local flattened = {}
        for _, marker in ipairs(root_markers) do
          if type(marker) == "table" then
            for _, nested in ipairs(marker) do
              if type(nested) == "string" and nested ~= "" then
                flattened[#flattened + 1] = nested
              end
            end
          elseif type(marker) == "string" and marker ~= "" then
            flattened[#flattened + 1] = marker
          end
        end
        return flattened
      end

      for _, server_name in ipairs(servers) do
        -- copilot is enabled lazily when sidekick loads
        -- jdtls is managed separately via nvim-jdtls in the FileType autocmd below.
        if server_name ~= "copilot" and server_name ~= "jdtls" then
          if vim.lsp and vim.lsp.config and vim.lsp.enable then
            local existing = vim.lsp.config[server_name]
            local root_markers = existing and existing.root_markers or nil
            vim.lsp.config(server_name, {
              capabilities = capabilities,
              root_markers = normalize_root_markers(root_markers),
            })
            vim.lsp.enable(server_name)
          else
            vim.notify("lspconfig: no handler for " .. server_name, vim.log.levels.DEBUG)
          end
        end
      end

      -- jdtls special handling
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          -- Use Mason to get installation paths, compatible with older/newer APIs.
          local registry = require("mason-registry")
          local mason_settings = require("mason.settings")
          local function get_mason_package_path(package_name)
            local package = registry.get_package(package_name)
            if package and type(package.get_install_path) == "function" then
              return package:get_install_path()
            end
            return mason_settings.current.install_root_dir .. "/packages/" .. package_name
          end

          local jdtls_install = get_mason_package_path("jdtls")
          local java_debug_install = get_mason_package_path("java-debug-adapter")
          local java_test_install = get_mason_package_path("java-test")
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
          -- Bundles for Java debugging/test support.
          local bundles = {}
          vim.list_extend(
            bundles,
            vim.fn.glob(java_debug_install .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", false, true)
          )
          vim.list_extend(bundles, vim.fn.glob(java_test_install .. "/extension/server/*.jar", false, true))
          bundles = vim.tbl_filter(function(bundle)
            return type(bundle) == "string" and bundle ~= ""
          end, bundles)

          local java_bin = vim.fn.exepath("java")
          if java_bin == nil or java_bin == "" then
            java_bin = "/usr/bin/java"
          end
          local config = {
            cmd = {
              java_bin,
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
            vim.keymap.set(
              "n",
              "<leader>dt",
              "<Cmd>lua require'jdtls'.test_class()<CR>",
              { buffer = bufnr, desc = "Test Class" }
            )
            vim.keymap.set(
              "n",
              "<leader>dn",
              "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
              { buffer = bufnr, desc = "Test Nearest Method" }
            )
            vim.keymap.set(
              "n",
              "<leader>cc",
              "<Cmd>lua require('jdtls').compile('full')<CR>",
              { buffer = bufnr, desc = "Compile" }
            )
          end
          config["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
          require("jdtls").start_or_attach(config)
        end,
      })
    end,
  },
}
