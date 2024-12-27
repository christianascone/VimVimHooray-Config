return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
        lua = { "stylua" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        json = { "prettierd" },
        php = { "php_cs_fixer" }, -- or any other PHP formatter you prefer
      },
    },
  },
}
