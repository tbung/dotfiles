
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
  local ok, Job = pcall(require, "plenary.job")
  if not ok then
    vim.notify("UpdateEnv needs plenary installed", vim.log.levels.ERROR)
  end

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

local is_floating = function(win_id)
  win_id = win_id or vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(win_id)
  if cfg.relative > "" or cfg.external then
    return true
  end
  return false
end

M.close_only_sidebars = function()
  local sidebars = { "neo-tree", "neotest-summary" }
  local windows = vim.fn.getwininfo()
  windows = vim.tbl_filter(function(win)
    return not is_floating(win.winid)
  end, windows)
  local only_sidebars = true
  -- local blocking_fts = {}

  for _, window in ipairs(windows) do
    local bufnr = window.bufnr
    local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
    only_sidebars = vim.tbl_contains(sidebars, ft) and only_sidebars
    -- if not vim.tbl_contains(sidebars, ft) then
    --   blocking_fts[i] = ft
    -- end
  end
  -- vim.notify(vim.inspect(blocking_fts))

  if only_sidebars then
    vim.cmd([[qa!]])
  end
end

M.create_scratch_buf = function(ft)
  local ok, Path = pcall(require, "plenary.path")
  if not ok then
    vim.notify("Scratch needs plenary installed", vim.log.levels.ERROR)
  end

  local tempdir = Path.new(vim.fn.tempname()):parent()
  local path = tempdir / "Scratch"
  vim.cmd([[edit ]] .. path.filename)
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_option(buf, "filetype", ft)
end

return M
