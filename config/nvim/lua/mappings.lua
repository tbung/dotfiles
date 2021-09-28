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
map('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })<cr>]])
map('n', '<C-n>',      [[<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })<cr>]])
map('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]])
map('n', '<leader>ws', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]])
map('n', '<leader>fs', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]])
map('n', '<leader>fe', [[<cmd>lua require('telescope.builtin').file_browser()<cr>]])
map('n', '<leader>fw', [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>]])
map('n', '<leader>fp', [[<cmd>lua require('telescope').extensions.project.project({})<cr>]])
map('n', '<leader>fz', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({winblend = 10, border = true, previewer = false, shorten_path = false}))<cr>]])

-- Open dotfiles from anywhere
map('n', '<leader>fd', [[<cmd>lua require('telescope.builtin').find_files({ prompt_title = "dotfiles", shorten_path = false, cwd = "~/.dotfiles", hidden = true })<cr>]])

-- EasyAlign
map('n','ga', '<Plug>(EasyAlign)')

-- Vimspector
map('n', '<leader>m', [[<cmd>MaximizerToggle!<cr>]])
map('n', '<leader>dd', [[<cmd>call vimspector#Launch()<cr>]])
map('n', '<leader>dc', [[<cmd>call GotoWindow(g:vimspector_session_windows.code)<cr>]])
map('n', '<leader>dt', [[<cmd>call GotoWindow(g:vimspector_session_windows.tagpage)<cr>]])
map('n', '<leader>dv', [[<cmd>call GotoWindow(g:vimspector_session_windows.variables)<cr>]])
map('n', '<leader>dw', [[<cmd>call GotoWindow(g:vimspector_session_windows.watches)<cr>]])
map('n', '<leader>ds', [[<cmd>call GotoWindow(g:vimspector_session_windows.stacktrace)<cr>]])
map('n', '<leader>do', [[<cmd>call GotoWindow(g:vimspector_session_windows.output)<cr>]])

map('n', '<leader>dl', [[<cmd>call vimspector#StepInto()<cr>]])
map('n', '<leader>dj', [[<cmd>call vimspector#StepOver()<cr>]])
map('n', '<leader>dk', [[<cmd>call vimspector#StepOut()<cr>]])
map('n', '<leader>d_', [[<cmd>call vimspector#Restart()<cr>]])
map('n', '<leader>d<space>', [[<cmd>call vimspector#Continue()<cr>]])
map('n', '<leader>drc', [[<cmd>call vimspector#RunToCursor()<cr>]])
map('n', '<leader>dbp', [[<cmd>call vimspector#ToggleBreakpoint()<cr>]])
map('n', '<leader>dcbp', [[<cmd>call vimspector#ToggleConditionalBreakpoint()<cr>]])

-- Snippets
-- vim.api.nvim_set_keymap('i', '<Tab>', [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']], { noremap = false })
-- map('i', '<silent> <S-Tab>', [[<cmd>lua require'luasnip'.jump(-1)<Cr>]])

-- map('s', '<silent> <Tab>', [[<cmd>lua require('luasnip').jump(1)<Cr>]])
-- map('s', '<silent> <S-Tab>', [[<cmd>lua require('luasnip').jump(-1)<Cr>]])

-- vim.api.nvim_set_keymap('i', '<silent><expr> <C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']], { noremap = false })
-- vim.api.nvim_set_keymap('s', '<silent><expr> <C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>']], { noremap = false })
