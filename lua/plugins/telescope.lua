return {
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    config = function()
      require("telescope").setup({
        defaults = {
          -- Default configuration for telescope goes here:
          -- set layout, previewer, etc.
          layout_strategy = "horizontal",
          layout_config = { width = 0.8 },
          file_ignore_patterns = { "node_modules" },
          path_display = {
            filename_first = {
              reverse_directories = false,
            },
          },
          prompt_prefix = " ",
          selection_caret = " ",
        },
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--color=never",
              "--glob=!.git/*",
              "--glob=!Library/*",
            },
          },
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
}
