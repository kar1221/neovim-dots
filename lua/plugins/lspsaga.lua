return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({})
  end,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },

  keys = {
    {
      mode = { "n" },
      "<leader>k",
      "<cmd>Lspsaga peek_definition<cr>",
      desc = "Peek Definition",
    },
  },
}
