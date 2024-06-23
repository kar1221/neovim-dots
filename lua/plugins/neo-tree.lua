local function is_neo_tree_visible()
  return vim.bo.filetype == "neo-tree"
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>o",
      function()
        if is_neo_tree_visible() then
          vim.cmd.wincmd("p")
        else
          vim.cmd.Neotree("focus")
        end
      end,
      desc = "Focus on neo-tree",
    },
  },
}
