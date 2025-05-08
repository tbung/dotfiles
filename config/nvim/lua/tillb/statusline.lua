local severities = { "Error", "Warn", "Info", "Hint" }

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
  local str = ""

  local signs = vim.diagnostic.config().signs
  if type(signs) == "table" then
    signs = signs.text
  elseif type(signs) == "boolean" then
    signs = { "E", "W", "I", "H" }
  elseif type(signs) == "function" then
    signs = signs(0, 0).text
  else
    signs = nil
  end

  for i, severity in ipairs(severities) do
    local count = #vim.diagnostic.get(0, { severity = i })
    if count > 0 then
      if signs ~= nil then
        local sign = signs[i]
        str = str .. " %#DiagnosticSign" .. severity .. "#" .. sign .. count .. "%#StatusLine#"
      end
    end
  end
  return str
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

function Statusline()
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

function Winbar()
  return "%#WinBar#" .. vim.fn.expand("%:.") .. " %h%m%r"
end

vim.opt.statusline = [[%<%{%v:lua.Statusline()%}]]
vim.opt.winbar = [[%<%{%v:lua.Winbar()%}]]
