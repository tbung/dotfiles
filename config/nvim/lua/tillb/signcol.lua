local M = {}

---@return {name:string, text:string, texthl:string}[]
function M.get_signs(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local lnum = vim.v.lnum
  local signs = {}

  if vim.fn.has("nvim-0.10") == 0 then
    -- Only needed for Neovim <0.10
    -- Newer versions include legacy signs in nvim_buf_get_extmarks
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs) do
      local ret = vim.fn.sign_getdefined(sign.name)[1]
      if ret then
        ret.priority = sign.priority
        signs[#signs + 1] = ret
      end
    end
  end

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, extmark in pairs(extmarks) do
    signs[#signs + 1] = {
      name = extmark[4].sign_hl_group or "",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    }
  end

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) < (b.priority or 0)
  end)

  return signs
end

function M.column()
  local win = vim.g.statusline_winid
  if vim.wo[win].signcolumn == "no" then
    return ""
  end
  local sign, git_sign
  for _, s in ipairs(M.get_signs(win)) do
    if s.name:find("GitSign") then
      git_sign = s
    else
      sign = s
    end
  end

  local folded = vim.fn.foldclosed(vim.v.lnum) >= 0
  local has_fold = vim.fn.foldlevel(vim.v.lnum) > vim.fn.foldlevel(vim.v.lnum - 1)

  local nu = " "
  if vim.wo[win].number and vim.wo[win].relativenumber and vim.v.virtnum == 0 then
    nu = vim.v.relnum == 0 and vim.v.lnum .. [[%=]] or ([[%=]] .. vim.v.relnum)
  end

  local components = {
    (sign and ("%#" .. (sign.texthl or "DiagnosticInfo") .. "#" .. sign.text .. "%*"))
    or (folded and vim.opt.fillchars:get().foldclose .. " ")
    or (has_fold and vim.opt.fillchars:get().foldopen .. " ")
    or "  ",
    nu,
    (git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*")) or "  ",
  }
  return table.concat(components, "")
end

return M
