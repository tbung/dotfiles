local ok, impatient = pcall(require, "impatient")
if ok then
  impatient.enable_profile()
end

require("options")

require("packer_compiled")

require("mappings")
require("globals")
