local ok, impatient = pcall(require, "impatient")
if ok then
  impatient.enable_profile()
end

require("options")

local ok, _ = pcall(require, "packer_compiled")
if not ok then
  print("Plugins not installed")
else
  require("mappings")
  require("globals")
end
