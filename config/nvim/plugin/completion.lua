vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("tillb.lsp-autocompletion", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = false,
        convert = function(item)
          -- TODO: Proper hl groups
          if vim.lsp.protocol.CompletionItemKind[item.kind] ~= nil then
            return { kind_hlgroup = "BlinkCmpKind" .. vim.lsp.protocol.CompletionItemKind[item.kind] }
          end

          return {}
        end,
      })

      vim.api.nvim_set_option_value("complete", "o,.,w,b,u", { buf = args.buf })
      vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = args.buf })
    end

    if client:supports_method("textDocument/signatureHelp") then
      require("tillb.signature").enable_autocmds(args.buf, client)
    end
  end,
})

local cmd_group = vim.api.nvim_create_augroup("tillb.cmdline-autocompletion", { clear = true })

---@param cmd string
---@return boolean
local function should_autocomplete(cmdtype, cmd)
  if cmdtype == ":" then
    return vim.regex([[^\(\([fF]in\%[d]\)\|\(b\%[uffer]\)\|\(h\%[elp]\)\|\(P\%[ick]\)\)\s]]):match_str(cmd) and true or
        false
  else
    return cmdtype == "/"
  end
end

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = cmd_group,
  callback = function(ev)
    local cmdtype = vim.fn.getcmdtype()
    local cmdline = vim.fn.getcmdline()

    if should_autocomplete(cmdtype, cmdline) then
      require("tillb.findfunc").refresh()
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
    require("tillb.findfunc").reset()
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
