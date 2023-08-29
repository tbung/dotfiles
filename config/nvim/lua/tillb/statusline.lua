local bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg
local bg_win = vim.api.nvim_get_hl(0, { name = "WinBar" }).bg
local hlwin = vim.api.nvim_get_hl(0, { name = "WinBar" })
hlwin.bold = true
vim.api.nvim_set_hl(0, "WinBar", hlwin)

function StatusFileIcon()
  local file_comp = "%#StatusLine#%t %h%m%r"
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  local icon, color = require("nvim-web-devicons").get_icon_color_by_filetype(ft, {})
  if icon ~= nil then
    vim.api.nvim_set_hl(0, "StatusLineIcon", { fg = color, bg = bg })
    return "%#StatusLineIcon#" .. icon .. " " .. file_comp
  end
  return file_comp
end

function WinbarFileIcon()
  local file_comp = "%#WinBar#%f %h%m%r"
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  local icon, color = require("nvim-web-devicons").get_icon_color_by_filetype(ft, {})
  if icon ~= nil then
    vim.api.nvim_set_hl(0, "WinBarIcon", { fg = color, bg = bg_win })
    return "%#WinBarIcon#" .. icon .. " " .. file_comp
  end
  return file_comp
end

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

function StatusDiagnostics()
  local str = ""

  for _, severity in ipairs(severities) do
    local count = #vim.diagnostic.get(0, { severity = severity })
    if count > 0 then
      local sign = vim.fn.sign_getdefined("DiagnosticSign" .. severity)[1]
      if sign ~= nil then
        str = str .. " %#DiagnosticStatus" .. severity .. "#" .. sign.text .. count .. "%#StatusLine#"
      end
    end
  end
  return str
end

local C_fallback = {}
setmetatable(C_fallback, {__index = function() return "#b4befe" end})
local C = require("catppuccin.palettes").get_palette() or C_fallback

local assets = {
  mode_icon = "",
  dir = "",
  file = "",
  lsp = {
    server = "",
  },
  git = {
    branch = "",
  },
}

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

  return "%#StatusMode# " .. assets.mode_icon .. " " .. name .. " %#StatusLine#"
end

function StatusLsp()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local names = vim.tbl_map(function(item)
    return item.name
  end, clients)
  return "%#StatusLineNC#" .. assets.lsp.server .. " " .. table.concat(names, ", ") .. "%#StatusLine#"
end

function StatusGit()
  if vim.b.gitsigns_head then
    return assets.git.branch .. " " .. vim.b.gitsigns_head
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
    [[%l:%c%V]],
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
