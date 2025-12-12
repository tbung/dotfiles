local M = {}

---@class tillb.websearch.Engine
---@field name string
---@field url string

---@type tillb.websearch.Engine[]
M.search_engines = {
  {name = "SearXNG", url = "https://sx.cloud.tbung.de/search?q=%s", },
  {name = "Wikipedia", url = "https://en.wikipedia.org/wiki/Special:Search?search=%s", },
  {name = "Python", url = "https://docs.python.org/3/search.html?q=%s", },
  {name = "Arch Wiki", url = "https://wiki.archlinux.org/index.php?search=%s&title=Special%%3ASearch&wprov=acrw1_-1", },
}

---@param engine tillb.websearch.Engine
---@param query string
function M.search(engine, query)
  vim.ui.open(string.format(engine.url, query))
end

---@param query string
function M.search_with(query)
  if not query then
    return
  end
  vim.ui.select(M.search_engines, { prompt = "Search With", format_item = function (item)
    return item.name
  end }, function(choice)
    if choice then
      M.search(choice, query)
    end
  end)
end

---@param query string
function M.interactive(query)
  if not query then
    vim.ui.input({ prompt = "Search:" }, M.search_with)
    return
  end

  M.search_with(query)
end

return M
