local M = {}

function M.reload(pack)
  package.loaded[pack] = nil
  return require(pack)
end

return M
