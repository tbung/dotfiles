local ok, impatient = pcall(require, "impatient")

require("tillb")

local ok, _ = pcall(require, "packer_compiled")
if not ok then
  print("Plugins not installed")
end
