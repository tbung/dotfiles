vim.cmd.runtime("colors/default.vim")
for _, hl_name in ipairs({ "Normal", "NonText", "EndOfBuffer" }) do
  local hl = vim.api.nvim_get_hl(0, { name = hl_name })
  hl.bg = nil
  vim.api.nvim_set_hl(0, hl_name, hl)
end

vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cdd6f4", bg = "#181825" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#45475a", bg = "#181825" })
vim.api.nvim_set_hl(0, "WinBar", { fg = "#f5e0dc", bold = true, bg = nil })
vim.api.nvim_set_hl(0, "WinBarNC", { link = "WinBar" })
