vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = false,
        convert = function(item)
          -- TODO: Proper hl groups
          return { kind_hlgroup = "BlinkCmpKind" .. vim.lsp.protocol.CompletionItemKind[item.kind] }
        end,
      })

      -- NOTE: currently, lsp omnifunc (and lsp.complete.get) opens new pum instead of just getting the items
      -- https://github.com/neovim/neovim/issues/35257
      vim.api.nvim_set_option_value("complete", "o", { buf = args.buf })
      vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = args.buf })
    end
  end,
})
