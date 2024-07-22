return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }

      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.norg" },
        command = "set conceallevel=3",
      })

      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "astro",
        "blade",
        "tsx",
        "lua",
        "typescript",
        "java",
        "html",
        "php",
        "http", --- Needed for rest.nvim
      })
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          scope_incremental = "<CR>",
          node_incremental = "<TAB>",
          node_decremental = "<S-TAB>",
        },
      }
    end,
  },
}
