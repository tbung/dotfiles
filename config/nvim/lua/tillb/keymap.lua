local M = {}

local mappings = {}

local function map(mode, lhs, rhs)
  local m = 'map("' .. mode .. ', "' .. lhs .. '")'

  if mappings[m] ~= nil then
    error("already defined")
  end

  mappings[m] = vim.fn.maparg(lhs, mode)

  vim.keymap.set(mode, lhs, rhs, {})
end

map("n", "<leader>gg", [[<cmd>G<cr>]])
map("x", "<leader>p", [["_dP]])
map("n", "]q", function()
  vim.cmd("cnext")
end)
map("n", "[q", function()
  vim.cmd("cprev")
end)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "gD", vim.lsp.buf.declaration)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)
-- map("n", "<leader>vf", function()
--   vim.lsp.buf.format({
--     filter = function(client)
--       local excludes = {
--         "lua_ls",
--         "pylsp",
--       }
--       return not vim.tbl_contains({client.name, excludes})
--     end,
--   })
-- end)
--
map("n", "<leader>vf", function()
  require("conform").format({
    async = true,
    lsp_fallback = "always",
    filter = function(client)
      return client.name ~= "ruff_lsp"
    end,
  })
end)
map("n", "<leader>vd", function()
  require("tillb.peekdefinition").peek_definition()
end)
map("n", "<leader>vh", vim.lsp.buf.hover)
map("n", "<leader>vrn", vim.lsp.buf.rename)
map("n", "<leader>vsd", vim.diagnostic.open_float)
map("n", "<leader>vsh", vim.lsp.buf.signature_help)
map("n", "<leader>va", vim.lsp.buf.code_action)
map("v", "<leader>va", vim.lsp.buf.code_action)
map("n", "<leader>vih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)

map("n", "<leader>tt", function()
  require("tillb.terminal").goto_terminal(1)
end)
map("n", "<leader>tn", function()
  require("tillb.terminal").goto_new_terminal()
end)
map("n", "<leader>tg", function()
  require("tillb.terminal").goto_terminal()
end)
map("n", "<leader>te", function()
  require("tillb.terminal").edit_makeprg()
end)
map("n", "<leader>tm", function()
  require("tillb.terminal").terminal_make()
end)

map("n", "<leader>ff", function()
  require("telescope.builtin").find_files({ hidden = true, no_ignore = false })
end)
map("n", "<leader>fg", function()
  require("telescope.builtin").git_files()
end)
map("n", "<leader>fe", function()
  require("telescope").extensions.file_browser.file_browser({ hidden = true, no_ignore = true })
end)
map("n", "<leader>ft", function()
  require("telescope.builtin").live_grep({ hidden = true, no_ignore = true })
end)
map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end)
map("n", "<leader>fb", function()
  require("telescope.builtin").buffers({ sort_lastused = true, sort_mru = true, ignore_current_buffer = true })
end)
map("n", "<C-n>", function()
  require("telescope.builtin").buffers({ sort_lastused = true, sort_mru = true, ignore_current_buffer = true })
end)
map("n", "<leader>fsw", function()
  require("telescope.builtin").lsp_workspace_symbols()
end)
map("n", "<leader>fsd", function()
  require("telescope.builtin").lsp_document_symbols()
end)
map("n", "<leader>fu", function()
  require("telescope").extensions.undo.undo()
end)

M.check = function()
  vim.health.start("Keymap duplicates")
  
  local found_duplicates = false

  for m, h in pairs(mappings) do
    if h ~= "" then
      vim.health.warn("" .. vim.inspect(m) .. ": " .. h)
      found_duplicates = true
    end
  end
  if not found_duplicates then
    vim.health.ok("No duplicates found")
  end
end

return M
