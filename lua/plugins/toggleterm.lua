local DIRECTION = "horizontal"

---@type Terminal[]
local term_list = {}

local function createTerms()
  local term = require("toggleterm.terminal").Terminal:new({ direction = DIRECTION })

  table.insert(term_list, term)
  term:toggle()
end

local function popTerm()
  if #term_list <= 0 then
    return
  end

  local last_term = term_list[#term_list]
  last_term:close()

  table.remove(term_list, #term_list)
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    highlights = {
      Normal = { link = "Normal" },
      NormalNC = { link = "NormalNC" },
      NormalFloat = { link = "NormalFloat" },
      FloatBorder = { link = "FloatBorder" },
      StatusLine = { link = "StatusLine" },
      StatusLineNC = { link = "StatusLineNC" },
      WinBar = { link = "WinBar" },
      WinBarNC = { link = "WinBarNC" },
    },
    float_opts = { border = "rounded" },
    shading_factor = 2,
  },
  keys = {
    {
      mode = { "v", "n", "t" },
      "<C-`>",
      "<cmd>ToggleTerm direction=float<cr>",
      desc = "Toggle Terminal",
    },
    {
      mode = { "n", "t" },
      "<F2>",
      createTerms,
      desc = ("Open %s terminal"):format(DIRECTION),
    },
    {
      mode = { "n", "t" },
      "<F3>",
      popTerm,
      desc = "Close last opened terminal",
    },
  },
}
