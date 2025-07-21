vim.cmd.runtime("colors/default.vim")

for _, hl_name in ipairs({ "Normal", "NonText", "EndOfBuffer" }) do
  local hl = vim.api.nvim_get_hl(0, { name = hl_name })
  hl.bg = nil
  vim.api.nvim_set_hl(0, hl_name, hl)
end

if vim.go.background == "dark" then
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cdd6f4", bg = "#181825" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#45475a", bg = "#181825" })
  -- vim.api.nvim_set_hl(0, "WinBar", { fg = "#f5e0dc", bold = true, bg = nil })
elseif vim.go.background == "light" then
  vim.api.nvim_set_hl(0, "StatusLine", { fg = "#4c4f69", bg = "#e6e9ef" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#bcc0cc", bg = "#e6e9ef" })
  -- vim.api.nvim_set_hl(0, "WinBar", { fg = "#4c4f69", bold = true, bg = nil })
end

vim.api.nvim_set_hl(0, "WinBar", { fg = nil, bold = true, bg = nil })
vim.api.nvim_set_hl(0, "WinBarNC", { link = "WinBar" })

vim.g.colors_name = "basic"
