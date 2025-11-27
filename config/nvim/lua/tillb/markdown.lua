local M = {}

local ns = vim.api.nvim_create_namespace("tillb.markdown")

---@type table<string, fun(bufid: integer, node: TSNode, parser_inline: vim.treesitter.LanguageTree?)>
local renderers = {}

---@type table<any, { mark: [integer, integer, integer, integer, vim.api.keyset.set_extmark] }[]>
M.marks = {}

---@type table<any, boolean>
M.node_shown = {}

M.marks_to_node = {}

---@param node TSNode
---@param bufid integer
---@param ns_id integer
---@param line integer
---@param col integer
---@param opts vim.api.keyset.set_extmark
function M.mark(node, bufid, ns_id, line, col, opts)
  local id = vim.api.nvim_buf_set_extmark(bufid, ns_id, line, col, opts)
  if M.marks[node:id()] == nil then
    M.marks[node:id()] = {}
  end

  M.marks_to_node[id] = node

  table.insert(M.marks[node:id()],
    { mark = { bufid, ns_id, line, col, opts }, })
end

---@param node TSNode
---@return boolean
function M.mark_from_cache(node)
  if M.marks[node:id()] ~= nil then
    for _, mark in ipairs(M.marks[node:id()]) do
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
  if M.mark_from_cache(node) then
    return
  end
  local row_start, col_start, row_end, col_end = node:range()

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
      M.mark(node, bufid, ns, child_row_start, child_col_start, {
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
    M.mark(node, bufid, ns, child_row_start, child_col_start, {
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
  end
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
  if M.mark_from_cache(node) then
    return
  end
  local row_start, col_start, row_end, col_end = node:range()
  local conceal_query = vim.treesitter.query.get("markdown_inline", "highlights")
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
      local cell_row_start, cell_col_start, cell_row_end, cell_col_end = subchild:range()
      local width = cell_col_end - cell_col_start

      parser_inline:for_each_tree(function(stree, _)
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
      vim.api.nvim_buf_get_lines(bufid, row_start, row_start + 1, true)[1]:sub(1, col_start), "")):map(function(c)
      return { c, "Normal" }
    end):totable()
    footer_prefix = vim.iter(vim.split(
      vim.api.nvim_buf_get_lines(bufid, row_end - 1, row_end, true)[1]:sub(1, col_start), "")):map(function(c)
      return { c, "Normal" }
    end):totable()
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufid, ns, { row_start, col_start }, { row_start, 0 }, { details = true })) do
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
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufid, ns, { row_end - 1, col_start }, { row_end - 1, 0 }, { details = true })) do
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
      local text = vim.treesitter.get_node_text(cell.node, bufid)
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
        M.mark(node, bufid, ns, cell_row_start, cell_col_start, {
          hl_group = "@punctuation.special",
          conceal = conceal,
          end_row = cell_row_end,
          end_col = cell_col_end,
          hl_mode = "combine",
          invalidate = true,
        })
      else
        if delim then
          M.mark(node, bufid, ns, cell_row_start, cell_col_start, {
            hl_group = "@punctuation.special",
            conceal = "─",
            end_row = cell_row_end,
            end_col = cell_col_end,
            hl_mode = "combine",
            invalidate = true,
          })
          M.mark(node, bufid, ns, cell_row_start, cell_col_start, {
            virt_text = { { string.rep("─", cell.width), "@punctuation.special" } },
            virt_text_pos = "inline",
            end_row = cell_row_end,
            hl_mode = "combine",
            invalidate = true,
          })
        else
          M.mark(node, bufid, ns, cell_row_start, cell_col_start, {
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

  M.mark(node, bufid, ns, row_start, col_start, {
    virt_lines = { header },
    virt_lines_above = true,
    hl_mode = "combine",
    invalidate = true,
  })
  M.mark(node, bufid, ns, row_end - 1, col_start, {
    virt_lines = { footer },
    virt_lines_above = false,
    hl_mode = "combine",
    invalidate = true,
  })
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

M.last_render_time = nil

---@param bufid integer
function M.refresh_viewport(bufid)
  -- local time = vim.uv.hrtime()
  -- if M.last_render_time and time - M.last_render_time < 100 then
  --   return
  -- end
  unconceal_all(bufid)
  local winid = vim.fn.bufwinid(bufid)
  local row_start = vim.fn.line("w0", winid) - 1
  local row_end = vim.fn.line("w$", winid)
  M.render_range(bufid, row_start, row_end)
  -- M.last_render_time = time
  -- vim.print(vim.uv.hrtime() - time)
end

vim.api.nvim_set_hl(0, "MarkdownCalloutNote", { link = "DiagnosticFloatingInfo" })
vim.api.nvim_set_hl(0, "MarkdownCalloutTip", { link = "DiagnosticFloatingOk" })
vim.api.nvim_set_hl(0, "MarkdownCalloutImportant", { link = "DiagnosticFloatingHint" })
vim.api.nvim_set_hl(0, "MarkdownCalloutWarning", { link = "DiagnosticFloatingWarn" })
vim.api.nvim_set_hl(0, "MarkdownCalloutCaution", { link = "DiagnosticFloatingError" })

---@param bufid? integer
function M.attach(bufid)
  bufid = bufid or vim.api.nvim_get_current_buf()

  vim.api.nvim_create_autocmd("InsertEnter", { callback = function(args)
    unconceal_all(args.buf)
  end })
  vim.api.nvim_create_autocmd("InsertLeave", { callback = function(args)
    M.refresh_viewport(args.buf)
  end })
  vim.api.nvim_create_autocmd("CursorMoved", { callback = function(args)
    M.refresh_viewport(args.buf)
  end })
  vim.api.nvim_create_autocmd("WinScrolled", { callback = function(args)
    M.refresh_viewport(args.buf)
  end })

  vim.api.nvim_buf_attach(bufid, true,
    {
      on_lines = function(
          _,
          bufnr,
          changedtick,
          first,
          last_old,
          last_new,
          byte_count,
          deleted_codepoints,
          deleted_codeunits)
        M.refresh_viewport(bufnr)
      end,
    })

  M.refresh_viewport(bufid)
end

function M.test()
  local bufid = vim.api.nvim_get_current_buf()
  vim.uv.update_time()
  local time = vim.uv.now()
  for i = 1, 500 do
    M.refresh_viewport(bufid)
  end
  vim.uv.update_time()
  vim.print(vim.uv.now() - time)
end

return M
