vim.cmd.runtime("colors/default.vim")

for _, hl_name in ipairs({ "Normal", "NonText", "EndOfBuffer" }) do
  local hl = vim.api.nvim_get_hl(0, { name = hl_name })
  hl.bg = nil
  vim.api.nvim_set_hl(0, hl_name, hl)
end

if vim.go.background == "dark" then
  vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "DarkGrey", default = true, })
elseif vim.go.background == "light" then
end

for _, severity in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
  local hl = vim.api.nvim_get_hl(0, { name = "DiagnosticUnderline" .. severity })
  hl.underline = nil
  hl.undercurl = true
  vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. severity, hl)
end

vim.api.nvim_set_hl(0, "WinBar", { fg = nil, bold = true, bg = nil })
vim.api.nvim_set_hl(0, "WinBarNC", { link = "WinBar" })

vim.g.colors_name = "basic"
