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

    if client:supports_method("textDocument/signatureHelp") then
      vim.api.nvim_create_autocmd({ "TextChangedI", "InsertEnter" }, {
        buffer = args.buf,
        callback = function()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_buf_get_lines(args.buf, row - 1, row, false)[1]
          if not line or line == "" then
            return
          end

          local current_char = line:sub(col, col)

          if (
                vim.tbl_contains(client.server_capabilities.signatureHelpProvider.triggerCharacters, current_char, {})
                or (
                  client.server_capabilities.signatureHelpProvider.retriggerCharacters
                  and vim.tbl_contains(client.server_capabilities.signatureHelpProvider.retriggerCharacters, current_char, {})
                )
              ) then
            require("tillb.signature").signature_help()
          end
        end,
      })
      vim.api.nvim_create_autocmd("CursorMovedI", {
        buffer = args.buf,
        callback = function()
          require("tillb.signature").signature_help()
        end,
      })
      vim.api.nvim_create_autocmd("CompleteChanged", {
        buffer = args.buf,
        callback = function()
          require("tillb.signature").update_pos()
        end,
      })
      vim.api.nvim_create_autocmd({ "ModeChanged", "BufLeave" }, {
        buffer = args.buf,
        callback = function()
          vim.schedule(function()
            local mode = vim.api.nvim_get_mode().mode
            if not mode:match("i") and not mode:match("s") then
              require("tillb.signature").close()
            end
          end)
        end,
      })
    end
  end,
})
