return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
      { "<leader>sn", group = "+noice" },
      { "<leader>s", group = "+search" },
      { "<leader>g", group = "+git" },
      { "<leader>q", group = "+quit/session" },
      { "<leader>t", group = "+terminal" },
    },
  },
}
