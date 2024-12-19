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

local function maybe_require(name)
  local ok, module_ = pcall(require, name)
  if ok then
    return module_
  end
  print(name .. " not installed")
end

map("n", "<leader>gg", [[<cmd>G<cr>]])
map("x", "<leader>p", [["_dP]])
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("i", "<C-BS>", "<C-w>")
map("i", "<C-h>", "<C-w>")

-- LSP Stuff
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)

map("n", "<leader>vf", function()
  local cursor = vim.fn.getpos(".")
  vim.cmd.normal("gggqG")
  vim.fn.setpos(".", cursor)
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

-- Terminal Stuff
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

-- Telescope Stuff
map("n", "<leader>ff", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.find_files({ hidden = true, no_ignore = false })
  end
end)
map("n", "<leader>fg", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.git_files()
  end
end)
map("n", "<leader>fe", function()
  local m = maybe_require("telescope")
  if m ~= nil then
    m.extensions.file_browser.file_browser({ hidden = true, no_ignore = true })
  end
end)
map("n", "<leader>ft", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.live_grep({ hidden = true, no_ignore = true })
  end
end)
map("n", "<leader>fh", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.help_tags()
  end
end)
map("n", "<leader>fb", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.buffers({ sort_lastused = true, sort_mru = true, ignore_current_buffer = true })
  end
end)
map("n", "<C-n>", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.buffers({ sort_lastused = true, sort_mru = true, ignore_current_buffer = true })
  else
    vim.cmd.buffers()
  end
end)
map("n", "<leader>fS", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.lsp_workspace_symbols()
  end
end)
map("n", "<leader>fs", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.lsp_document_symbols()
  end
end)
map("n", "<leader>fD", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.diagnostics()
  end
end)
map("n", "<leader>fd", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.diagnostics({ bufnr = 0 })
  end
end)
map("n", "<leader>fm", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.marks()
  end
end)
map("n", "<leader>fr", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.resume()
  end
end)
map("n", "<leader>fc", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.command_history()
  end
end)
map("n", "<leader>fC", function()
  local m = maybe_require("telescope.builtin")
  if m ~= nil then
    m.commands()
  end
end)
map("n", "<leader>fu", function()
  local m = maybe_require("telescope")
  if m ~= nil then
    m.extensions.undo.undo()
  end
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
