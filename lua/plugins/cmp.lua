local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local cmp = require("cmp")
local luasnip = require("luasnip")

local mappings = {
  ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
  ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
  ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if not cmp.visible then
      return
    end

    if luasnip.expandable() then
      luasnip.expand()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif check_backspace() then
      fallback()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<CR>"] = cmp.mapping.confirm({ select = true }),
}

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
  },

  event = "InsertCharPre",

  opts = {

    mapping = mappings,

    sources = {
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 800 },
      { name = "buffer", priority = 100 },
      { name = "path", priority = 500 },
      { name = "nvim_lsp_signature_help" },
    },

    window = {
      completion = {
        col_offset = -4,
        side_padding = 0,
        -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLineBG,Search:None",
        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        border = "rounded",
        winhighlight = "Normal:CmpNormal",
      },
      documentation = {
        -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLineBG,Search:None",
        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        winhighlight = "Normal:CmpNormal",
        border = "rounded",
      },
    },

    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, item)
        local lspkind = require("lspkind")

        local tailwindcss_colorizer_cmp = require("tailwindcss-colorizer-cmp")

        local fmt = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          before = tailwindcss_colorizer_cmp.formatter,
        })(entry, item)

        local strings = vim.split(fmt.kind, "%s", { trimempty = true })

        fmt.kind = " " .. (strings[1] or "") .. " "
        fmt.menu = strings[2] ~= nil and ("  " .. (strings[2] or "")) or ""

        return fmt
      end,
      -- before = require("tailwindcss-colorizer-cmp").formatter,
    },
  },
}
