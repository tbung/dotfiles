local opts = { noremap = true, silent = true }

vim.keymap.set("x", "<leader>p", [["_dP]], opts)
vim.keymap.set("n", "]q", function() vim.cmd("cnext") end, opts)
vim.keymap.set("n", "[q", function() vim.cmd("cprev") end, opts)

-- #######
-- # LSP #
-- #######

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>vdd", "<cmd>TroubleToggle document_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>vdw", "<cmd>TroubleToggle workspace_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>vf", function()
  vim.lsp.buf.format({
    filter = function(client)
      -- always use stylua to format
      return client.name ~= "sumneko_lua"
    end,
  })
end, opts)
vim.keymap.set("n", "<leader>vh", vim.lsp.buf.hover, opts)
-- vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
-- vim.keymap.set("n", "<leader>vrn", require("renamer").rename, opts)
vim.keymap.set("n", "<leader>vrn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
vim.keymap.set("n", "<leader>vsd", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>vsh", vim.lsp.buf.signature_help, opts)
vim.keymap.set("n", "<leader>va", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- #############
-- # Telescope #
-- #############

-- vim.keymap.set("n", "<C-p>", function()
--   require("telescope.builtin").find_files({ hidden = true })
-- end, opts)
vim.keymap.set("n", "<C-n>", function()
  require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
end, opts)

vim.keymap.set("n", "<leader>fa", function()
  require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end, vim.tbl_extend("keep", opts, { desc = "Find all files" }))

vim.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
end, vim.tbl_extend("keep", opts, { desc = "Find buffers" }))

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
  require("telescope").extensions.file_browser.file_browser()
end, opts)

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files({ hidden = true })
end, vim.tbl_extend("keep", opts, { desc = "Find files (ignoring based on .gitignore)" }))

vim.keymap.set("n", "<leader>ft", function()
  require("telescope.builtin").live_grep({ hidden = true, no_ignore = true })
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
vim.keymap.set("n", "<leader>tg", function()
  require("harpoon.term").gotoTerminal(3)
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
vim.keymap.set("n", "<leader>rh", ":MagmaHideOutput<CR>", opts)

-- ######
-- # ZK #
-- ######

-- Create a new note after asking for its title.
-- vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)
vim.keymap.set("n", "<leader>zn", function()
  vim.ui.input("Title:", function(s)
    if s ~= nil then
      require("zk").new({ title = s })
    end
  end)
end, opts)

-- Create today's journal entry
vim.keymap.set("n", "<leader>zj", "<Cmd>ZkNew { group='daily', dir='journal' }<CR>", opts)

-- Open notes.
vim.keymap.set("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Open notes associated with the selected tags.
vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)

-- Search for the notes matching a given query.
-- vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", opts)
vim.keymap.set("n", "<leader>zf", function()
  vim.ui.input("Search:", function(s)
    if s ~= nil then
      require("zk").list({ sort = { "modified" }, match = s })
    end
  end)
end, opts)
-- Search for the notes matching the current visual selection.
vim.keymap.set("v", "<leader>zf", ":'<,'>ZkMatch<CR>", opts)

-- #######
-- # Git #
-- #######
vim.keymap.set("n", "<leader>gg", [[<cmd>Neogit<cr>]], opts)

-- #######
-- # DAP #
-- #######

vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, vim.tbl_extend("keep", opts, { desc = "Continue debugging" }))

vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, vim.tbl_extend("keep", opts, { desc = "Toggle DAP UI" }))

vim.keymap.set("n", "<leader>dbb", function()
  require("dap").toggle_breakpoint()
end, vim.tbl_extend("keep", opts, { desc = "Toggle breakpoint" }))

vim.keymap.set("n", "<leader>dss", function()
  require("dap").step_over()
end, vim.tbl_extend("keep", opts, { desc = "Step over" }))

vim.keymap.set("n", "<leader>dsi", function()
  require("dap").step_into()
end, vim.tbl_extend("keep", opts, { desc = "Step into" }))

vim.keymap.set("n", "<leader>dso", function()
  require("dap").step_out()
end, vim.tbl_extend("keep", opts, { desc = "Step out" }))

vim.keymap.set("n", "<leader>dkk", function()
  require("dap").terminate()
end, vim.tbl_extend("keep", opts, { desc = "Terminate debug process" }))

-- vim.keymap.set("n", "<leader>dt", function () require("dap-python").test_method() end, opts)
vim.keymap.set("n", "<leader>dtt", function()
  require("neotest").run.run({ strategy = "dap" })
end, vim.tbl_extend("keep", opts, { desc = "Run nearest test" }))
vim.keymap.set("n", "<leader>dts", function()
  require("neotest").summary.toggle()
end, vim.tbl_extend("keep", opts, { desc = "Open test summary" }))

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
vim.keymap.set("n", "<leader>n", [[<Cmd>Neotree toggle<CR>]], opts)
-- Dial
vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), opts)
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), opts)
vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), opts)
vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), opts)
vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), opts)
vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), opts)
