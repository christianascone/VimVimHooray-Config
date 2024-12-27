return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "google-java-format",
        "stylua",
        "pint",
        "php_cs_fixer",
        "java-debug-adapter",
        "java-test",
      },
    },
    config = function()
      require("mason").setup()
    end,
  },
}
