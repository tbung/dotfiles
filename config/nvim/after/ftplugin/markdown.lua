vim.opt_local.spell = true
vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2
vim.opt_local.linebreak = true
vim.opt_local.breakindent = false
vim.opt_local.breakindentopt = "shift:4"

vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

local query = vim.treesitter.query.get("markdown_inline", "highlights")
if query then
  -- from :Inspect!
  local pattern_index = 15
  query.query:disable_pattern(pattern_index)
  vim.treesitter.stop()
  vim.treesitter.start()
end

require("tillb.markdown").attach()
