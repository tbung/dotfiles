require("neodev").setup()
local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.ensure_installed({
  "arduino_language_server",
  "clangd",
  "pyright",
  "lua_ls",
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
    null_ls.builtins.diagnostics.pylint.with({
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      extra_args = { "--init-hook", 'import warnings; warnings.filterwarnings("ignore")' },
      timeout = 10000,
      condition = function(utils)
        return vim.fn.executable("pylint") > 0
      end,
    }),
    null_ls.builtins.diagnostics.mypy.with({
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      -- args = {
      --   "--hide-error-codes",
      --   "--hide-error-context",
      --   "--no-color-output",
      --   "--show-column-numbers",
      --   "--show-error-codes",
      --   "--no-error-summary",
      --   "--no-pretty",
      --   "--shadow-file",
      --   params.bufname,
      --   params.temp_path,
      --   params.bufname,
      -- },
      timeout = 10000,
      condition = function(utils)
        return vim.fn.executable("mypy") > 0
      end,
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.prettier,
  },
})
lsp.set_preferences({
  set_lsp_keymaps = false,
})

lsp.configure("arduino_language_server", {
  cmd = {
    -- Required
    "arduino-language-server",
    "-clangd",
    "/usr/bin/clangd",
    "-cli",
    "arduino-cli",
    "-cli-config",
    "/home/tillb/.arduino15/arduino-cli.yaml",
  },
})

lsp.configure("texlab", {
  settings = {
    texlab = {
      auxDirectory = "./build",
      build = {
        args = { "-pdf", "-output-directory=./build", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = true,
      },
      latexindent = {
        modifyLineBreaks = true,
      },
      forwardSearch = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "-b", "%l", "%p", "%f" },
      },
    },
  },
})

lsp.configure("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
})

lsp.setup()

local cmp = require('cmp')

cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = false}),
  }
})

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
-- vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>vrn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>vsd", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>vsh", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<leader>va", vim.lsp.buf.code_action, {})
vim.keymap.set("v", "<leader>va", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
