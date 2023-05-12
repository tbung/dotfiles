vim.keymap.set("n", "<leader>gg", [[<cmd>G<cr>]], {})
vim.keymap.set("x", "<leader>p", [["_dP]], {})
vim.keymap.set("n", "]q", function() vim.cmd("cnext") end, {})
vim.keymap.set("n", "[q", function() vim.cmd("cprev") end, {})
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>vf", function()
  vim.lsp.buf.format({
    filter = function(client)
      -- always use stylua to format
      return client.name ~= "sumneko_lua"
    end,
  })
end, {})
vim.keymap.set("n", "<leader>vh", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>vsd", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>vsh", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<leader>va", vim.lsp.buf.code_action, {})
vim.keymap.set("v", "<leader>va", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
