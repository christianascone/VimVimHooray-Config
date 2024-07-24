return {
  {
    "supermaven-inc/supermaven-nvim",
    lazy = true,
    config = function()
      require("supermaven-nvim").setup({
        keymaps= {
          accept_suggestion = "<C-Enter>"
        }
      })
    end,
  },
}
