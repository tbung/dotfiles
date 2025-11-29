local M = {}

local ns = vim.api.nvim_create_namespace("tillb.markdown")
local group = vim.api.nvim_create_augroup("tillb.markdown", {})

---@param s string
---@param pattern string
function string.find_all(s, pattern)
  ---@type Range2[]
  local matches = {}
  local offset = 1
  while offset do
    local start, end_ = s:find(pattern, offset)
    if not start or not end_ then
      return matches
    end
    table.insert(matches, { start, end_ })
    offset = end_ + 1
  end

  return matches
end

---@class tillb.markdown.Node
---@field capture? string
---@field bufid integer
---@field node TSNode
---@field id any
---@field type string
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---@field private _text? string
local Node = {}
Node.__index = Node

---@param bufid integer
---@param node TSNode
---@param capture? string
---@return self
function Node.new(bufid, node, capture)
  local self = setmetatable({}, Node)
  self.__index = self
  self.bufid = bufid
  self.node = node
  self.capture = capture
  self.id = node:id()
  self.type = node:type()
  local row_start, col_start, row_end, col_end = node:range()
  self.row_start = row_start
  self.row_end = row_end
  self.col_start = col_start
  self.col_end = col_end
  return self
end

---@return string
function Node:text()
  if not self._text then
    self._text = vim.treesitter.get_node_text(self.node, self.bufid, {})
  end
  return self._text
end

---@param line integer
---@return boolean
function Node:contains_line(line)
  return self.row_start <= line and line < self.row_end
end

---@param type? string
---@param parent? string
---@return integer
function Node:get_level(type, parent)
  ---@type TSNode?
  local node = self.node

  type = type or self.type

  local level = 0
  while node and node:type() ~= parent do
    if node:type() == type then
      level = level + 1
    end
    node = node:parent()
  end

  return level
end

---@return fun(): tillb.markdown.Node
function Node:iter_children()
  return vim.iter(self.node:iter_children()):map(function(node)
    return Node.new(self.bufid, node)
  end) --[[@as fun(): tillb.markdown.Node]] --
end

---@param pattern string
---@return Range2[]
function Node:find_all(pattern)
  return self:text():find_all(pattern)
end

---@class tillb.markdown.Renderer
---@field private marks table<any, { mark: [integer, integer, integer, integer, vim.api.keyset.set_extmark] }[]>
---@field private nodes table<any, tillb.markdown.Node>
---@field bufid integer
---@field winid integer
---@field parser_inline vim.treesitter.LanguageTree
local Renderer = {}
Renderer.__index = Renderer

---@param scope TSNode
function Renderer:clear_cache(scope)
  for node_id, _ in pairs(self.marks) do
    local node = self.nodes[node_id]
    if node and vim.treesitter.node_contains(scope, { node.row_start, node.col_start, node.row_end, node.col_end }) then
      self.marks[node_id] = nil
    end
  end
end

---@param node tillb.markdown.Node
---@param line integer
---@param col integer
---@param opts vim.api.keyset.set_extmark
function Renderer:mark(node, line, col, opts)
  local id = vim.api.nvim_buf_set_extmark(self.bufid, ns, line, col, opts)

  if self.marks[node.id] == nil then
    self.marks[node.id] = {}
  end

  table.insert(self.marks[node.id],
    { mark = { self.bufid, ns, line, col, opts } })
end

---@param node tillb.markdown.Node
---@return boolean
function Renderer:mark_from_cache(node)
  self.nodes[node.id] = node
  if self.marks[node.id] ~= nil then
    for _, mark in ipairs(self.marks[node.id]) do
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

---@type table<string, fun(renderer: tillb.markdown.Renderer, node: tillb.markdown.Node, parser_inline: vim.treesitter.LanguageTree?)>
local handlers = {}

function handlers.quote(renderer, node)
  if renderer:mark_from_cache(node) then
    return
  end
  -- local row_start, col_start, row_end, col_end = node:range()

  local hl = "@markup.quote"
  local replacement

  local level = node:get_level("block_quote", "section")

  local query_inline = vim.treesitter.query.parse("markdown_inline", [[
    (shortcut_link) @link
  ]])
  renderer:for_each_inline_capture(query_inline, function(child)
    local text = child:text()
    if text:match("%[![a-zA-Z]+%]") == nil or _admonitions[text:lower()] == nil then
      goto continue
    end
    hl, replacement = unpack(_admonitions[text:lower()])
    renderer:mark(child, child.row_start, child.col_start, {
      virt_text = { { replacement or text, hl } },
      virt_text_pos = "inline",
      hl_group = nil,
      conceal = "",
      end_row = child.row_end,
      end_col = child.col_end,
      hl_mode = "combine",
      invalidate = true,
    })
    ::continue::
  end, node.row_start, node.row_start + 1)

  local query = vim.treesitter.query.parse("markdown", [[
    (block_quote_marker) @marker
    (block_continuation) @continuation
    ]])

  renderer:for_each_capture(query, function(child)
    local child_level = child:get_level("block_quote", "section")

    -- ignore markers of nested blocks
    if child.capture == "marker" and child_level ~= level then
      goto continue
    end

    -- local child_row_start, child_col_start, child_row_end, child_col_end = child.node:range()
    local mark_start = child.col_start
    local mark_end = child.col_end

    -- while the parser considers all continuations to belong to the innermost block, we can check how many there are
    -- and only deal with the one corresponding to this level
    if child.capture == "continuation" then
      local range = child:find_all("> ?")[level]
      if range == nil then
        goto continue
      end
      mark_start = range[1] - 1
      mark_end = range[2]
    end
    renderer:mark(child, child.row_start, mark_start, {
      virt_text = { { "┃ ", hl } },
      virt_text_pos = "inline",
      conceal = "",
      end_row = child.row_end,
      end_col = mark_end,
      hl_mode = "combine",
      right_gravity = false,
      invalidate = true,
    })
    ::continue::
  end, node.row_start, node.row_end)
end

function handlers.hline(renderer, node)
  if renderer:mark_from_cache(node) then
    return
  end
  local width = (
    vim.fn.getwininfo(renderer.winid)[1].width
    - vim.fn.getwininfo(renderer.winid)[1].textoff
    - node.col_start)
  renderer:mark(node, node.row_start, node.col_start, {
    virt_text = { { string.rep("─", width), "LineNr" } },
    virt_text_pos = "overlay",
    end_row = node.row_end,
    hl_mode = "combine",
    invalidate = true,
  })
end

function handlers.table(renderer, node)
  if renderer:mark_from_cache(node) then
    return
  end
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
  ---@field node tillb.markdown.Node
  ---@field width integer
  ---@field target_width integer

  ---@class Row
  ---@field cells Cell[]
  ---@field node tillb.markdown.Node

  ---@type Row[]
  local rows = {}
  ---
  ---@type Cell[][]
  local columns = {}

  renderer:for_each_capture_in_node(node, query, function(child)
    ---@type Row
    local row = { node = child, cells = {} }

    local col = 1
    local prev_end = child.col_start - 1

    for subchild in child:iter_children() do
      -- since space between pipe and cell content are not caught we need to account for them by
      -- comparing to the previous cell's end
      local width = subchild.col_end - subchild.col_start + (subchild.col_start - prev_end - 1)
      prev_end = subchild.col_end

      renderer:for_each_inline_capture(conceal_query, function(cnode, meta)
        if cnode.capture == "conceal" then
          width = width - (cnode.col_end - cnode.col_start) + #meta.conceal
        end
      end, subchild.row_start, subchild.row_end, subchild.col_start, subchild.col_end + 1)
      local cell = { node = subchild, width = width }
      table.insert(row.cells, cell)
      if subchild.type ~= "|" then
        if not columns[col] then
          columns[col] = {}
        end
        table.insert(columns[col], cell)
        col = col + 1
      end
    end
    table.insert(rows, row)
  end, node.row_start, node.row_end)

  for _, col in ipairs(columns) do
    local width = 0
    for _, cell in ipairs(col) do
      width = math.max(width, cell.width)
    end
    for _, cell in ipairs(col) do
      cell.target_width = width
    end
  end

  local header_prefix = {}
  local footer_prefix = {}
  if node.col_start > 0 then
    header_prefix = vim.iter(vim.split(
          vim.api.nvim_buf_get_lines(renderer.bufid, node.row_start, node.row_start + 1, true)[1]:sub(1, node.col_start),
          ""))
        :map(function(c)
          return { c, "Normal" }
        end):totable()
    footer_prefix = vim.iter(vim.split(
          vim.api.nvim_buf_get_lines(renderer.bufid, node.row_end - 1, node.row_end, true)[1]:sub(1, node.col_start), ""))
        :map(function(c)
          return { c, "Normal" }
        end):totable()
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(renderer.bufid, ns, { node.row_start, node.col_start }, { node.row_start, 0 }, { details = true })) do
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
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(renderer.bufid, ns, { node.row_end - 1, node.col_start }, { node.row_end - 1, 0 }, { details = true })) do
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
    local head = row.node.type == "pipe_table_header"
    local delim = row.node.type == "pipe_table_delimiter_row"
    for _, cell in ipairs(row.cells) do
      local first = cell == row.cells[1]
      local last = cell == row.cells[#row.cells]
      if cell.node.type == "|" then
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
        renderer:mark(node, cell.node.row_start, cell.node.col_start, {
          hl_group = "@punctuation.special",
          conceal = conceal,
          end_row = cell.node.row_end,
          end_col = cell.node.col_end,
          hl_mode = "combine",
          invalidate = true,
        })
      else
        if delim then
          renderer:mark(node, cell.node.row_start, cell.node.col_start, {
            hl_group = "@punctuation.special",
            conceal = "─",
            end_row = cell.node.row_end,
            end_col = cell.node.col_end,
            hl_mode = "combine",
            invalidate = true,
          })
          renderer:mark(node, cell.node.row_start, cell.node.col_start, {
            virt_text = { { string.rep("─", cell.target_width), "@punctuation.special" } },
            virt_text_pos = "inline",
            end_row = cell.node.row_end,
            hl_mode = "combine",
            invalidate = true,
          })
        else
          renderer:mark(node, cell.node.row_start, cell.node.col_start, {
            virt_text = { { string.rep(" ", cell.target_width - cell.width), "@punctuation.special" } },
            virt_text_pos = "inline",
            end_row = cell.node.row_end,
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
    if cell.node.type == "|" then
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
      table.insert(header, { string.rep("─", cell.target_width + 1), "@punctuation.special" })
      table.insert(footer, { string.rep("─", cell.target_width + 1), "@punctuation.special" })
    end
  end

  header = vim.list_extend(header_prefix, header)
  footer = vim.list_extend(footer_prefix, footer)

  renderer:mark(node, node.row_start, node.col_start, {
    virt_lines = { header },
    virt_lines_above = true,
    hl_mode = "combine",
    invalidate = true,
  })
  renderer:mark(node, node.row_end - 1, node.col_start, {
    virt_lines = { footer },
    virt_lines_above = false,
    hl_mode = "combine",
    invalidate = true,
  })
end

function Renderer:unconceal_all()
  vim.api.nvim_buf_clear_namespace(self.bufid, ns, 0, -1)
end

---@param mode string
---@param concealcursor string
---@param cursorrow integer
---@return boolean
function Node:should_conceal(mode, concealcursor, cursorrow)
  if not self:contains_line(cursorrow) then
    return true
  end

  if self.type == "block_quote" and not vim.api.nvim_buf_get_lines(self.bufid, cursorrow, cursorrow + 1, true)[1]:find_all(">")[self:get_level("block_quote", "section")] then
    return true
  end
  return (concealcursor:find(mode:lower()) ~= nil)
end

local query = vim.treesitter.query.parse("markdown", [[
    (block_quote) @quote
    (thematic_break) @hline
    (pipe_table) @table
]])

---@return tillb.markdown.Node
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
    self.root = Node.new(self.bufid, tree:root())
  end
  return self.root
end

---@param query_inline vim.treesitter.Query
---@param callback fun(node: tillb.markdown.Node, meta: vim.treesitter.query.TSMetadata)
---@param row_start? integer
---@param row_end? integer
---@param col_start? integer
---@param col_end? integer
function Renderer:for_each_inline_capture(query_inline, callback, row_start, row_end, col_start, col_end)
  self:get_root()
  self.parser_inline:for_each_tree(function(tree, _)
    for id, node, meta in query_inline:iter_captures(tree:root(), self.bufid, row_start, row_end, { start_col = col_start, end_col = col_end }) do
      local name = query_inline.captures[id]
      callback(Node.new(self.bufid, node, name), meta)
    end
  end)
end

---@param query_local? vim.treesitter.Query
---@param callback fun(node: tillb.markdown.Node)
---@param start? integer
---@param end_? integer
function Renderer:for_each_capture(query_local, callback, start, end_)
  self:for_each_capture_in_node(self:get_root(), query_local, callback, start, end_)
end

---@param node tillb.markdown.Node
---@param query_local? vim.treesitter.Query
---@param callback fun(node: tillb.markdown.Node)
---@param start? integer
---@param end_? integer
function Renderer:for_each_capture_in_node(node, query_local, callback, start, end_)
  query_local = query_local or query
  for id, child in query_local:iter_captures(node.node, self.bufid, start, end_) do
    local name = query_local.captures[id]
    callback(Node.new(self.bufid, child, name))
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
    if node:should_conceal(current_mode, current_concealcursor, current_row) then
      -- if this was previously not rendered we need to rerender all children too
      if self.marks[node.node:id()] == nil then
        self:clear_cache(node.node)
      end
      handlers[node.capture](self, node)
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
  require("jit.p").start("lri1", "/tmp/profile")
  for _ = 1, 500 do
    renderer:refresh_viewport()
  end
  require("jit.p").stop()
  vim.uv.update_time()
  vim.print(vim.uv.now() - time)
end

return M
