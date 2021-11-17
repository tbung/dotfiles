local function map(mode, from, to, opt)
    vim.api.nvim_set_keymap(mode, from, to, opt)
end

local opts = { noremap=true, silent=true }

-- #######
-- # Vim #
-- ######

-- Sensible remaps
map('n', 'Y', 'y$', opts)
-- Keep it centered
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)
map('n', 'J', 'mzJ`z', opts)
-- Undo breakpoints
map('i', ',', ',<c-g>u', opts)
map('i', '.', '.<c-g>u', opts)
map('i', '!', '!<c-g>u', opts)
map('i', '?', '?<c-g>u', opts)
-- Moving lines
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)
map('n', '<leader>k', ':m .-2<CR>==', opts)
map('n', '<leader>j', ':m .+1<CR>==', opts)
-- Best thing since sliced bread
map('x', '<leader>p', '"_dP', opts)
-- Disable arrow keys in normal mode
map('n', '<Up>',    '<NOP>', opts)
map('n', '<Down>',  '<NOP>', opts)
map('n', '<Left>',  '<NOP>', opts)
-- Disable arrow keys in insert mode
map('i', '<Up>',    '<NOP>', opts)
map('i', '<Down>',  '<NOP>', opts)
map('i', '<Left>',  '<NOP>', opts)
map('i', '<Right>', '<NOP>', opts)


-- #######
-- # LSP #
-- #######

map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', '<leader>vdd', '<cmd>TroubleToggle lsp_document_diagnostics<CR>', opts)
map('n', '<leader>vdw', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>', opts)
map('n', '<leader>vh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', '<leader>vrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
map('n', '<leader>vrr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
map('n', '<leader>vsd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
map('n', '<leader>vsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)


-- #############
-- # Telescope #
-- #############

map('n', '<C-p>', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], opts)
map('n', '<C-n>', [[<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })<cr>]], opts)

map('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true })<cr>]], opts)
map('n', '<leader>fca', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>]], opts)
map('n', '<leader>fd', [[<cmd>lua require('telescope.builtin').find_files({ prompt_title = "dotfiles", shorten_path = false, cwd = "~/.dotfiles", hidden = true })<cr>]], opts)
map('n', '<leader>fe', [[<cmd>lua require('telescope.builtin').file_browser()<cr>]], opts)
map('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], opts)
map('n', '<leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], opts)
map('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], opts)
map('n', '<leader>fp', [[<cmd>lua require('telescope').extensions.project.project({})<cr>]], opts)
map('n', '<leader>fsw', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>]], opts)
map('n', '<leader>fsd', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], opts)
map('n', '<leader>fw', [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>]], opts)
map('n', '<leader>fz', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({winblend = 10, border = true, previewer = false, shorten_path = false}))<cr>]], opts)


-- ###########
-- # LuaSnip #
-- ###########

map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("i", "<C-E>", "<Plug>luasnip-next-choice", {})
map("s", "<C-E>", "<Plug>luasnip-next-choice", {})


-- ###########
-- # Harpoon #
-- ###########

map("n", "<leader>a", ":lua require('harpoon.mark').add_file()<CR>", opts)
map("n", "<C-e>", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)

map("n", "<C-h>", ":lua require('harpoon.ui').nav_file(1)<CR>", opts)
map("n", "<C-j>", ":lua require('harpoon.ui').nav_file(2)<CR>", opts)
map("n", "<C-k>", ":lua require('harpoon.ui').nav_file(3)<CR>", opts)
map("n", "<C-l>", ":lua require('harpoon.ui').nav_file(4)<CR>", opts)
map("n", "<leader>tf", ":lua require('harpoon.term').gotoTerminal(1)<CR>", opts)
map("n", "<leader>td", ":lua require('harpoon.term').gotoTerminal(2)<CR>", opts)
map("n", "<leader>cf", ":lua require('harpoon.term').sendCommand(1, 1)<CR>", opts)
map("n", "<leader>cd", ":lua require('harpoon.term').sendCommand(1, 2)<CR>", opts)


-- ########
-- # Misc #
-- ########

-- EasyAlign
map('n','ga', '<Plug>(EasyAlign)', opts)
-- Maximizer
map('n', '<leader>m', [[<cmd>MaximizerToggle!<cr>]], opts)
-- Persistence
map("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], opts)
map("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], opts)
map("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], opts)
-- Nvim Tree
map("n", "<leader>n", [[<Cmd>NvimTreeToggle<CR>]], opts)
