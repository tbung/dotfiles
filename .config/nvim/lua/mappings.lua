local function map(mode, from, to, opt)
    vim.api.nvim_set_keymap(mode, from, to, opt)
end

local opts = { noremap=true, silent=true }

-- #######
-- # LSP #
-- #######

map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', '<leader>vdd', '<cmd>TroubleToggle document_diagnostics<CR>', opts)
map('n', '<leader>vdw', '<cmd>TroubleToggle workspace_diagnostics<CR>', opts)
map('n', '<leader>vf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
map('n', '<leader>vh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', '<leader>vrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
map('n', '<leader>vrr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
map('n', '<leader>vsd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
map('n', '<leader>vsh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)


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
map("n", "<leader>cf", ":lua require('harpoon.term').sendCommand(1, 1, vim.fn.expand('%'));require('harpoon.term').gotoTerminal(1)<CR>", opts)
map("n", "<leader>cd", ":lua require('harpoon.term').sendCommand(1, 2, vim.fn.expand('%'));require('harpoon.term').gotoTerminal(1)<CR>", opts)
map("n", "<leader>cc", ":lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", opts)


-- #########
-- # Magma #
-- #########

map("n", "<leader>r", "nvim_exec('MagmaEvaluateOperator', v:true)", vim.tbl_extend("force", opts, {expr = true}))
map("n", "<leader>rr", ":MagmaEvaluateLine<CR>", opts)
map("x", "<leader>r", ":<C-u>MagmaEvaluateVisual<CR>", opts)
map("n", "<leader>rc", ":MagmaReevaluateCell<CR>", opts)
map("n", "<leader>rd", ":MagmaDelete<CR>", opts)
map("n", "<leader>ro", ":MagmaShowOutput<CR>", opts)


-- #######
-- # Git #
-- #######
map("n", "<leader>gg", ":lua git_toggle()<CR>", opts)
map("n", "<leader>gp", ":lua PushCluster()<CR>", opts)


-- ########
-- # Misc #
-- ########

-- Maximizer
map('n', '<leader>m', [[<cmd>MaximizerToggle!<cr>]], opts)
-- Persistence
map("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], opts)
map("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], opts)
map("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], opts)
-- Nvim Tree
map("n", "<leader>n", [[<Cmd>NvimTreeToggle<CR>]], opts)
