return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-ui-select.nvim",
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
      },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("file_browser")

      -- HACK: Telescope opens files while still in insert mode which breaks folding (and maybe other stuff too)
      vim.api.nvim_create_autocmd("BufRead", {
        callback = function()
          vim.api.nvim_create_autocmd("BufWinEnter", {
            once = true,
            command = "normal! zx",
          })
        end,
      })
    end,
    cmd = "Telescope",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ hidden = true })
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
          require("telescope").extensions.file_browser.file_browser()
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
          require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
        end,
      },
      {
        "<C-n>",
        function()
          require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
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
    },
  },
}
