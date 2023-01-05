require("neoscroll").setup()

local t = {}
t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "80" } }
t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "80" } }
t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "100" } }
t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "100" } }
t["zt"] = { "zt", { "80" } }
t["zz"] = { "zz", { "80" } }
t["zb"] = { "zb", { "80" } }

require("neoscroll.config").set_mappings(t)
