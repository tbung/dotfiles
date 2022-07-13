local lsp = require("lspconfig")
local Path = require("plenary.path")
local navic = require("nvim-navic")

require("lspkind").init()

local on_attach = function(client, bufnr)
  navic.attach(client, bufnr)
  vim.api.nvim_exec(
    [[
sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
highlight DiagnosticUnderlineError gui=undercurl
highlight DiagnosticUnderlineWarn gui=undercurl
highlight DiagnosticUnderlineInfo gui=undercurl
highlight DiagnosticUnderlineHint gui=undercurl

" autocmd BufEnter *.md lua vim.diagnostic.config({virtual_text = false})
" autocmd BufLeave *.md lua vim.diagnostic.config({virtual_text = true})
]],
    false
  )

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.diagnostics.pylint.with({
      -- method = require("null-ls").methods.DIAGNOSTICS_ON_SAVE,
    }),
    require("null-ls").builtins.formatting.black.with({
      args = { "-" },
    }),
    require("null-ls").builtins.formatting.isort,
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.formatting.shfmt.with({
      extra_args = { "-i", "4" },
    }),

    require("null-ls").builtins.diagnostics.vale.with({
      filetypes = { "markdown" },
    }),

    require("null-ls").builtins.formatting.prettier,
  },
  on_attach = on_attach,
  autostart = true,
  -- capabilities = capabilities,
})

lsp.pyright.setup({
  on_attach = on_attach,
  settings = {
    python = {
      pythonPath = "python",
    },
  },
  capabilities = capabilities,
})

lsp.texlab.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lsp.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lsp.ccls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local function get_lua_runtime()
  local result = {}
  for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
    local lua_path = path .. "/lua/"
    if vim.fn.isdirectory(lua_path) then
      result[lua_path] = true
    end
  end

  -- This loads the `lua` files from nvim into the runtime.
  result[vim.fn.expand("$VIMRUNTIME/lua")] = true

  -- TODO: Figure out how to get these to work...
  --  Maybe we need to ship these instead of putting them in `src`?...
  result[vim.fn.expand("~/build/neovim/src/nvim/lua")] = true

  return result
end

lsp.sumneko_lua.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        library = get_lua_runtime(),
        maxPreload = 10000,
        preloadFileSize = 10000,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = capabilities,
})

require("lspconfig").cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
require("lspconfig").html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
require("lspconfig").jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").rnix.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require("lspconfig").arduino_language_server.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    -- Required
    "arduino-language-server",
    "-cli-config",
    "/home/tillb/.arduino15/arduino-cli.yaml",
    -- Optional
    "-cli",
    "arduino-cli",
    "-clangd",
    "clangd",
    "-fqbn",
    "arduino:samd:mkr1000",
  },
})

require("lspconfig").gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
