return {
  {
    "github/copilot.vim",
    lazy = true,
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set('i', '<C-j>', 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false
      })
    end,
  },
}
