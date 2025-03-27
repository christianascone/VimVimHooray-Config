return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      { "tpope/vim-dotenv" },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    config = function()
      local M = {}
      -- Run Dotenv in order to read configuration strings
      vim.cmd("Dotenv .dadbod_env")
      local function db_completion()
        require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
      end
      function M.setup()
        vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"
        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "sql",
          },
          command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
        })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = {
            "sql",
            "mysql",
            "plsql",
          },
          callback = function()
            vim.schedule(db_completion)
          end,
        })
      end
      return M
    end,
  },
}
