return {
  { "oxfist/night-owl.nvim", lazy = true, name = "night-owl" },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    config = function(_, opts)
      opts.color_overrides = {
        mocha = {
          base = "#011627", -- Background as night-owl Background
          mantle = "#011627", -- Mantle as night-owl Background
        },
      }
      require("catppuccin").setup(opts)
    end,
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
}
