local M = {}

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

local function lsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end
  local names = vim.tbl_map(function(item)
    return item.name
  end, clients)
  return "%#StatusLineSecondary#" .. table.concat(names, ", ") .. "%#StatusLine#"
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
    "%#StatusLineSecondary#%{% &ruler ? ( &rulerformat == '' ? '%P %-14.(%l,%c%V%)' : &rulerformat ) : '' %}%#StatusLine#",
    "%=",
    vim.diagnostic.status(),
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
