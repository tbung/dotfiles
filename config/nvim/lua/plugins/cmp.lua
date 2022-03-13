local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" }, -- For luasnip users.
  }, {
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = 'path' },
    { name = "spell" },
    -- {
    --   name = "dictionary",
    --   keyword_length = 2,
    -- },
  }),
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require("cmp-under-comparator").under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline("/", {
--   sources = cmp.config.sources({
--     { name = "nvim_lsp_document_symbol" },
--   }, {
--     { name = "buffer" },
--   }),
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--   sources = cmp.config.sources({
--     { name = "path" },
--   }, {
--     { name = "cmdline" },
--   }),
-- })

-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- require("cmp_dictionary").setup({
--   dic = {
--     ["*"] = { "/usr/lib/aspell/en.dat", "/usr/lib/aspell/de_DE.dat" },
--   },
--   -- The following are default values, so you don't need to write them if you don't want to change them
--   exact = 2,
--   async = true,
--   capacity = 5,
--   debug = false,
-- })

require("luasnip/loaders/from_vscode").lazy_load()
