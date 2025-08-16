vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    -- local server_configs = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
    --     :map(function(file)
    --       return vim.fn.fnamemodify(file, ":t:r")
    --     end)
    --     :totable()
    local server_configs = { "lua_ls", "texlab", "basedpyright" }
    vim.lsp.enable(server_configs)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      -- if client.name == "lua_ls" then
      --   client.server_capabilities.completionProvider.triggerCharacters = { "a" }
      -- end
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = false,
        convert = function(item)
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
