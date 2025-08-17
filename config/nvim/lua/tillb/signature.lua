-- Liberated from vim.lsb.buf.signature_help

local ms = require("vim.lsp.protocol").Methods
local sig_help_ns = vim.api.nvim_create_namespace("tillb.signature_help")

local M = {}

---@class Window
---@field id number?
---@field bufid number?
local win = { bufid = nil, id = nil }

local function client_positional_params(params)
  local win = vim.api.nvim_get_current_win()
  return function(client)
    local ret = vim.lsp.util.make_position_params(win, client.offset_encoding)
    if params then
      ret = vim.tbl_extend("force", ret, params)
    end
    return ret
  end
end

--- @param results table<integer,{err: lsp.ResponseError?, result: lsp.SignatureHelp?}>
local function process_signature_help_results(results)
  local signatures = {} --- @type [vim.lsp.Client,lsp.SignatureInformation][]
  local active_signature = 1

  -- Pre-process results
  for client_id, r in pairs(results) do
    local err = r.err
    local client = assert(vim.lsp.get_client_by_id(client_id))
    if err then
      vim.notify(
        client.name .. ": " .. tostring(err.code) .. ": " .. err.message,
        vim.log.levels.ERROR
      )
      vim.api.nvim_command("redraw")
    else
      local result = r.result
      if result and result.signatures then
        for i, sig in ipairs(result.signatures) do
          sig.activeParameter = sig.activeParameter or result.activeParameter
          local idx = #signatures + 1
          if (result.activeSignature or 0) + 1 == i then
            active_signature = idx
          end
          signatures[idx] = { client, sig }
        end
      end
    end
  end

  return signatures, active_signature
end

function M.signature_help()
  local method = ms.textDocument_signatureHelp

  vim.lsp.buf_request_all(0, method, client_positional_params(), function(results, ctx)
    if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
      -- Ignore result since buffer changed. This happens for slow language servers.
      return
    end

    local signatures, active_signature = process_signature_help_results(results)

    if not next(signatures) then
      -- vim.notify("No signature help available", vim.log.levels.INFO)
      require("tillb.signature").close()
      return
    end

    local ft = vim.bo[ctx.bufnr].filetype
    local total = #signatures
    local idx = active_signature - 1

    --- @param update_win? integer
    local function show_signature(update_win)
      idx = (idx % total) + 1
      local client, result = signatures[idx][1], signatures[idx][2]
      --- @type string[]?
      local triggers =
          vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "triggerCharacters")
      result.documentation = nil
      local lines, hl =
          vim.lsp.util.convert_signature_help_to_markdown_lines({ signatures = { result } }, ft, triggers)
      if not lines then
        return
      end

      local buf, win = vim.lsp.util.open_floating_preview(lines, "markdown",
        { max_width = 100, max_height = 10, relative = "cursor", offset_x = 0, offset_y = 0, close_events = {} })

      if hl then
        vim.api.nvim_buf_clear_namespace(buf, sig_help_ns, 0, -1)
        vim.hl.range(
          buf,
          sig_help_ns,
          "LspSignatureActiveParameter",
          { hl[1], hl[2] },
          { hl[3], hl[4] }
        )
      end
      return buf, win
    end

    local fbuf, fwin = show_signature()
    win.bufid = fbuf
    win.id = fwin
    M.update_pos()
  end)
end

function M.update_pos()
  if not win.id or not vim.api.nvim_win_is_valid(win.id) then
    return
  end

  local offset_y = 1
  local anchor = "NW"

  local popupmenu_pos = vim.fn.pum_getpos()
  if popupmenu_pos.row ~= nil then
    local cursor_screen_row = vim.fn.winline()
    local popupmenu_is_up = popupmenu_pos.row - cursor_screen_row < 0
    if not popupmenu_is_up then
      anchor = "SW"
      offset_y = 0
    end
  end

  vim.api.nvim_win_set_config(win.id, { relative = "cursor", anchor = anchor, row = offset_y, col = 0 })
end

function M.close()
  if win.id and vim.api.nvim_win_is_valid(win.id) then
    vim.api.nvim_win_close(win.id, true)
  end
end

return M
