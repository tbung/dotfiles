local Job = require("plenary.job")
M = {}

M.bufferize = function(cmd)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, 0, vim.split(vim.api.nvim_exec(cmd, 1), "\n"))
  vim.api.nvim_buf_set_name(bufnr, cmd)
  vim.cmd([[
  split
  ]])
  vim.api.nvim_win_set_buf(0, bufnr)
end

M.update_ssh_env_from_tmux = function()
  if vim.env.TMUX then
    local _env = Job:new({ command = "tmux", args = { "show-environment" } }):sync()
    local env = {}

    for _, value in pairs(_env) do
      env[vim.split(value, "=")[1]] = vim.split(value, "=")[2]
    end

    vim.env.SSH_AUTH_SOCK = env.SSH_AUTH_SOCK
    vim.env.SSH_CLIENT = env.SSH_CLIENT
    vim.env.SSH_CONNECTION = env.SSH_CONNECTION
    vim.env.DISPLAY = env.DISPLAY
  end
end

--- Sum integers in a table
---@param numbers number[]
---@return number
M.sum = function(numbers)
  local s = 0

  for _, n in ipairs(numbers) do
    s = s + n
  end

  return s
end

--- Sum over yanked numbers, separated by line
M.sum_yanked = function()
  tbl = vim.split(vim.fn.getreg('"0'), "\n")
  tbl = vim.tbl_map(function(x) return tonumber(x) end, tbl)
  tbl = vim.tbl_filter(function(x) return x ~= nil end, tbl)
  return M.sum(tbl)
end

return M
