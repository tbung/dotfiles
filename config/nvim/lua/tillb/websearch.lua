local M = {}

---@enum search_engines
M.search_engines = {
  ["Python"] = "https://docs.python.org/3/search.html?q=%s",
  ["Wikipedia"] = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
  ["Google"] = "https://google.com/search?q=%s",
}

---@param engine search_engines
---@param query string
M.search = function(engine, query)
  vim.ui.open(string.format(engine, query))
end

M.interactive = function()
  vim.ui.input({ prompt = "Search:" }, function(input)
    vim.ui.select(vim.tbl_keys(M.search_engines), { prompt = "Search With" }, function(item)
      M.search(M.search_engines[item], input)
    end)
  end)
end

return M
