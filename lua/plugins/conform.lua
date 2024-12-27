return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Java
        java = { "google-java-format" },
        -- Lua
        lua = { "stylua" },
        -- JavaScript
        javascript = { "prettier" },
        -- TypeScript
        typescript = { "prettier" },
        -- PHP
        php = { "php_cs_fixer" }, -- or any other PHP formatter you prefer
      },
    },
  },
}
