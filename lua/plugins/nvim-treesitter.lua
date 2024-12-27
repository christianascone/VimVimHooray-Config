return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- For additional functionality like textobjects for selection
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parsers you want to ensure are installed (sync with :TSInstall)
        ensure_installed = {
          "blade",
          "c",
          "lua",
          "http",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "python",
          "java",
          "php",
          "html",
          "php_only",
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        -- List of parsers to ignore installing (for "all")
        ignore_install = {},
        highlight = {
          -- `false` will disable the whole extension
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>", -- Enter key for initial selection
            node_incremental = "<Tab>", -- Tab key to expand selection
            scope_incremental = "<S-Tab>", -- Shift-Tab to go to the next scope level (optional)
            node_decremental = "<BS>", -- Backspace to reduce selection
          },
        },
        -- Configuration for textobjects, which can be used for block selection
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              -- You can also use treesitter to create your own textobjects
              -- ["iF"] = "@function.inner",
            },
          },
          -- Move configuration
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      -- Useful tips for tree-sitter-blade
      -- https://github.com/EmranMR/tree-sitter-blade/discussions/19
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "v0.11.0",
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
    end,
  },
}
