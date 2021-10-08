local lsp = require('lspconfig')

require('lspkind').init()

local on_attach = function(client, bufnr)
  vim.api.nvim_exec([[
    sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
    sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
    sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
    sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
    highlight DiagnosticUnderlineError gui=undercurl
    highlight DiagnosticUnderlineWarn gui=undercurl
    highlight DiagnosticUnderlineInfo gui=undercurl
    highlight DiagnosticUnderlineHint gui=undercurl
  ]], false)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightRed guifg=black
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightRed guifg=black
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightRed guifg=black
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  require'lsp_signature'.on_attach()
end

require("null-ls").config({
    sources = {
        require("null-ls").builtins.diagnostics.flake8.with({
            extra_args = {"--max-line-length", "89"}
        }),
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.formatting.isort,
    }
})
require("lspconfig")["null-ls"].setup({
    on_attach = on_attach,
    autostart = true
})

lsp.pyright.setup{
    on_attach = on_attach,
    settings = {
        python = {
            pythonPath = "python"
        }
    }
}

lsp.texlab.setup{
    on_attach = on_attach,
    -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
lsp.tsserver.setup{
    on_attach = on_attach,
    -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
lsp.ccls.setup{
    on_attach = on_attach,
    -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
lsp.sumneko_lua.setup{
    on_attach = on_attach,
    -- This assume lls is install like it is on arch, where this bin is
    -- actually a wrapper script, see
    -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
    -- for alternative with manual install
    cmd = {"/usr/bin/lua-language-server"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

