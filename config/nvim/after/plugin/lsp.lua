local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.ensure_installed({
  "arduino_language_server",
  "clangd",
  "pyright",
  "sumneko_lua",
  "texlab",
})

lsp.nvim_workspace()

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})
require("mason-tool-installer").setup({
  ensure_installed = {
    "black",
    "codelldb",
    "isort",
    "stylua",
  },
})

null_ls.setup({
  on_attach = null_opts.on_attach,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
  },
})
lsp.set_preferences({
  set_lsp_keymaps = false,
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = true,
})

vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineError",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineError", true).special }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineWarn",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineWarn", true).special }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineInfo",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineInfo", true).special }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineHint",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineHint", true).special }
)

vim.cmd([[sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=]])

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>vf", function()
  vim.lsp.buf.format({
    filter = function(client)
      -- always use stylua to format
      return client.name ~= "sumneko_lua"
    end,
  })
end, {})
vim.keymap.set("n", "<leader>vh", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>vsd", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>vsh", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<leader>va", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
