-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
  close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
  window = {
    width = 30,
  },
  filesystem = {
    follow_current_file = true, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
  },
  buffers = {
    follow_current_file = true, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
  },
})

vim.keymap.set("n", "<leader>n", [[<Cmd>Neotree toggle<CR>]], {})
