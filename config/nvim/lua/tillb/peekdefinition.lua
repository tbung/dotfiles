local M = {}

local function preview_location_callback(_, result, method, _)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.islist(result) then
    vim.lsp.util.preview_location(result[1], {})
  else
    vim.lsp.util.preview_location(result, {})
  end
end

M.peek_definition = function()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

return M
