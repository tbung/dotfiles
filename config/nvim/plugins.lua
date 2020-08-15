local iron = require('iron')


local open_repl = function(buffer)
  vim.api.nvim_command('botright vertical 100 split | buf ' .. buffer .. ' | set wfw | startinsert')
end

iron.core.set_config {
  preferred = {
    python = "ipython"
  },
  repl_open_cmd = open_repl
}
