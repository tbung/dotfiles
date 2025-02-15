local bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
local bg_win = vim.api.nvim_get_hl(0, { name = "WinBar" }).bg

local severities = {
  "Error",
  "Warn",
  "Info",
  "Hint",
}

for _, severity in ipairs(severities) do
  local fg = vim.api.nvim_get_hl(0, { name = "DiagnosticSign" .. severity }).fg
  vim.api.nvim_set_hl(0, "DiagnosticStatus" .. severity, { fg = fg, bg = bg })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
    bg_win = vim.api.nvim_get_hl(0, { name = "WinBar" }).bg
    for _, severity in ipairs(severities) do
      local fg = vim.api.nvim_get_hl(0, { name = "DiagnosticSign" .. severity }).fg
      vim.api.nvim_set_hl(0, "DiagnosticStatus" .. severity, { fg = fg, bg = bg })
    end
  end,
})

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

function StatusFileIcon()
  local file_comp = "%#StatusLine#%t %h%m%r"
  local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  local icon, hl = unpack(ft_icon[ft])
  if icon ~= nil then
    local fg = vim.api.nvim_get_hl(0, { name = hl }).fg
    vim.api.nvim_set_hl(0, "StatusLineIcon", { fg = fg, bg = bg })
    return "%#StatusLineIcon#" .. icon .. " " .. file_comp
  end
  return file_comp
end

function WinbarFileIcon()
  local file_comp = "%#WinBar#%f %h%m%r"
  local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  local icon, hl = unpack(ft_icon[ft])
  if icon ~= nil then
    local fg = vim.api.nvim_get_hl(0, { name = hl }).fg
    vim.api.nvim_set_hl(0, "WinBarIcon", { fg = fg, bg = bg_win })
    return "%#WinBarIcon#" .. icon .. " " .. file_comp
  end
  return file_comp
end

function StatusDiagnostics()
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
        str = str .. " %#DiagnosticStatus" .. severity .. "#" .. sign .. count .. "%#StatusLine#"
      end
    end
  end
  return str
end

local C_fallback = {}
setmetatable(C_fallback, {
  __index = function()
    return "#b4befe"
  end,
})
local ok, C = pcall(require, "catppuccin.palettes")
if not ok or C == nil then
  C = C_fallback
else
  C = C.get_palette()
end

local mode_colors = {
  ["n"] = { "NORMAL", C.lavender },
  ["no"] = { "N-PENDING", C.lavender },
  ["nt"] = { "NORMAL", C.lavender },
  ["niI"] = { "I-NORMAL", C.lavender },
  ["i"] = { "INSERT", C.green },
  ["ic"] = { "INSERT", C.green },
  ["t"] = { "TERMINAL", C.green },
  ["v"] = { "VISUAL", C.flamingo },
  ["V"] = { "V-LINE", C.flamingo },
  [""] = { "V-BLOCK", C.flamingo },
  ["R"] = { "REPLACE", C.maroon },
  ["Rv"] = { "V-REPLACE", C.maroon },
  ["s"] = { "SELECT", C.maroon },
  ["S"] = { "S-LINE", C.maroon },
  [""] = { "S-BLOCK", C.maroon },
  ["c"] = { "COMMAND", C.peach },
  ["cv"] = { "COMMAND", C.peach },
  ["ce"] = { "COMMAND", C.peach },
  ["r"] = { "PROMPT", C.teal },
  ["rm"] = { "MORE", C.teal },
  ["r?"] = { "CONFIRM", C.mauve },
  ["!"] = { "SHELL", C.green },
}

function StatusMode()
  local mode = vim.api.nvim_get_mode()

  if mode_colors[mode.mode] == nil then
    print('Unhandled mode "' .. mode .. '" encountered in statusline')
  end

  local name = (mode_colors[mode.mode] or { "NORMAL", C.lavender })[1]
  local color = (mode_colors[mode.mode] or { "NORMAL", C.lavender })[2]
  vim.api.nvim_set_hl(0, "StatusMode", { fg = C.surface0, bg = color, bold = true })
  return "%#StatusMode# " .. name .. " %#StatusLine#"
end

function StatusLsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end
  local names = vim.tbl_map(function(item)
    return item.name
  end, clients)
  return "%#StatusLineNC#" .. table.concat(names, ", ") .. "%#StatusLine#"
end

function StatusGit()
  if vim.b.gitsigns_head then
    local icon, _ = unpack(ft_icon["git"])
    return icon .. " " .. vim.b.gitsigns_head
  end
  return ""
end

local function wrap(funcName)
  return [[%{%luaeval("]] .. funcName .. [[()")%}]]
end

local statusline = {
  table.concat({
    wrap("StatusMode"),
    wrap("StatusFileIcon"),
    [[ %P ]],
    [[%-14.(%l:%c%V%)]], -- %V does not show up if %V==%c so fix the width of the entire %(...%) group
  }, " "),
  wrap("StatusDiagnostics"),
  table.concat({
    wrap("StatusLsp"),
    [[ ]],
    wrap("StatusGit"),
  }, " "),
}

vim.opt.statusline = table.concat(statusline, "%=")

vim.opt.winbar = [[%<%{%luaeval("WinbarFileIcon()")%}]]
