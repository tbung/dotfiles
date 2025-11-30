vim.opt_local.spell = true
vim.opt_local.wrap = true
vim.opt_local.conceallevel = 2
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true


local query = vim.treesitter.query.get("markdown_inline", "highlights")
if query then
  -- from :Inspect!
  local pattern_index = 15
  query.query:disable_pattern(pattern_index)
  vim.treesitter.stop()
  vim.treesitter.start()
end

require("tillb.markdown").attach()
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function(args)
    vim.wo.conceallevel = 0
  end,
  buffer = 0,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function(args)
    vim.wo.conceallevel = 2
  end,
  buffer = 0,
})
