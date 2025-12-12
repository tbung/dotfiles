---@type vim.lsp.Config
return {
  settings = { haskell = {
    plugin = {
      -- broken until next release
      hlint = {
        diagnosticsOn = false,
      },
    },
  }, },
}
