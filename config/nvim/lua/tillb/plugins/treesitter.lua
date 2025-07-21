vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").markdown.install_info.url = nil
    require("nvim-treesitter.parsers").markdown_inline.install_info.url = nil
    require("nvim-treesitter.parsers").markdown.install_info.path = vim.fn.expand(
      "$HOME/Projects/tree-sitter-markdown/")
    require("nvim-treesitter.parsers").markdown_inline.install_info.path = vim.fn.expand(
      "$HOME/Projects/tree-sitter-markdown/")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    require("nvim-treesitter").install({ vim.treesitter.language.get_lang(vim.bo.filetype) }):await(function()
      pcall(vim.treesitter.start, args.buf)
    end)
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(args)
    local spec = args.data.spec

    if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
      vim.notify("nvim-treesitter was updated, updating parsers", vim.log.levels.INFO)

      vim.schedule(function()
        require("nvim-treesitter").update()
      end)
    end
  end,
})

require("treesitter-context").setup({ enable = true })
