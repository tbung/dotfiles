local group = vim.api.nvim_create_augroup("tillb", {})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.hl").on_yank({ timeout = 150 })
  end,
  group = group,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.wo.spell = false
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end,
  group = group,
})

vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  once = true,
  callback = function()
    vim.schedule(function()
      require("tillb.keymap")

      vim.diagnostic.config({
        virtual_text = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      })
      vim.lsp.enable({ "lua_ls", "texlab", "basedpyright", "ruff", "bashls", "jsonls", "clangd", "html", "asm_lsp", "ts_ls", "markdown_oxide" })

      vim.ui.input = require("tillb.input").input

      vim.api.nvim_create_user_command("EditMakeprg", function()
        require("tillb.terminal").edit_makeprg()
      end, {})

      vim.api.nvim_create_user_command("TMake", function(args)
        require("tillb.terminal").terminal_make(args)
      end, { bang = true })

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
    end)

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
  end,
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
