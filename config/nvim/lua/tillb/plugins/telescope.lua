if vim.g.basic then
  return {}
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          path_display = { "filename_first" },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          file_browser = {
            sorting_strategy = "ascending",
          },
          undo = {},
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("undo")
    end,
    cmd = "Telescope",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = false })
        end,
        desc = "Find files (ignoring based on .gitignore)",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").git_files()
        end,
      },
      {
        "<leader>fe",
        function()
          require("telescope").extensions.file_browser.file_browser({ hidden = true, no_ignore = true })
        end,
      },
      {
        "<leader>ft",
        function()
          require("telescope.builtin").live_grep({ hidden = true, no_ignore = true })
        end,
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({ sort_lastused = true, sort_mru = true, ignore_current_buffer = true })
        end,
      },
      {
        "<C-n>",
        function()
          require("telescope.builtin").buffers({ sort_lastused = true, sort_mru = true, ignore_current_buffer = true })
        end,
      },
      {
        "<leader>fsw",
        function()
          require("telescope.builtin").lsp_workspace_symbols()
        end,
      },
      {
        "<leader>fsd",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
      },
      {
        "<leader>fu",
        function()
          require("telescope").extensions.undo.undo()
        end,
      },
    },
  },
}
