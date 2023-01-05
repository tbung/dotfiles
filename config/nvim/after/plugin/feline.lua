local ctp_feline = require("catppuccin.groups.integrations.feline")
ctp_feline.setup({})

require("feline").setup({
  components = ctp_feline.get(),
})

local components = require("feline.default_components").winbar.icons
components.active[1][1].provider = {
    name = "file_info",
    opts = {
      type = "relative",
    },
}
components.active[1][1].short_provider = {
    name = "file_info",
    opts = {
      type = "relative-short",
    },
}
components.inactive[1][1].provider = {
    name = "file_info",
    opts = {
      type = "relative",
    },
}
components.inactive[1][1].short_provider = {
    name = "file_info",
    opts = {
      type = "relative-short",
    },
}

require("feline").winbar.setup()
