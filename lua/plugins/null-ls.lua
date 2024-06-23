if true then
  return {}
end

return {
  "nvimtools/none-ls.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },

  opts = function()
    local null_ls = require("null-ls")

    return {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.completion.spell,
      require("none-ls.diagnostics.eslint"),
    }
  end,
}
