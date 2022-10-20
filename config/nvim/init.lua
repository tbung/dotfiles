local ok, impatient = pcall(require, "impatient")
if ok then
  impatient.enable_profile()
end

require("options")
require("globals")

local ok, _ = pcall(require, "packer_compiled")
if not ok then
  print("Plugins not installed")
else
  require("mappings")
end
