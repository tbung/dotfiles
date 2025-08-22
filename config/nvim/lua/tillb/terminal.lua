local M = {}
local terminals = {}

M.create_terminal = function(id)
  local bufid = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_call(bufid, function()
    vim.cmd("terminal")
  end)

  vim.api.nvim_create_autocmd("BufDelete", { buffer = bufid, callback = function()
    terminals[id] = nil
  end, })

  local channel = vim.api.nvim_get_option_value("channel", { buf = bufid })

  local terminal = { id = id, bufid = bufid, channel = channel, }
  terminals[id] = terminal
  return terminal
end

M.get_terminal = function(id)
  local terminal = terminals[id]

  if not terminal or not vim.api.nvim_buf_is_valid(terminal.bufid) then
    terminal = M.create_terminal(id)
  end

  return terminal
end

M.goto_terminal = function(id)
  if not id then
    vim.ui.select(
      vim.tbl_values(terminals),
      {
        prompt = "Terminal: ",
        kind = "terminals",
        format_item = function(item)
          return tostring(item.id) .. "    " .. vim.api.nvim_buf_get_name(item.bufid)
        end,
      },
      function(selected, idx)
        if selected then
          M.goto_terminal(selected.id)
        end
      end
    )
    return
  end

  local terminal = M.get_terminal(id)
  vim.api.nvim_set_current_buf(terminal.bufid)
end

M.goto_new_terminal = function()
  M.goto_terminal(#terminals + 1)
end

M.terminal_make = function(args)
  local terminal = M.get_terminal(0)
  vim.api.nvim_chan_send(terminal.channel, vim.o.makeprg .. "\n")
  if not args or not args.bang then
    M.goto_terminal(0)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
  end
end

M.edit_makeprg = function()
  local bufid = vim.api.nvim_create_buf(false, true)

  local makeprg = vim.api.nvim_get_option_value("makeprg", { scope = "global" })
  makeprg = vim.split(makeprg, "\n")
  vim.api.nvim_buf_set_lines(bufid, 0, -1, false, makeprg)
  vim.api.nvim_set_option_value("filetype", "sh", { buf = bufid })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = bufid,
    callback = function()
      local makeprg = table.concat(vim.api.nvim_buf_get_lines(bufid, 0, -1, false), "\n")
      vim.opt.makeprg = makeprg
    end,
  })

  local height = 40
  local width = 120
  local winid = vim.api.nvim_open_win(bufid, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    border = "rounded",
  })

  local hl_ns = vim.api.nvim_create_namespace("edit_makeprg")
  vim.api.nvim_win_set_hl_ns(winid, hl_ns)
  local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  vim.api.nvim_set_hl(hl_ns, "Normal", { bg = hl.bg })

  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(winid, true)
  end, { buffer = bufid })
end

return M
