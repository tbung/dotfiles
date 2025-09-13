vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("tillb.lsp-autocompletion", {}),
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

local cmd_group = vim.api.nvim_create_augroup("tillb.cmdline-autocompletion", {})

---@param cmd string
---@return boolean
local function should_autocomplete(cmdtype, cmd)
  if cmdtype == ":" then
    return vim.regex([[^\(\([fF]in\%[d]\)\|\(b\%[uffer]\)\|\(h\%[elp]\)\)\s]]):match_str(cmd) and true or false
  else
    return cmdtype == "/"
  end
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = cmd_group,
  pattern = ":",
  callback = function(ev)
    require("tillb.findfunc").refresh()
  end,
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = cmd_group,
  callback = function(ev)
    local cmdtype = vim.fn.getcmdtype()
    local cmdline = vim.fn.getcmdline()

    if should_autocomplete(cmdtype, cmdline) then
      vim.o.wildmode = "noselect:lastused,full"
      vim.fn.wildtrigger()
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = cmd_group,
  pattern = ":",
  callback = function(ev)
    vim.o.wildmode = "longest:full,full"
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeavePre", {
  group = cmd_group,
  pattern = ":",
  callback = function(ev)
    local info = vim.fn.cmdcomplete_info()
    if info.matches == nil then
      return
    end

    local cmdline = vim.fn.getcmdline()
    local cmdline_cmd = vim.fn.split(cmdline, " ")[1]

    if should_autocomplete(":", cmdline) and info.selected == -1 then
      vim.fn.setcmdline(cmdline_cmd .. " " .. info.matches[1])
    end
  end,
})
