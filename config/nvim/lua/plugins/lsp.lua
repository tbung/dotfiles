local lsp = require("lspconfig")
local Path = require("plenary.path")

require("lspkind").init()

local on_attach = function(client, bufnr)
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

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.diagnostics.pylint.with({
      extra_args = { "--max-line-length", "99" },
      method = require("null-ls").methods.DIAGNOSTICS_ON_SAVE,
    }),
    require("null-ls").builtins.formatting.black.with({
      args = { "-" },
    }),
    require("null-ls").builtins.formatting.isort,
    require("null-ls").builtins.formatting.stylua,

    require("null-ls").builtins.diagnostics.misspell.with({
      filetypes = { "tex", "markdown" },
    }),
    require("null-ls").builtins.diagnostics.write_good.with({
      filetypes = { "tex", "markdown" },
    }),
    require("null-ls").builtins.diagnostics.proselint.with({
      filetypes = { "tex", "markdown" },
    }),
    require("null-ls").builtins.formatting.prettier,
  },
  on_attach = on_attach,
  autostart = true,
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

lsp.pyright.setup({
  on_attach = on_attach,
  settings = {
    python = {
      pythonPath = "python",
    },
  },
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

lsp.texlab.setup({
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

lsp.tsserver.setup({
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

lsp.ccls.setup({
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
  -- This assume lls is install like it is on arch, where this bin is
  -- actually a wrapper script, see
  -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
  -- for alternative with manual install
  -- cmd = { "~/.local/share/nvim/lsp_servers/sumneko_lua" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        -- path = runtime_path,
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
      -- workspace = {
      --   -- Make the server aware of Neovim runtime files
      --   library = vim.api.nvim_get_runtime_file("", true),
      --   -- library = {
      --   --   [vim.fn.expand("$VIMRUNTIME/lua")] = true,
      --   --   [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
      --   --   [vim.fn.expand("~/.hammerspoon/Spoons/EmmyLua.spoon/annotations")] = true,
      --   -- },
      -- },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

require("lspconfig").cssls.setup({
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})
require("lspconfig").html.setup({
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})
require("lspconfig").jsonls.setup({
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

require("lspconfig").rnix.setup({
  capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})
-- require("grammar-guard").init()
-- lsp.grammar_guard.setup({
--   cmd = { vim.fn.stdpath("data") .. "/lsp_servers/ltex/ltex-ls/bin/ltex-ls" },
--   settings = {
--     ltex = {
--       enabled = { "latex", "tex", "bib", "markdown", "markdown.pandoc" },
--       dictionary = {
--         ["en-US"] = Path:new(vim.fn.stdpath("config") .. "/spell/en.utf-8.add"):readlines(),
--       },
--     },
--   },
--   on_attach = on_attach,
--   capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
-- })
--
-- function update_ltex()
--   local util = require("lspconfig.util")
--   local bufnr = vim.api.nvim_get_current_buf()
--   local client = util.get_active_client_by_name(bufnr, "grammar_guard")
--   client.config.settings.ltex.dictionary["en-US"] = vim.tbl_extend(
--     "force",
--     client.config.settings.ltex.dictionary["en-US"],
--     Path:new(vim.fn.stdpath("config") .. "/spell/en.utf-8.add"):readlines()
--   )
--   client.notify("workspace/didChangeConfiguration", {
--     settings = client.config.settings,
--   })
-- end
