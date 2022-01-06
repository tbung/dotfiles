local opts = { noremap=true, silent=true }
vim.api.nvim_buf_set_keymap(0, 'n', '[j', ':lua require("tbung.jupyter").goto_previous_cell_start()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'n', '[J', ':lua require("tbung.jupyter").goto_previous_cell_end()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'n', ']j', ':lua require("tbung.jupyter").goto_next_cell_start()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'n', ']J', ':lua require("tbung.jupyter").goto_next_cell_end()<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'x', 'ij', ':lua require("tbung.jupyter").select_cell(0)<cr>', opts)
vim.api.nvim_buf_set_keymap(0, 'o', 'ij', ':lua require("tbung.jupyter").select_cell(0)<cr>', opts)
