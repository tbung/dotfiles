local iron = require("iron.core")

iron.setup({
  config = {
    scratch_repl = true,
    repl_definition = {
      sh = {
        command = { "zsh" },
      },
    },
    repl_open_cmd = require("iron.view").split.vertical(),
  },
  keymaps = {
    send_motion = "<leader>sc",
    visual_send = "<leader>sc",
    send_file = "<leader>sf",
    send_line = "<leader>sl",
    -- cr = "<space>s<cr>",
    interrupt = "<leader>s<space>",
    exit = "<leader>sq",
    -- clear = "<space>cl",
  },
  highlight = {
    bg = require("catppuccin.palettes").get_palette().surface0,
  },
})
