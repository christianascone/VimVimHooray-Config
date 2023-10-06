return {
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          ["java.javadoc"] = require("neogen.configurations.java"),
        },
      })
    end,
  },
}
