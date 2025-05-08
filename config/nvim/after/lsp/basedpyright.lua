return {
  settings = {
    python = {
      analysis = {
        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
