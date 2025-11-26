local M = {}

local ns = vim.api.nvim_create_namespace("tillb.markdown")

---@type table<string, fun(bufid: integer, node: TSNode, parser_inline: vim.treesitter.LanguageTree?)>
local renderers = {}

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

function renderers.quote(bufid, node, parser_inline)
  local row_start, col_start, row_end, col_end = node:range()

  local hl = "@markup.quote"
  local replacement

  local query_inline = vim.treesitter.query.parse("markdown_inline", [[
    (shortcut_link) @link
    ]])
  parser_inline:for_each_tree(function(stree, _)
    for id, child in query_inline:iter_captures(stree:root(), bufid, row_start, row_start + 1) do
      local text = vim.treesitter.get_node_text(child, bufid)
      if text:match("%[![a-zA-Z]+%]") == nil then
        goto continue
      end
      hl, replacement = unpack(_admonitions[text:lower()])
      local child_row_start, child_col_start, child_row_end, child_col_end = child:range()
      vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
        hl_group = nil,
        conceal = "",
        end_row = child_row_end,
        end_col = child_col_end,
        hl_mode = "combine",
        invalidate = true,
      })
      vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
        virt_text = { { replacement or text, hl } },
        virt_text_pos = "inline",
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
    (block_continuation) @marker
    ]])

  for id, child in query:iter_captures(node, bufid, row_start, row_end) do
    local child_row_start, child_col_start, child_row_end, child_col_end = child:range()
    vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
      hl_group = nil,
      conceal = "",
      end_row = child_row_end,
      end_col = child_col_end,
      hl_mode = "combine",
      invalidate = true,
    })
    vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
      virt_text = { { "┃ ", hl } },
      virt_text_pos = "inline",
      end_row = child_row_end,
      end_col = child_col_end,
      hl_mode = "combine",
      invalidate = true,
    })
  end
end

function renderers.hline(bufid, node)
  local row_start, col_start, row_end, col_end = node:range()
  local winid = vim.fn.bufwinid(bufid)
  local width = (
    vim.fn.getwininfo(winid)[1].width
    - vim.fn.getwininfo(winid)[1].textoff
    - col_start)
  vim.api.nvim_buf_set_extmark(bufid, ns, row_start, col_start, {
    virt_text = { { string.rep("─", width), "LineNr" } },
    virt_text_pos = "overlay",
    end_row = row_end,
    hl_mode = "combine",
    invalidate = true,
  })
end

function renderers.listitem(bufid, node, parser_inline)
  local row_start, col_start, row_end, col_end = node:range()
  local query_inline = vim.treesitter.query.parse("markdown_inline", [[
  (
    ((shortcut_link) @tasklist
      (#eq? @tasklist "[-]"))
  )
  ]])
  parser_inline:for_each_tree(function(stree, _)
    for id, child in query_inline:iter_captures(stree:root(), bufid, row_start, row_end) do
      local child_row_start, child_col_start, child_row_end, child_col_end = child:range()
      vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
        hl_group = nil,
        conceal = "",
        end_row = child_row_end,
        end_col = child_col_end,
        hl_mode = "combine",
        invalidate = true,
      })
      vim.api.nvim_buf_set_extmark(bufid, ns, child_row_start, child_col_start, {
        virt_text = { { "[-]", "WarningMsg" } },
        virt_text_pos = "inline",
        end_row = child_row_end,
        hl_mode = "combine",
        invalidate = true,
      })
    end
  end)
end

---@param bufid integer
---@param line integer
local function unconceal(bufid, line)
  vim.api.nvim_buf_clear_namespace(bufid, ns, line, line + 1)
end

---@param bufid integer
local function unconceal_all(bufid)
  vim.api.nvim_buf_clear_namespace(bufid, ns, 0, -1)
end

---@param q integer
---@param start integer
---@param end_ integer
---@return boolean
local function in_range(q, start, end_)
  return start <= q and q <= end_
end

---@param mode string
---@param concealcursor string
---@param cursorrow integer
---@param node_start integer
---@param node_end integer
---@return boolean
local function should_conceal(mode, concealcursor, cursorrow, node_start, node_end)
  if not in_range(cursorrow, node_start, node_end) then
    return true
  end
  return (concealcursor:find(mode) ~= nil)
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
    local node_start_row, _, node_end_row, _ = node:range()
    if should_conceal(current_mode, current_concealcursor, current_row, node_start_row, node_end_row) then
      renderers[name](bufid, node, parser_inline)
    end
  end
end

---@param bufid? integer
function M.attach(bufid)
  bufid = bufid or 0

  vim.api.nvim_set_hl(0, "MarkdownCalloutNote", { link = "DiagnosticFloatingInfo" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutTip", { link = "DiagnosticFloatingOk" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutImportant", { link = "DiagnosticFloatingHint" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutWarning", { link = "DiagnosticFloatingWarn" })
  vim.api.nvim_set_hl(0, "MarkdownCalloutCaution", { link = "DiagnosticFloatingError" })

  vim.api.nvim_create_autocmd("InsertEnter", { callback = function(args)
    unconceal_all(args.buf)
  end })
  vim.api.nvim_create_autocmd("InsertLeave", { callback = function(args)
    M.render_range(args.buf)
  end })
  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function(args)
      unconceal_all(args.buf)
      M.render_range(args.buf)
    end,
  })
end

return M
