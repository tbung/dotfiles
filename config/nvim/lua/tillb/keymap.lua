local map = vim.keymap.set

-- paste without ruining the register
map("x", "<leader>p", [["_dP]])

-- format entire file
map("n", "gqQ", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("keepj norm! gggqG")
  vim.api.nvim_win_set_cursor(0, pos)
end)

-- predictable cursor position after big jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- make kill-word behave
map({ "i", "c" }, "<C-BS>", "<C-w>")
map({ "i", "c" }, "<C-h>", "<C-w>")

-- arrow keys in cmdline-autocomplete
map("c", "<Left>", "<Space><BS><Left>")
map("c", "<Right>", "<Space><BS><Right>")
map("c", "<Up>", function() return (vim.fn.wildmenumode() == 1) and "<C-E><Up>" or "<Up>" end, { expr = true })
map("c", "<Down>", function() return (vim.fn.wildmenumode() == 1) and "<C-E><Down>" or "<Down>" end, { expr = true })

map("n", "m", function() require("tillb.marks").set_mark() end)
map("n", "dm", function() require("tillb.marks").unset_mark() end)

map({ "n", "x", "o" }, "f", function() return require("tillb.line-nav").on_key("f") end, { expr = true })
map({ "n", "x", "o" }, "F", function() return require("tillb.line-nav").on_key("F") end, { expr = true })
map({ "n", "x", "o" }, "t", function() return require("tillb.line-nav").on_key("t") end, { expr = true })
map({ "n", "x", "o" }, "T", function() return require("tillb.line-nav").on_key("T") end, { expr = true })

-- Terminal Stuff
map("n", "<leader>tt", function()
  require("tillb.terminal").open_terminal()
end)
map("n", "<leader>te", function()
  require("tillb.terminal").edit_makeprg()
end)
map("n", "<leader>tm", function()
  require("tillb.terminal").terminal_make()
end)

map("n", "<leader>ff", ":find ")
map("n", "<leader>fb", ":b ")
map("n", "<C-n>", ":Find ")
