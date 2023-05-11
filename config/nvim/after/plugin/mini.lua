require("mini.starter").setup({
  items = {
    require("mini.starter").sections.recent_files(5, true, false),
    require("mini.starter").sections.builtin_actions(),
  },
})

require("mini.ai").setup()
require("mini.surround").setup()
