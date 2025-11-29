local M = {}

---@enum search_engines
M.search_engines = {
  ["Python"] = "https://docs.python.org/3/search.html?q=%s",
  ["Wikipedia"] = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
  ["Google"] = "https://google.com/search?q=%s",
  ["Arch Wiki"] = "https://wiki.archlinux.org/index.php?search=%s&title=Special%%3ASearch&wprov=acrw1_-1",
}

---@param engine search_engines
---@param query string
function M.search(engine, query)
  vim.ui.open(string.format(engine, query))
end

function M.search_with(query)
  if not query then
    return
  end
  vim.ui.select(vim.tbl_keys(M.search_engines), { prompt = "Search With" }, function(choice)
    if choice then
      M.search(M.search_engines[choice], query)
    end
  end)
end

function M.interactive(query)
  if not query then
    vim.ui.input({ prompt = "Search:" }, M.search_with)
    return
  end

  M.search_with(query)
end

return M
