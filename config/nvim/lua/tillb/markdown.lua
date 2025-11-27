local M = {}

local ns = vim.api.nvim_create_namespace("tillb.markdown")

---@type table<string, fun(bufid: integer, node: TSNode, parser_inline: vim.treesitter.LanguageTree?)>
local renderers = {}

M.marks = {}

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

---comment
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

function renderers.quote(bufid, node, parser_inline)
  local row_start, col_start, row_end, col_end = node:range()

  local marks = {}

  local hl = "@markup.quote"
  local replacement

  local level = get_level(node, "block_quote", "section")

  local query_inline = vim.treesitter.query.parse("markdown_inline", [[
    (shortcut_link) @link
    ]])
  parser_inline:for_each_tree(function(stree, _)
    for id, child in query_inline:iter_captures(stree:root(), bufid, row_start, row_start + 1) do
      local text = vim.treesitter.get_node_text(child, bufid)
      if text:match("%[![a-zA-Z]+%]") == nil or _admonitions[text:lower()] == nil then
        goto continue
      end
      hl, replacement = unpack(_admonitions[text:lower()])
      local child_row_start, child_col_start, child_row_end, child_col_end = child:range()
      table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
        virt_text = { { replacement or text, hl } },
        virt_text_pos = "inline",
        hl_group = nil,
        conceal = "",
        end_row = child_row_end,
        end_col = child_col_end,
        hl_mode = "combine",
        invalidate = true,
      }))
      ::continue::
    end
  end)

  local query = vim.treesitter.query.parse("markdown", [[
    (block_quote_marker) @marker
    (block_continuation) @continuation
    ]])

  for id, child in query:iter_captures(node, bufid, row_start, row_end) do
    local name = query.captures[id]
    local child_level = get_level(child, "block_quote", "section")

    -- ignore markers of nested blocks
    if name == "marker" and child_level ~= level then
      goto continue
    end

    local child_row_start, child_col_start, child_row_end, child_col_end = child:range()

    -- while the parser considers all continuations to belong to the innermost block, we can check how many there are
    -- and only deal with the one corresponding to this level
    if name == "continuation" then
      local range = node_find_all(bufid, child, "> *")[level]
      if range == nil then
        goto continue
      end
      child_col_start = range[1] - 1
      child_col_end = range[2]
    end
    table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
      virt_text = { { "┃ ", hl } },
      virt_text_pos = "inline",
      conceal = "",
      end_row = child_row_end,
      end_col = child_col_end,
      hl_mode = "combine",
      right_gravity = false,
      invalidate = true,
    }))
    ::continue::
  end

  M.marks[node:id()] = marks
end

function renderers.hline(bufid, node)
  local row_start, col_start, row_end, col_end = node:range()
  local marks = {}
  local winid = vim.fn.bufwinid(bufid)
  local width = (
    vim.fn.getwininfo(winid)[1].width
    - vim.fn.getwininfo(winid)[1].textoff
    - col_start)
  table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, row_start, col_start, {
    virt_text = { { string.rep("─", width), "LineNr" } },
    virt_text_pos = "overlay",
    end_row = row_end,
    hl_mode = "combine",
    invalidate = true,
  }))

  M.marks[node:id()] = marks
end

function renderers.listitem(bufid, node, parser_inline)
end

function renderers.table(bufid, node, parser_inline)
  local row_start, col_start, row_end, col_end = node:range()
  local marks = {}
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

  for id, child in query:iter_captures(node, bufid, row_start, row_end) do
    ---@type Row
    local row = { node = child, cells = {} }

    local col = 1

    for subchild, _ in child:iter_children() do
      local _, cell_col_start, _, cell_col_end = subchild:range()
      if subchild:type() ~= "|" then
        if not columns[col] then
          columns[col] = {}
        end
        local cell = { node = subchild, width = cell_col_end - cell_col_start }
        table.insert(columns[col], cell)
        table.insert(row.cells, cell)
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

  -- vim.print(rows)

  for _, row in ipairs(rows) do
    local row_start, col_start, row_end, col_end = row.node:range()
    local head = row.node:type() == "pipe_table_header"
    local delim = row.node:type() == "pipe_table_delimiter_row"
    table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, row_start, col_start, {
      hl_group = nil,
      conceal = "",
      end_row = row_end,
      end_col = col_end,
      hl_mode = "combine",
      invalidate = true,
    }))
    local virts = { { delim and "├" or "│", "@punctuation.special" } }
    for _, cell in ipairs(row.cells) do
      local last = cell == row.cells[#row.cells]
      local text = vim.treesitter.get_node_text(cell.node, bufid)
      if delim then
        table.insert(virts, { string.rep("─", cell.width), "@punctuation.special" })
        table.insert(virts, { last and "┤" or "┼", "@punctuation.special" })
      else
        table.insert(virts,
          { string.format("%-" .. cell.width .. "s", text), head and "@markup.heading.markdown" or "Normal" })
        table.insert(virts, { "│", "@punctuation.special" })
      end
    end

    table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, row_start, col_start, {
      virt_text = virts,
      virt_text_pos = "inline",
      end_row = row_end,
      hl_mode = "combine",
      invalidate = true,
    }))
  end

  local header = { { "┌", "@punctuation.special" } }
  local footer = { { "└", "@punctuation.special" } }
  for _, cell in ipairs(rows[1].cells) do
    local last = cell == rows[1].cells[#rows[1].cells]
    table.insert(header, { string.rep("─", cell.width), "@punctuation.special" })
    table.insert(footer, { string.rep("─", cell.width), "@punctuation.special" })
    table.insert(header, { last and "┐" or "┬", "@punctuation.special" })
    table.insert(footer, { last and "┘" or "┴", "@punctuation.special" })
  end

  -- table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, row_start, col_start, {
  --   virt_lines = { header },
  --   virt_lines_above = true,
  --   hl_mode = "combine",
  --   invalidate = true,
  -- }))
  -- table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, row_end - 1, col_start, {
  --   virt_lines = { footer },
  --   virt_lines_above = false,
  --   hl_mode = "combine",
  --   invalidate = true,
  -- }))
  table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, row_start - 1, col_start, {
    virt_text = header,
    virt_text_pos = "overlay",
    strict = false,
    hl_mode = "combine",
    invalidate = true,
  }))
  table.insert(marks, vim.api.nvim_buf_set_extmark(bufid, ns, row_end, col_start, {
    virt_text = footer,
    virt_text_pos = "overlay",
    hl_mode = "combine",
    strict = false,
    invalidate = true,
  }))

  M.marks[node:id()] = marks
end

---@param bufid integer
local function unconceal_all(bufid)
  vim.api.nvim_buf_clear_namespace(bufid, ns, 0, -1)
end

---@param bufid integer
function M.clear_lines(bufid, start, end_)
  vim.api.nvim_buf_clear_namespace(bufid, ns, start, end_)
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

  if node:type() == "pipe_table" then
    node_start = node_start - 1
    node_end = node_end + 1
  end

  if not in_range(cursorrow, node_start, node_end) then
    return true
  end

  if node:type() == "block_quote" and not line_find_all(bufid, cursorrow, ">")[get_level(node, "block_quote", "section")] then
    return true
  end
  return (concealcursor:find(mode:lower()) ~= nil)
end

---@param bufid? integer
---@param start_row? integer
---@param end_row? integer
function M.render_range(bufid, start_row, end_row)
  bufid = bufid or 0
  local winid = vim.fn.bufwinid(bufid)
  local current_conceallevel = vim.wo[winid].conceallevel

  if current_conceallevel < 1 then
    return
  end

  local query = vim.treesitter.query.parse("markdown", [[
    (block_quote) @quote
    (thematic_break) @hline
    (list_item) @listitem
    (pipe_table) @table
  ]])

  local parser = vim.treesitter.get_parser(bufid, "markdown")
  assert(parser)

  local tree = parser:parse(true)[1]
  local parser_inline = parser:children()["markdown_inline"]

  local current_row = vim.api.nvim_win_get_cursor(winid)[1] - 1
  local current_mode = vim.api.nvim_get_mode().mode
  local current_concealcursor = vim.wo[winid].concealcursor

  for id, node in query:iter_captures(tree:root(), bufid, start_row, end_row) do
    local name = query.captures[id]
    if should_conceal(bufid, current_mode, current_concealcursor, current_row, node) then
      renderers[name](bufid, node, parser_inline)
    end
  end
end

---@param bufid? integer
---@param start_row? integer
---@param end_row? integer
function M.unrender_range(bufid, start_row, end_row)
  bufid = bufid or 0
  local winid = vim.fn.bufwinid(bufid)
  local current_conceallevel = vim.wo[winid].conceallevel

  if current_conceallevel < 1 then
    return
  end

  local query = vim.treesitter.query.parse("markdown", [[
    (block_quote) @quote
    (thematic_break) @hline
    (list_item) @listitem
    (pipe_table) @table
  ]])

  local parser = vim.treesitter.get_parser(bufid, "markdown")
  assert(parser)

  local tree = parser:parse(true)[1]

  for _, node in query:iter_captures(tree:root(), bufid, start_row, end_row) do
    if M.marks[node:id()] then
      for _, mark in ipairs(M.marks[node:id()]) do
        vim.api.nvim_buf_del_extmark(bufid, ns, mark)
      end
    end
  end
end

M.cursor = {}

---@param bufid? integer
function M.attach(bufid)
  bufid = bufid or vim.api.nvim_get_current_buf()

  M.cursor = vim.api.nvim_win_get_cursor(0)
  M.cursor[1] = M.cursor[1]

  vim.api.nvim_set_hl(0, "MarkdownCalloutNote", { link = "DiagnosticFloatingInfo" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutTip", { link = "DiagnosticFloatingOk" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutImportant", { link = "DiagnosticFloatingHint" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutWarning", { link = "DiagnosticFloatingWarn" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutCaution", { link = "DiagnosticFloatingError" })

  vim.api.nvim_create_autocmd("InsertEnter", { callback = function(args)
    unconceal_all(args.buf)
  end })
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function(args)
      local winid = vim.fn.bufwinid(args.buf)
      local row_start = vim.fn.line("w0", winid) - 1
      local row_end = vim.fn.line("w$", winid)
      M.render_range(args.buf, row_start, row_end)
    end,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function(args)
      unconceal_all(args.buf)
      local winid = vim.fn.bufwinid(args.buf)
      local row_start = vim.fn.line("w0", winid) - 1
      local row_end = vim.fn.line("w$", winid)
      M.render_range(args.buf, row_start, row_end)
      -- M.cursor = vim.api.nvim_win_get_cursor(0)
      -- M.unrender_range(args.buf, M.cursor[1] - 1, M.cursor[1])
    end,
  })

  -- vim.api.nvim_buf_attach(bufid, true,
  --   {
  --     on_lines = function(
  --         _,
  --         bufnr,
  --         changedtick,
  --         first,
  --         last_old,
  --         last_new,
  --         byte_count,
  --         deleted_codepoints,
  --         deleted_codeunits)
  --       vim.print({ first, last_old, last_new })
  --       M.clear_lines(bufnr, first, last_old)
  --       -- M.unrender_range(bufnr, first, last_old)
  --       -- M.render_range(bufnr, first, last_new)
  --     end
  --   })

  local winid = vim.fn.bufwinid(bufid)
  local row_start = vim.fn.line("w0", winid) - 1
  local row_end = vim.fn.line("w$", winid)
  M.render_range(bufid, row_start, row_end)
end

return M
