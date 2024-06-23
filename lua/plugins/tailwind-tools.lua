-- tailwind-tools.lua
return {
  "luckasRanarison/tailwind-tools.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    document_color = {
      kind = "background",
    },
    conceal = {
      enabled = true,
    },
  }, -- your configuration
}
