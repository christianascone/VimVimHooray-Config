return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
        lua = { "stylua" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        php = { "pint" }, -- or any other PHP formatter you prefer
      },
    },
  },
}
