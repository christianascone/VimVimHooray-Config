return {
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "jdtls@v1.43.0", "phpactor" }, -- Add your servers here
      })
    end,
  },
}
