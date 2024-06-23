local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local function is_visible(cmp)
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

local cmp = require("cmp")

local mappings = {
  ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  ["<C-P>"] = cmp.mapping(function()
    if is_visible(cmp) then
      cmp.select_prev_item()
    else
      cmp.complete()
    end
  end),
  ["<C-N>"] = cmp.mapping(function()
    if is_visible(cmp) then
      cmp.select_next_item()
    else
      cmp.complete()
    end
  end),
  ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
  ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
  ["<C-U>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
  ["<C-D>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
  ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
  ["<C-Y>"] = cmp.config.disable,
  ["<C-E>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
  ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
  ["<Tab>"] = cmp.mapping(function(fallback)
    if is_visible(cmp) then
      cmp.select_next_item()
    elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet and vim.snippet.active({ direction = 1 }) then
      vim.schedule(function()
        vim.snippet.jump(1)
      end)
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<S-Tab>"] = cmp.mapping(function(fallback)
    if is_visible(cmp) then
      cmp.select_prev_item()
    elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet and vim.snippet.active({ direction = -1 }) then
      vim.schedule(function()
        vim.snippet.jump(-1)
      end)
    else
      fallback()
    end
  end, { "i", "s" }),
}

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "roobert/tailwindcss-colorizer-cmp.nvim",
  },

  event = "InsertCharPre",

  opts = {

    mapping = mappings,

    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    },

    window = {
      completion = cmp.config.window.bordered({
        col_offset = -4,
        side_padding = 0,
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLineBG,Search:None",
        boreder = "rounded",
      }),
      documentation = cmp.config.window.bordered({
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLineBG,Search:None",
        border = "rounded",
      }),
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
