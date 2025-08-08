return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "google-java-format",
        "prettierd",
        "stylua",
        "pint",
        "php_cs_fixer",
        "java-debug-adapter",
        "java-test",
        "jdtls"
      },
    },
    config = function()
      require("mason").setup()
    end,
  },
}
