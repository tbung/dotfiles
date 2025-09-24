-- Liberated from vim.lsb.buf.signature_help

local ms = require("vim.lsp.protocol").Methods
local sig_help_ns = vim.api.nvim_create_namespace("tillb.signature_help")

local M = {}

---@class tillb.signature.Window
---@field id number?
---@field bufid number?
local win = { bufid = nil, id = nil }

local function client_positional_params(params)
  local winid = vim.api.nvim_get_current_win()
  return function(client)
    local ret = vim.lsp.util.make_position_params(winid, client.offset_encoding)
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

---@class tillb.signature.Space
---@field up integer
---@field down integer

---@return tillb.signature.Space
local function get_free_space()
  local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  local pos = vim.fn.screenpos(0, cursor_line, cursor_col)
  return { up = pos.row - 1, down = vim.o.lines - pos.row }
end

function M.update_pos()
  if not win.id or not vim.api.nvim_win_is_valid(win.id) then
    return
  end

  local space = get_free_space()

  local popupmenu_is_up = false
  local popupmenu_pos = vim.fn.pum_getpos()
  if popupmenu_pos.row ~= nil then
    local cursor_screen_row = vim.fn.winline()
    popupmenu_is_up = popupmenu_pos.row - cursor_screen_row < 0
  end

  local offset_y
  local anchor
  local height
  if (not popupmenu_pos and space.down >= space.up) or popupmenu_is_up then
    offset_y = 1
    anchor = "NW"
    height = math.min(vim.api.nvim_win_get_height(win.id), space.down, 10)
  else
    anchor = "SW"
    offset_y = 0
    height = math.min(vim.api.nvim_win_get_height(win.id), space.up, 10)
  end

  vim.api.nvim_win_set_config(win.id,
    { relative = "cursor", anchor = anchor, row = offset_y, col = 0, height = height, zindex = 1000 })
end

function M.close()
  if win.id and vim.api.nvim_win_is_valid(win.id) then
    vim.api.nvim_win_close(win.id, true)
  end
end

return M
