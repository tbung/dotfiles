return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "main",
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          require('nvim-treesitter.parsers').markdown.install_info.url = nil
          require('nvim-treesitter.parsers').markdown_inline.install_info.url = nil
          require('nvim-treesitter.parsers').markdown.install_info.path = vim.fn.expand(
          "$HOME/Projects/tree-sitter-markdown/")
          require('nvim-treesitter.parsers').markdown_inline.install_info.path = vim.fn.expand(
          "$HOME/Projects/tree-sitter-markdown/")
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end
      })
    end,
  },
}
