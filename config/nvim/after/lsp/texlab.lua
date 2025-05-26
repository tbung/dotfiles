return {
  settings = {
    texlab = {
      auxDirectory = "./build",
      build = {
        args = { "-output-directory=./build", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = true,
      },
      latexindent = {
        modifyLineBreaks = true,
      },
      forwardSearch = {
        -- TODO: this is currently macos specific, make it os agnostic
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "-b", "%l", "%p", "%f" },
      },
    },
  },
}
