local opts = { noremap = true, silent = true }

-- #######
-- # LSP #
-- #######

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>vdd", "<cmd>TroubleToggle document_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>vdw", "<cmd>TroubleToggle workspace_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>vf", vim.lsp.buf.formatting, opts)
vim.keymap.set("n", "<leader>vh", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
vim.keymap.set("n", "<leader>vsd", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>vsh", vim.lsp.buf.signature_help, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "zg", "zg:lua update_ltex()<cr>", opts)
vim.keymap.set("n", "zw", "zw:lua update_ltex()<cr>", opts)
vim.keymap.set("v", "zg", "zg:lua update_ltex()<cr>", opts)
vim.keymap.set("v", "zw", "zw:lua update_ltex()<cr>", opts)

-- #############
-- # Telescope #
-- #############

vim.keymap.set("n", "<C-p>", function()
  require("telescope.builtin").find_files()
end, opts)
vim.keymap.set("n", "<C-n>", function()
  require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
end, opts)

vim.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
end, opts)
vim.keymap.set("n", "<leader>fca", function()
  require("telescope.builtin").lsp_code_actions()
end, opts)
vim.keymap.set("n", "<leader>fd", function()
  require("telescope.builtin").find_files({
    prompt_title = "dotfiles",
    shorten_path = false,
    cwd = "~/.dotfiles",
    hidden = true,
  })
end, opts)
vim.keymap.set("n", "<leader>fe", function()
  require("telescope.builtin").file_browser()
end, opts)
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, opts)
vim.keymap.set("n", "<leader>ft", function()
  require("telescope.builtin").live_grep()
end, opts)
vim.keymap.set("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, opts)
vim.keymap.set("n", "<leader>fp", function()
  require("telescope").extensions.project.project({})
end, opts)
vim.keymap.set("n", "<leader>fsw", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, opts)
vim.keymap.set("n", "<leader>fsd", function()
  require("telescope.builtin").lsp_document_symbols()
end, opts)
vim.keymap.set("n", "<leader>fgw", function()
  require("telescope").extensions.git_worktree.git_worktrees()
end, opts)
vim.keymap.set("n", "<leader>fww", function()
  require("telescope.builtin").find_files({
    prompt_title = "wiki",
    shorten_path = false,
    cwd = "~/wiki",
    hidden = false,
  })
end, opts)
vim.keymap.set("n", "<leader>fwj", function()
  require("telescope.builtin").find_files({
    prompt_title = "journal",
    shorten_path = false,
    cwd = "~/wiki/journal",
    hidden = false,
  })
end, opts)
vim.keymap.set("n", "<leader>fz", function()
  require("telescope.builtin").current_buffer_fuzzy_find(
    require("telescope.themes").get_dropdown({ winblend = 10, border = true, previewer = false, shorten_path = false })
  )
end, opts)

-- ###########
-- # Harpoon #
-- ###########

vim.keymap.set("n", "<leader>a", function()
  require("harpoon.mark").add_file()
end, opts)
vim.keymap.set("n", "<C-e>", function()
  require("harpoon.ui").toggle_quick_menu()
end, opts)

vim.keymap.set("n", "<C-h>", function()
  require("harpoon.ui").nav_file(1)
end, opts)
vim.keymap.set("n", "<C-j>", function()
  require("harpoon.ui").nav_file(2)
end, opts)
vim.keymap.set("n", "<C-k>", function()
  require("harpoon.ui").nav_file(3)
end, opts)
vim.keymap.set("n", "<C-l>", function()
  require("harpoon.ui").nav_file(4)
end, opts)
vim.keymap.set("n", "<leader>tf", function()
  require("harpoon.term").gotoTerminal(1)
end, opts)
vim.keymap.set("n", "<leader>td", function()
  require("harpoon.term").gotoTerminal(2)
end, opts)
vim.keymap.set("n", "<leader>cf", function()
  require("harpoon.term").sendCommand(1, 1, vim.fn.expand("%"))
  require("harpoon.term").gotoTerminal(1)
end, opts)
vim.keymap.set("n", "<leader>cd", function()
  require("harpoon.term").sendCommand(1, 2, vim.fn.expand("%"))
  require("harpoon.term").gotoTerminal(1)
end, opts)
vim.keymap.set("n", "<leader>cc", function()
  require("harpoon.cmd-ui").toggle_quick_menu()
end, opts)

-- #########
-- # Magma #
-- #########

vim.keymap.set(
  "n",
  "<leader>r",
  "nvim_exec('MagmaEvaluateOperator', v:true)",
  vim.tbl_extend("force", opts, { expr = true })
)
vim.keymap.set("n", "<leader>rr", ":MagmaEvaluateLine<CR>", opts)
vim.keymap.set("x", "<leader>r", ":<C-u>MagmaEvaluateVisual<CR>", opts)
vim.keymap.set("n", "<leader>rc", ":MagmaReevaluateCell<CR>", opts)
vim.keymap.set("n", "<leader>rd", ":MagmaDelete<CR>", opts)
vim.keymap.set("n", "<leader>ro", ":MagmaShowOutput<CR>", opts)

-- #######
-- # Git #
-- #######
-- vim.keymap.set("n", "<leader>gg", function() git_toggle() end, opts)
-- vim.keymap.set("n", "<leader>gp", function() PushCluster() end, opts)

-- ########
-- # Misc #
-- ########

-- LuaSnip
vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-expand-or-jump", {})
vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-expand-or-jump", {})
-- Maximizer
vim.keymap.set("n", "<leader>m", [[<cmd>MaximizerToggle!<cr>]], opts)
-- Persistence
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, opts)
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, opts)
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end, opts)
-- Nvim Tree
vim.keymap.set("n", "<leader>n", [[<Cmd>NvimTreeToggle<CR>]], opts)
-- Dial
vim.keymap.set("n", "<C-a>", "<Plug>(dial-increment)", opts)
vim.keymap.set("n", "<C-x>", "<Plug>(dial-decrement)", opts)
vim.keymap.set("v", "<C-a>", "<Plug>(dial-increment)", opts)
vim.keymap.set("v", "<C-x>", "<Plug>(dial-decrement)", opts)
vim.keymap.set("v", "g<C-a>", "<Plug>(dial-increment-additional)", opts)
vim.keymap.set("v", "g<C-x>", "<Plug>(dial-decrement-additional)", opts)
