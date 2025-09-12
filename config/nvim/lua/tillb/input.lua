local M = {}

---@param opts? vim.ui.input.Opts
---@param on_confirm fun(input?: string)
function M.input(opts, on_confirm)
  opts = opts or {}

  local width = 60

  local text = opts.default or ""

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true,
    {
      focusable = true,
      style = "minimal",
      border = "rounded",
      height = 1,
      width = width,
      relative = "win",
      row = vim.api.nvim_win_get_height(0) / 2 - 1,
      col = vim.api.nvim_win_get_width(0) / 2 - width / 2,
      title = opts.prompt,
    })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
  vim.cmd("startinsert!")

  vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    on_confirm(lines[1])
  end, { buffer = buf })

  vim.keymap.set("n", "<esc>", function()
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    on_confirm(nil)
  end, { buffer = buf })

  vim.keymap.set("n", "q", function()
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    on_confirm(nil)
  end, { buffer = buf })
end

return M
