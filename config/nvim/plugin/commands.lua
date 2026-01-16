vim.api.nvim_create_user_command("EditMakeprg", function()
  require("tillb.terminal").edit_makeprg()
end, { force = true })

vim.api.nvim_create_user_command("Make", function(args)
  require("tillb.terminal").terminal_make(args.fargs, not args.bang)
end, { force = true, bang = true, nargs = "*" })

vim.api.nvim_create_user_command("Find", function(opts)
    local bufnr = vim.fn.bufnr(opts.args)
    if bufnr ~= -1 then
      vim.api.nvim_set_current_buf(bufnr)
      return
    end
    vim.cmd("edit " .. opts.args)
  end,
  {
    nargs = 1,
    complete = function(arglead, cmdline, cursorpos)
      return require("tillb.findfunc").find_buffers_and_files(arglead, true)
    end,
    force = true,
  }
)

vim.api.nvim_create_user_command("Search", function(args)
  local query = #args.args > 0 and args.args or nil
  if args.range == 2 and not query then
    local start = vim.fn.getpos("'<")
    local end_ = vim.fn.getpos("'>")
    query = table.concat(vim.api.nvim_buf_get_text(0, start[2] - 1, start[3] - 1, end_[2] - 1, end_[3], {}), "\n")
    query = #query > 0 and query or nil
  end
  require("tillb.websearch").interactive(query)
end, { nargs = "?", force = true, range = true })
