local dial = require("dial")

dial.augends["custom#boolean"] = dial.common.enum_cyclic({
  name = "boolean",
  strlist = { "true", "false" },
})
table.insert(dial.config.searchlist.normal, "custom#boolean")

dial.augends["custom#boolean_upper"] = dial.common.enum_cyclic({
  name = "boolean_upper",
  strlist = { "True", "False" },
})
table.insert(dial.config.searchlist.normal, "custom#boolean_upper")
