local M = {}

local hl_severity = {
  [vim.diagnostic.severity.ERROR] = "Error",
  [vim.diagnostic.severity.WARN] = "Warn",
  [vim.diagnostic.severity.INFO] = "Info",
  [vim.diagnostic.severity.HINT] = "Hint",
}

---@param ft string
---@return string|nil, string|nil
local function get_icon(ft)
  local ok, devicons = pcall(require, "mini.icons")

  if not ok then
    return nil, nil
  end

  local icon, hl, _ = devicons.get("filetype", ft)
  return icon, hl
end

local ft_icon = {}
setmetatable(ft_icon, {
  __index = function(t, k)
    local icon, hl = get_icon(k)
    t[k] = { icon, hl }
    return { icon, hl }
  end,
})


local function cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  local user_signs = vim.tbl_get(vim.diagnostic.config() --[[@as vim.diagnostic.Opts]], "signs", "text") or {}
  local signs = vim.tbl_extend("keep", user_signs, { "E", "W", "I", "H" })
  local result_str = vim
      .iter(pairs(counts))
      :map(function(severity, count)
        return ("%%#DiagnosticSign%s#%s%s%%#StatusLine#"):format(hl_severity[severity], signs[severity], count)
      end)
      :join(" ")

  return result_str
end

local function lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end
  local names = vim.tbl_map(function(item)
    return item.name
  end, clients)
  return "%#StatusLineNC#" .. table.concat(names, ", ") .. "%#StatusLine#"
end

local function git()
  if vim.b.gitsigns_head then
    local icon, _ = unpack(ft_icon["git"])
    return icon .. " " .. vim.b.gitsigns_head
  end
  return ""
end

function M.statusline()
  return table.concat({
    "%<" .. cwd(),
    "%h%w%m%r",
    "%#StatusLineNC#%{% &ruler ? ( &rulerformat == '' ? '%P %-14.(%l,%c%V%)' : &rulerformat ) : '' %}%#StatusLine#",
    "%=",
    diagnostics(),
    "%=",
    lsp(),
    " ",
    git(),
  }, " ")
end

function M.winbar()
  return "%#WinBar#" .. vim.fn.expand("%:.") .. " %h%m%r"
end

return M
