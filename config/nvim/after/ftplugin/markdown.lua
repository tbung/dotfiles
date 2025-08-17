vim.opt_local.spell = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = false
vim.opt_local.breakindentopt = "shift:4"

vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

-- NOTE: Currently can't fully disable this for LSP preview windows
-- vim.cmd.packadd("render-markdown.nvim")
