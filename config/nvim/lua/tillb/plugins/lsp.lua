vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

require("blink.cmp").setup({
  -- experimental signature help support
  signature = { enabled = true },
  cmdline = { enabled = false },
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    -- local server_configs = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
    --     :map(function(file)
    --       return vim.fn.fnamemodify(file, ":t:r")
    --     end)
    --     :totable()
    local server_configs = { "lua_ls", "texlab", "basedpyright" }
    vim.lsp.enable(server_configs)
  end,
})
