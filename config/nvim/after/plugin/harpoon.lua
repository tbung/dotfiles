require("harpoon").setup({
  global_settings = {
    save_on_toggle = false,
    save_on_change = true,
    enter_on_sendcmd = true,
    tmux_autoclose_windows = false,
    excluded_filetypes = { "harpoon" },
  },
})

vim.keymap.set("n", "<leader>tf", function()
  require("harpoon.term").gotoTerminal(1)
end, {})
vim.keymap.set("n", "<leader>td", function()
  require("harpoon.term").gotoTerminal(2)
end, {})
vim.keymap.set("n", "<leader>tg", function()
  require("harpoon.term").gotoTerminal(3)
end, {})
