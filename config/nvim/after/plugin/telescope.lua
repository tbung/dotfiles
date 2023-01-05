local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find files (ignoring based on .gitignore)" })
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})

vim.keymap.set("n", "<leader>ft", function()
  require("telescope.builtin").live_grep({ hidden = true, no_ignore = true })
end, {})

vim.keymap.set("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, {})

vim.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
end, {})
vim.keymap.set("n", "<C-n>", function()
  require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
end, {})

vim.keymap.set("n", "<leader>fsw", function()
  require("telescope.builtin").lsp_workspace_symbols()
end, {})

vim.keymap.set("n", "<leader>fsd", function()
  require("telescope.builtin").lsp_document_symbols()
end, {})
