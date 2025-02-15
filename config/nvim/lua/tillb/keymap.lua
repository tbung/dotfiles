local M = {}

local mappings = {}

---@param modes string|string[]
---@param lhs string
---@param rhs string|function
---@return nil
local function map(modes, lhs, rhs)
  if type(modes) ~= "table" then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    local m = 'map("' .. mode .. ', "' .. lhs .. '")'

    if mappings[m] ~= nil then
      error("already defined")
    end

    mappings[m] = vim.fn.maparg(lhs, mode)
  end

  vim.keymap.set(modes, lhs, rhs, {})
end

map("n", "<leader>gg", [[<cmd>G<cr>]])
map("x", "<leader>p", [["_dP]])
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map({ "i", "c" }, "<C-BS>", "<C-w>")
map({ "i", "c" }, "<C-h>", "<C-w>")

-- LSP Stuff
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)

map("n", "<leader>vf", vim.lsp.buf.format)
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
---@module "snacks"
map("n", "<leader>ff", function()
  Snacks.picker.files()
end)
map("n", "<leader>fg", function()
  Snacks.picker.git_files()
end)
map("n", "<leader>ft", function()
  Snacks.picker.grep()
end)
map("n", "<leader>fh", function()
  Snacks.picker.help()
end)
map("n", "<leader>fb", function()
  Snacks.picker.buffers({ current = false })
end)
map("n", "<C-n>", function()
  Snacks.picker.smart({
    multi = { { source = "buffers", current = false }, "files" },
    matcher = {
      on_match = function(_, item)
        if item.flags and item.flags:find("#") then
          item.score = 20000
        end
      end,
    },
  })
end)
map("n", "<leader>fS", function()
  Snacks.picker.lsp_workspace_symbols()
end)
map("n", "<leader>fs", function()
  Snacks.picker.lsp_symbols()
end)
map("n", "<leader>fD", function()
  Snacks.picker.diagnostics()
end)
map("n", "<leader>fd", function()
  Snacks.picker.diagnostics_buffer()
end)
map("n", "<leader>fm", function()
  Snacks.picker.marks()
end)
map("n", "<leader>fr", function()
  Snacks.picker.resume()
end)
map("n", "<leader>fu", function()
  Snacks.picker.undo()
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
