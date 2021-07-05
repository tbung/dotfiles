local function map(mode, from, to)
    vim.api.nvim_set_keymap(mode, from, to, { noremap = true })
end

-- Disable arrow keys in normal mode
map('n', '<Up>',    '<NOP>')
map('n', '<Down>',  '<NOP>')
map('n', '<Left>',  '<NOP>')
map('n', '<Right>', '<NOP>')

-- Disable arrow keys in insert mode
map('i', '<Up>',    '<NOP>')
map('i', '<Down>',  '<NOP>')
map('i', '<Left>',  '<NOP>')
map('i', '<Right>', '<NOP>')

-- Sane pane switching
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Telescope Keymaps
map('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]])
map('n', '<C-p>',      [[<cmd>lua require('telescope.builtin').find_files()<cr>]])
map('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]])
map('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true })<cr>]])
map('n', '<C-n>',      [[<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true })<cr>]])
map('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]])
map('n', '<leader>ws', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]])
map('n', '<leader>ds', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]])
map('n', '<leader>fe', [[<cmd>lua require('telescope.builtin').file_browser()<cr>]])

-- Open dotfiles from anywhere
map('n', '<leader>fd', [[<cmd>lua require('telescope.builtin').find_files({ prompt_title = "dotfiles", shorten_path = false, cwd = "~/.dotfiles", hidden = true })<cr>]])

-- EasyAlign
map('n','ga', '<Plug>(EasyAlign)')

-- Snippets
-- vim.api.nvim_set_keymap('i', '<Tab>', [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']], { noremap = false })
-- map('i', '<silent> <S-Tab>', [[<cmd>lua require'luasnip'.jump(-1)<Cr>]])

-- map('s', '<silent> <Tab>', [[<cmd>lua require('luasnip').jump(1)<Cr>]])
-- map('s', '<silent> <S-Tab>', [[<cmd>lua require('luasnip').jump(-1)<Cr>]])

-- vim.api.nvim_set_keymap('i', '<silent><expr> <C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']], { noremap = false })
-- vim.api.nvim_set_keymap('s', '<silent><expr> <C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']], { noremap = false })
