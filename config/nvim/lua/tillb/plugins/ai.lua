if vim.g.basic or vim.env.NVIM_BASIC then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      suggestion = { enabled = true },
      panel = { enabled = false },
    },
  },
}
