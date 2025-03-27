return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>?", group = "+help" },
        { "<leader>sn", group = "+noice" },
        { "<leader>s", group = "+search" },
        { "<leader>g", group = "+git" },
        { "<leader>q", group = "+quit/session" },
        { "<leader>t", group = "+terminal" },
        { "<leader>c", group = "+code tools" },
      },
    },
  },
}
