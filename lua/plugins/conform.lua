return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
        lua = { "stylua" },
        dart = { "dart_format" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        php = { "pint" }, -- or any other PHP formatter you prefer
        python = { "black" },
        xml = { "xmlformatter" },
        html = { "htmlbeautifier" },
        bash = { "shfmt" },
        sh = { "shfmt" },
      },
    },
  },
}
