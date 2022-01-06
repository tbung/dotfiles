local opts = { noremap=true, silent=true }
vim.api.nvim_buf_set_keymap(0, 'n', '[j', ':lua vim.fn.setpos(".", {0, require"tbung.jupyter".cell_start() - 1, 0, 0});vim.fn.setpos(".", {0, require"tbung.jupyter".cell_start(), 0, 0})<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'n', '[J', ':lua vim.fn.setpos(".", {0, require"tbung.jupyter".cell_start() - 1, 0, 0})<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'n', ']j', ':lua vim.fn.setpos(".", {0, require"tbung.jupyter".cell_end() + 1, 0, 0})<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'n', ']J', ':lua vim.fn.setpos(".", {0, require"tbung.jupyter".cell_end() + 1, 0, 0});vim.fn.setpos(".", {0, require"tbung.jupyter".cell_end(), 0, 0})<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'x', 'ij', ':lua require"tbung.jupyter".select_cell(0)<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'o', 'ij', ':lua require"tbung.jupyter".select_cell(0)<cr>', opts)
