require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt" },
    check_ts = true,
})
require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true -- it will auto insert `(` after select function or method item
})
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

npairs.add_rules({
    Rule("$", "$", {"tex", "latex"})
})

