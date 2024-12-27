return {
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    keys = {
      -- { "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      -- { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
    opts = {
      bg_x_padding = 50,
      bg_y_padding = 30,
      watermark = '',
      save_path = "~/Pictures",
      has_breadcrumbs = true,
      bg_theme = "bamboo",
    },
  },
}
