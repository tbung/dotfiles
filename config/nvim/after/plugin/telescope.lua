-- This is your opts table
require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
  },
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("file_browser")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find files (ignoring based on .gitignore)" })
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fe", function()
  require("telescope").extensions.file_browser.file_browser()
end, {})

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
