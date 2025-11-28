local M = {}

local ns = vim.api.nvim_create_namespace("tillb.markdown")
local group = vim.api.nvim_create_augroup("tillb.markdown", {})

---@class Range
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
local Range = {}

---@param node TSNode
---@return Range
function Range:from_node(node)
  local o = setmetatable({}, self)
  local row_start, col_start, row_end, col_end = node:range()
  o.row_start = row_start
  o.row_end = row_end
  o.col_start = col_start
  o.col_end = col_end
  return o
end

---@param line integer
---@return boolean
function Range:contains_line(line)
  return self.row_start <= line and line < self.row_end
end

---@class Node
---@field capture string
---@field node TSNode
---@field range Range
local Node = {}

---@param node TSNode
---@param capture? string
---@return self
function Node:new(node, capture)
  local o = {}
  setmetatable({}, self)
  o.node = node
  o.capture = capture
  o.range = Range:from_node(node)
  return o
end

---@param line integer
---@return boolean
function Node:contains_line(line)
  return self.range:contains_line(line)
end

---@class TableRow: Node
---@field cells Node[]
local TableRow = setmetatable({}, Node)

---@param node TSNode
---@return self
function TableRow:new(node)
  local o = setmetatable({}, self)
  o.node = node
  o.range = Range:from_node(node)
  o.cells = {}
  return o
end

---@class tillb.markdown.Renderer
---@field private marks table<any, { mark: [integer, integer, integer, integer, vim.api.keyset.set_extmark] }[]>
---@field private nodes table<any, TSNode>
---@field bufid integer
---@field winid integer
---@field parser_inline vim.treesitter.LanguageTree
local Renderer = {}
Renderer.__index = Renderer

---@param scope TSNode
function Renderer:clear_cache(scope)
  for node_id, _ in pairs(self.marks) do
    local node = self.nodes[node_id]
    if node and vim.treesitter.node_contains(scope, { node:range() }) then
      self.marks[node_id] = nil
    end
  end
end

---@param node TSNode
---@param line integer
---@param col integer
---@param opts vim.api.keyset.set_extmark
function Renderer:mark(node, line, col, opts)
  local id = vim.api.nvim_buf_set_extmark(self.bufid, ns, line, col, opts)

  if self.marks[node:id()] == nil then
    self.marks[node:id()] = {}
  end

  table.insert(self.marks[node:id()],
    { mark = { self.bufid, ns, line, col, opts } })
end

---@param node TSNode
---@return boolean
function Renderer:mark_from_cache(node)
  self.nodes[node:id()] = node
  if self.marks[node:id()] ~= nil then
    for _, mark in ipairs(self.marks[node:id()]) do
      vim.api.nvim_buf_set_extmark(unpack(mark.mark))
    end
    return true
  end
  return false
end

local _admonitions = {
  -- https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts
  ["[!note]"] = { "MarkdownCalloutNote", " Note" },
  ["[!tip]"] = { "MarkdownCalloutTip", "󰌶 Tip" },
  ["[!important]"] = { "MarkdownCalloutImportant", "󰅾 Important" },
  ["[!warning]"] = { "MarkdownCalloutWarning", " Warning" },
  ["[!caution]"] = { "MarkdownCalloutCaution", "󰳦 Caution" },
  -- https://help.obsidian.md/callouts
  ["[!info]"] = { "MarkdownCalloutNote", " Info" },
  ["[!todo]"] = { "MarkdownCalloutNote", " Todo" },
  ["[!abstract]"] = { "MarkdownCalloutNote", "󰨸 Abstract" },
  ["[!summary]"] = { "MarkdownCalloutNote", "󰨸 Summary" },
  ["[!tldr]"] = { "MarkdownCalloutNote", "󰨸 Tldr" },
  ["[!hint]"] = { "MarkdownCalloutTip", "󰌶 Hint" },
  ["[!success]"] = { "MarkdownCalloutTip", " Success" },
  ["[!check]"] = { "MarkdownCalloutTip", " Check" },
  ["[!done]"] = { "MarkdownCalloutTip", " Done" },
  ["[!question]"] = { "MarkdownCalloutWarn", " Question" },
  ["[!help]"] = { "MarkdownCalloutWarn", " Help" },
  ["[!faq]"] = { "MarkdownCalloutWarn", " FAQ" },
  ["[!attention]"] = { "MarkdownCalloutWarn", " Attention" },
  ["[!failure]"] = { "MarkdownCalloutCaution", " Failure" },
  ["[!fail]"] = { "MarkdownCalloutCaution", " Failure" },
  ["[!missing]"] = { "MarkdownCalloutCaution", " Missing" },
  ["[!danger]"] = { "MarkdownCalloutCaution", "󱐌 Danger" },
  ["[!error]"] = { "MarkdownCalloutCaution", "󱐌 Error" },
  ["[!bug]"] = { "MarkdownCalloutCaution", "󰨰 Bug" },
  ["[!example]"] = { "MarkdownCalloutImportant", "󰉹 Example" },
  ["[!quote]"] = { "@markup.quote", "󱆨 Quote" },
  ["[!cite]"] = { "@markup.quote", "󱆨 Cite" },
}

---@param node TSNode
---@param type? string
---@param parent? string
---@return integer
local function get_level(node, type, parent)
  type = type or node:type()

  local level = 0
  while node and node:type() ~= parent do
    if node:type() == type then
      level = level + 1
    end
    node = node:parent()
  end

  return level
end

---@param bufid integer
---@param linenr integer
---@param query string
---
---@return Range2[]
local function line_find_all(bufid, linenr, query)
  ---@type Range2[]
  local matches = {}
  local text = vim.api.nvim_buf_get_lines(bufid, linenr, linenr + 1, true)[1]
  while #text do
    local start, end_ = text:find(query)
    if not start or not end_ then
      return matches
    end
    table.insert(matches, { start, end_ })
    text = text:sub(end_ + 1)
  end

  return matches
end

---@param bufid integer
---@param node TSNode
---@param query string
---
---@return Range2[]
local function node_find_all(bufid, node, query)
  ---@type Range2[]
  local matches = {}
  local text = vim.treesitter.get_node_text(node, bufid)
  local offset = 1
  while offset do
    local start, end_ = text:find(query, offset)
    if not start or not end_ then
      return matches
    end
    table.insert(matches, { start, end_ })
    offset = end_ + 1
  end

  return matches
end

---@type table<string, fun(renderer: tillb.markdown.Renderer, node: TSNode, parser_inline: vim.treesitter.LanguageTree?)>
local handlers = {}

function handlers.quote(renderer, node)
  if renderer:mark_from_cache(node) then
    return
  end
  local row_start, col_start, row_end, col_end = node:range()

  local hl = "@markup.quote"
  local replacement

  local level = get_level(node, "block_quote", "section")

  local query_inline = vim.treesitter.query.parse("markdown_inline", [[
    (shortcut_link) @link
  ]])
  renderer:for_each_inline_capture(query_inline, function(child)
    local text = vim.treesitter.get_node_text(child.node, renderer.bufid)
    if text:match("%[![a-zA-Z]+%]") == nil or _admonitions[text:lower()] == nil then
      goto continue
    end
    hl, replacement = unpack(_admonitions[text:lower()])
    local child_row_start, child_col_start, child_row_end, child_col_end = child.node:range()
    renderer:mark(child.node, child_row_start, child_col_start, {
      virt_text = { { replacement or text, hl } },
      virt_text_pos = "inline",
      hl_group = nil,
      conceal = "",
      end_row = child_row_end,
      end_col = child_col_end,
      hl_mode = "combine",
      invalidate = true,
    })
    ::continue::
  end, row_start, row_start + 1)

  local query = vim.treesitter.query.parse("markdown", [[
    (block_quote_marker) @marker
    (block_continuation) @continuation
    ]])

  renderer:for_each_capture(query, function(child)
    local child_level = get_level(child.node, "block_quote", "section")

    -- ignore markers of nested blocks
    if child.capture == "marker" and child_level ~= level then
      goto continue
    end

    local child_row_start, child_col_start, child_row_end, child_col_end = child.node:range()

    -- while the parser considers all continuations to belong to the innermost block, we can check how many there are
    -- and only deal with the one corresponding to this level
    if child.capture == "continuation" then
      local range = node_find_all(renderer.bufid, child.node, "> ?")[level]
      if range == nil then
        goto continue
      end
      child_col_start = range[1] - 1
      child_col_end = range[2]
    end
    renderer:mark(child.node, child_row_start, child_col_start, {
      virt_text = { { "┃ ", hl } },
      virt_text_pos = "inline",
      conceal = "",
      end_row = child_row_end,
      end_col = child_col_end,
      hl_mode = "combine",
      right_gravity = false,
      invalidate = true,
    })
    ::continue::
  end, row_start, row_end)
end

function handlers.hline(renderer, node)
  if renderer:mark_from_cache(node) then
    return
  end
  local row_start, col_start, row_end, col_end = node:range()
  local width = (
    vim.fn.getwininfo(renderer.winid)[1].width
    - vim.fn.getwininfo(renderer.winid)[1].textoff
    - col_start)
  renderer:mark(node, row_start, col_start, {
    virt_text = { { string.rep("─", width), "LineNr" } },
    virt_text_pos = "overlay",
    end_row = row_end,
    hl_mode = "combine",
    invalidate = true,
  })
end

function handlers.table(renderer, node)
  if renderer:mark_from_cache(node) then
    return
  end
  local row_start, col_start, row_end, col_end = node:range()
  local conceal_query = vim.treesitter.query.get("markdown_inline", "highlights")
  assert(conceal_query)
  local query = vim.treesitter.query.parse("markdown", [[
  (pipe_table_delimiter_row) @delim
  [
    (pipe_table_header)
    (pipe_table_row)
  ] @row
  ]])

  ---@class Cell
  ---@field node TSNode
  ---@field width integer

  ---@class Row
  ---@field cells Cell[]
  ---@field node TSNode

  ---@type Row[]
  local rows = {}
  ---
  ---@type Cell[][]
  local columns = {}

  for id, child in query:iter_captures(node, renderer.bufid, row_start, row_end) do
    ---@type Row
    local row = { node = child, cells = {} }

    local col = 1

    for subchild, _ in child:iter_children() do
      local cell_row_start, cell_col_start, cell_row_end, cell_col_end = subchild:range()
      local width = cell_col_end - cell_col_start

      renderer.parser_inline:for_each_tree(function(stree, _)
        for id, n, meta in conceal_query:iter_captures(stree:root(), bufid, cell_row_start, cell_row_end, { start_col = cell_col_start, end_col = cell_col_end + 1 }) do
          local name = conceal_query.captures[id]
          if name == "conceal" then
            local _, start, _, end_ = n:range()
            width = width - (end_ - start) + #meta.conceal
          end
        end
      end)
      local cell = { node = subchild, width = width }
      table.insert(row.cells, cell)
      if subchild:type() ~= "|" then
        if not columns[col] then
          columns[col] = {}
        end
        table.insert(columns[col], cell)
        col = col + 1
      end
    end
    table.insert(rows, row)
  end

  for _, col in ipairs(columns) do
    local width = 0
    for _, cell in ipairs(col) do
      width = math.max(width, cell.width)
    end
    for _, cell in ipairs(col) do
      cell.width = width
    end
  end

  local header_prefix = {}
  local footer_prefix = {}
  if col_start > 0 then
    header_prefix = vim.iter(vim.split(
      vim.api.nvim_buf_get_lines(renderer.bufid, row_start, row_start + 1, true)[1]:sub(1, col_start), "")):map(function(
        c)
      return { c, "Normal" }
    end):totable()
    footer_prefix = vim.iter(vim.split(
      vim.api.nvim_buf_get_lines(renderer.bufid, row_end - 1, row_end, true)[1]:sub(1, col_start), "")):map(function(c)
      return { c, "Normal" }
    end):totable()
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(renderer.bufid, ns, { row_start, col_start }, { row_start, 0 }, { details = true })) do
      if mark[4].conceal ~= nil then
        header_prefix[mark[3] + 1][1] = mark[4].conceal
        for i = mark[3] + 2, (mark[4].end_col or mark[3] + 2) do
          header_prefix[i][1] = ""
        end
      end
      if mark[4].virt_text and mark[4].virt_text_pos == "inline" then
        for i, virt_text in ipairs(mark[4].virt_text) do
          table.insert(header_prefix, mark[3] + i, virt_text)
        end
      end
    end
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(renderer.bufid, ns, { row_end - 1, col_start }, { row_end - 1, 0 }, { details = true })) do
      if mark[4].conceal ~= nil then
        footer_prefix[mark[3] + 1][1] = mark[4].conceal
        for i = mark[3] + 2, (mark[4].end_col or mark[3] + 2) do
          footer_prefix[i][1] = ""
        end
      end
      if mark[4].virt_text and mark[4].virt_text_pos == "inline" then
        for i, virt_text in ipairs(mark[4].virt_text) do
          table.insert(footer_prefix, mark[3] + i, virt_text)
        end
      end
    end
  end


  for _, row in ipairs(rows) do
    local row_start, col_start, row_end, col_end = row.node:range()
    local head = row.node:type() == "pipe_table_header"
    local delim = row.node:type() == "pipe_table_delimiter_row"
    for _, cell in ipairs(row.cells) do
      local first = cell == row.cells[1]
      local last = cell == row.cells[#row.cells]
      local text = vim.treesitter.get_node_text(cell.node, renderer.bufid)
      local cell_row_start, cell_col_start, cell_row_end, cell_col_end = cell.node:range()
      if cell.node:type() == "|" then
        local conceal = "│"
        if delim then
          if first then
            conceal = "├"
          elseif last then
            conceal = "┤"
          else
            conceal = "┼"
          end
        end
        renderer:mark(node, cell_row_start, cell_col_start, {
          hl_group = "@punctuation.special",
          conceal = conceal,
          end_row = cell_row_end,
          end_col = cell_col_end,
          hl_mode = "combine",
          invalidate = true,
        })
      else
        if delim then
          renderer:mark(node, cell_row_start, cell_col_start, {
            hl_group = "@punctuation.special",
            conceal = "─",
            end_row = cell_row_end,
            end_col = cell_col_end,
            hl_mode = "combine",
            invalidate = true,
          })
          renderer:mark(node, cell_row_start, cell_col_start, {
            virt_text = { { string.rep("─", cell.width), "@punctuation.special" } },
            virt_text_pos = "inline",
            end_row = cell_row_end,
            hl_mode = "combine",
            invalidate = true,
          })
        else
          renderer:mark(node, cell_row_start, cell_col_start, {
            virt_text = { { string.rep(" ", cell.width - (cell_col_end - cell_col_start)), "@punctuation.special" } },
            virt_text_pos = "inline",
            end_row = cell_row_end,
            hl_mode = "combine",
            invalidate = true,
          })
        end
      end
    end
  end

  local header = {}
  local footer = {}
  for _, cell in ipairs(rows[1].cells) do
    local last = cell == rows[1].cells[#rows[1].cells]
    local first = cell == rows[1].cells[1]
    if cell.node:type() == "|" then
      if last then
        table.insert(header, { "┐", "@punctuation.special" })
        table.insert(footer, { "┘", "@punctuation.special" })
      elseif first then
        table.insert(header, { "┌", "@punctuation.special" })
        table.insert(footer, { "└", "@punctuation.special" })
      else
        table.insert(header, { "┬", "@punctuation.special" })
        table.insert(footer, { "┴", "@punctuation.special" })
      end
    else
      table.insert(header, { string.rep("─", cell.width + 1), "@punctuation.special" })
      table.insert(footer, { string.rep("─", cell.width + 1), "@punctuation.special" })
    end
  end

  header = vim.list_extend(header_prefix, header)
  footer = vim.list_extend(footer_prefix, footer)

  renderer:mark(node, row_start, col_start, {
    virt_lines = { header },
    virt_lines_above = true,
    hl_mode = "combine",
    invalidate = true,
  })
  renderer:mark(node, row_end - 1, col_start, {
    virt_lines = { footer },
    virt_lines_above = false,
    hl_mode = "combine",
    invalidate = true,
  })
end

function Renderer:unconceal_all()
  vim.api.nvim_buf_clear_namespace(self.bufid, ns, 0, -1)
end

---@param q integer
---@param start integer
---@param end_ integer
---@return boolean
local function in_range(q, start, end_)
  return start <= q and q < end_
end

---@param bufid integer
---@param mode string
---@param concealcursor string
---@param cursorrow integer
---@param node TSNode
---@return boolean
local function should_conceal(bufid, mode, concealcursor, cursorrow, node)
  local node_start, _, node_end, _ = node:range()

  if not in_range(cursorrow, node_start, node_end) then
    return true
  end

  if node:type() == "block_quote" and not line_find_all(bufid, cursorrow, ">")[get_level(node, "block_quote", "section")] then
    return true
  end
  return (concealcursor:find(mode:lower()) ~= nil)
end

local query = vim.treesitter.query.parse("markdown", [[
    (block_quote) @quote
    (thematic_break) @hline
    (pipe_table) @table
]])

function Renderer:get_root()
  if not self.root then
    local parser = vim.treesitter.get_parser(self.bufid, "markdown")
    assert(parser)
    parser:register_cbs({ on_changedtree = function()
      self.root = nil
      self.parser_inline = nil
    end }, false)

    local tree = parser:parse(true)[1]
    self.parser_inline = parser:children()["markdown_inline"]
    self.root = tree:root()
  end
  return self.root
end

---@param query_inline vim.treesitter.Query
---@param callback fun(node: Node)
---@param start? integer
---@param end_? integer
function Renderer:for_each_inline_capture(query_inline, callback, start, end_)
  self:get_root()
  self.parser_inline:for_each_tree(function(tree, _)
    for id, node in query_inline:iter_captures(tree:root(), self.bufid, start, end_) do
      local name = query_inline.captures[id]
      callback(Node:new(node, name))
    end
  end)
end

---@param query_local? vim.treesitter.Query
---@param callback fun(node: Node)
---@param start? integer
---@param end_? integer
function Renderer:for_each_capture(query_local, callback, start, end_)
  query_local = query_local or query
  for id, node in query_local:iter_captures(self:get_root(), self.bufid, start, end_) do
    local name = query_local.captures[id]
    callback(Node:new(node, name))
  end
end

---@param start? integer
---@param end_? integer
function Renderer:render_range(start, end_)
  local current_conceallevel = vim.wo[self.winid].conceallevel

  if current_conceallevel < 1 then
    return
  end

  local current_row = vim.api.nvim_win_get_cursor(self.winid)[1] - 1
  local current_mode = vim.api.nvim_get_mode().mode
  local current_concealcursor = vim.wo[self.winid].concealcursor

  self:for_each_capture(query, function(node)
    if should_conceal(self.bufid, current_mode, current_concealcursor, current_row, node.node) then
      -- if this was previously not rendered we need to rerender all children too
      if self.marks[node.node:id()] == nil then
        self:clear_cache(node.node)
      end
      handlers[node.capture](self, node.node)
    else
      self:clear_cache(node.node)
    end
  end, start, end_)
end

function Renderer:refresh_viewport()
  -- local time = vim.uv.hrtime()
  -- if M.last_render_time and time - M.last_render_time < 100 then
  --   return
  -- end
  self:unconceal_all()
  local row_start = vim.fn.line("w0", self.winid) - 1
  local row_end = vim.fn.line("w$", self.winid)
  self:render_range(row_start, row_end)
  -- M.last_render_time = time
  -- vim.print(vim.uv.hrtime() - time)
end

---@param bufid integer
---@return tillb.markdown.Renderer
function Renderer.new(bufid)
  ---@type tillb.markdown.Renderer
  local o = setmetatable({}, Renderer)
  o.bufid = bufid
  o.marks = {}
  o.nodes = {}
  o.winid = vim.fn.bufwinid(bufid)
  return o
end

vim.api.nvim_set_hl(0, "MarkdownCalloutNote", { link = "DiagnosticFloatingInfo" })
vim.api.nvim_set_hl(0, "MarkdownCalloutTip", { link = "DiagnosticFloatingOk" })
vim.api.nvim_set_hl(0, "MarkdownCalloutImportant", { link = "DiagnosticFloatingHint" })
vim.api.nvim_set_hl(0, "MarkdownCalloutWarning", { link = "DiagnosticFloatingWarn" })
vim.api.nvim_set_hl(0, "MarkdownCalloutCaution", { link = "DiagnosticFloatingError" })

---@type table<integer, tillb.markdown.Renderer>
M.renderers = {}

---@type table<integer, integer>
M.autocmds = {}

---@param bufid? integer
function M.attach(bufid)
  bufid = bufid or vim.api.nvim_get_current_buf()

  local renderer = Renderer.new(bufid)
  local autocmds = {}

  table.insert(autocmds, vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    callback = function(args)
      M.renderers[args.buf]:unconceal_all()
    end,
    buffer = bufid,
  }))
  table.insert(autocmds, vim.api.nvim_create_autocmd({ "InsertLeave", "CursorMoved", "WinScrolled" }, {
    callback = function(args)
      M.renderers[args.buf]:refresh_viewport()
    end,
    buffer = bufid,
  }))

  vim.api.nvim_buf_attach(bufid, true, { on_lines = function(_, bufnr)
    M.renderers[bufnr]:refresh_viewport()
  end })

  renderer:refresh_viewport()
  M.renderers[bufid] = renderer
end

function M.test()
  local bufid = vim.api.nvim_get_current_buf()
  vim.uv.update_time()
  local renderer = Renderer.new(bufid)
  local time = vim.uv.now()
  for _ = 1, 500 do
    renderer:refresh_viewport()
  end
  vim.uv.update_time()
  vim.print(vim.uv.now() - time)
end

return M
