local group = vim.api.nvim_create_augroup("tillb.events", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.hl").on_yank({ timeout = 150 })
  end,
  group = group,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    local ok, _ = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    require("tillb.marks").update_signs(args.buf)
    require("tillb.marks").attach(args.buf)
  end,
})

---@type fun(kind: 'begin'|'report'|'end', percent: integer, msg: string): nil
local report_progress = {}

vim.api.nvim_create_autocmd("LspProgress", {
  group = group,
  callback = function(ev)
    local value = ev.data.params.value

    if value.kind == "begin" then
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      local progress = { kind = "progress", title = client.name }

      report_progress[ev.data.client_id] = vim.schedule_wrap(function(kind, percent, msg)
        progress.status = kind == "end" and "success" or "running"
        progress.percent = percent
        progress.id = vim.api.nvim_echo({ { msg } }, kind ~= "report", progress)
      end)
    else
      local message = value.message and (value.title .. ": " .. value.message) or value.title
      report_progress[ev.data.client_id]("report", value.percentage, message)
    end
  end,
})
