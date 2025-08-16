local M = {}

function M.set_mark(name)
  if name == nil then
    local ok
    ok, name = pcall(function()
      return string.char(vim.fn.getchar())
    end)
    if not ok then
      return
    end
  end

  local win = vim.api.nvim_get_current_win()
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))
  local buf = vim.api.nvim_win_get_buf(win)

  vim.api.nvim_buf_set_mark(buf, name, row, col, {})
  M.update_signs(buf)
end

function M.unset_mark(name)
  if name == nil then
    local ok
    ok, name = pcall(function()
      return string.char(vim.fn.getchar())
    end)
    if not ok then
      return
    end
  end

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)

  local id --- @type number
  if name <= "z" and name >= "a" then
    id = tonumber(buf .. "00" .. string.byte(name)) or 0
  else
    id = string.byte(name)
  end

  vim.api.nvim_buf_del_mark(buf, name)
  vim.api.nvim_buf_del_extmark(buf, vim.api.nvim_create_namespace("marks"), id)
end

function M.update_signs(buf)
  for _, mark in ipairs(vim.fn.getmarklist(buf)) do
    local name = mark.mark:sub(2, 2)
    if name <= "z" and name >= "a" then
      vim.api.nvim_buf_set_extmark(buf, vim.api.nvim_create_namespace("marks"), mark.pos[2] - 1, 0,
        { id = tonumber(buf .. "00" .. string.byte(name)), sign_text = name, priority = 10 })
    end
  end

  for _, mark in ipairs(vim.fn.getmarklist()) do
    local name = mark.mark:sub(2, 2)
    if name <= "Z" and name >= "A" and mark.pos[1] == buf then
      vim.api.nvim_buf_set_extmark(buf, vim.api.nvim_create_namespace("marks"), mark.pos[2] - 1, 0,
        { id = string.byte(name), sign_text = name, priority = 10 })
    end
  end
end

function M.setup_autocmds()
  vim.api.nvim_create_autocmd("BufEnter", { callback = function(args)
    M.update_signs(args.buf)
  end })

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("UserLspFormat", {}),
    callback = function(args)
      M.update_signs(args.buf)
    end,
  })
end

return M
