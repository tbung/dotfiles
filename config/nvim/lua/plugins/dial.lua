local augend = require("dial.augend")
require("dial.config").augends:register_group({
  -- default augends used when no group name is specified
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%m/%d"],
    augend.date.alias["%H:%M"],
    augend.constant.alias.bool,
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
    augend.constant.new({ elements = { "True", "False" } }),
  },
})
