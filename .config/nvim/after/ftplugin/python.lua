local opts = { noremap = true, silent = true, buffer = true }
vim.keymap.set("n", "[j", function()
  require("tbung.jupyter").goto_previous_cell_start()
end, opts)
vim.keymap.set("n", "[J", function()
  require("tbung.jupyter").goto_previous_cell_end()
end, opts)
vim.keymap.set("n", "]j", function()
  require("tbung.jupyter").goto_next_cell_start()
end, opts)
vim.keymap.set("n", "]J", function()
  require("tbung.jupyter").goto_next_cell_end()
end, opts)
vim.keymap.set("x", "ij", function()
  require("tbung.jupyter").select_cell(0)
  vim.cmd([[normal! zt]])
end, opts)
vim.keymap.set("o", "ij", function()
  require("tbung.jupyter").select_cell(0)
  vim.cmd([[normal! zt]])
end, opts)

vim.cmd([[
command! -nargs=0 JupyterLaunch lua require("tbung.jupyter").launch()
]])
