require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt" },
    check_ts = true,
})
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

npairs.add_rules({
    Rule("$", "$", {"tex", "latex"})
})

