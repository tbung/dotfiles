local group = vim.api.nvim_create_augroup("tillb", {})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.hl").on_yank({ timeout = 150 })
  end,
  group = group,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
  group = group,
})

vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  once = true,
  callback = function()
    vim.schedule(function()
      require("tillb.keymap")

      -- NOTE: Could load this on CmdLineEnter, but that causes a flicker that bugs me
      if vim.version().minor >= 12 then
        require("vim._extui").enable({})
      end

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
      vim.lsp.enable({ "lua_ls", "texlab", "basedpyright", "ruff", "bashls", "jsonls", "clangd" })

      vim.api.nvim_create_user_command("EditMakeprg", function()
        require("tillb.terminal").edit_makeprg()
      end, {})

      vim.api.nvim_create_user_command("TMake", function(args)
        require("tillb.terminal").terminal_make(args)
      end, { bang = true })
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    require("tillb.marks").update_signs(args.buf)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("UserLspFormat", {}),
  callback = function(args)
    require("tillb.marks").update_signs(args.buf)
  end,
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = vim.api.nvim_create_augroup("CmdlineAutocompletion", { clear = true }),
  callback = function(ev)
    local cmdline = vim.fn.getcmdline()
    local cmdline_cmd = vim.fn.split(cmdline, " ")[1]
    local is_relevant = cmdline_cmd == "find" or cmdline_cmd == "fin" or cmdline_cmd == "help" or cmdline_cmd == "h" or
        cmdline_cmd == "buffer" or cmdline_cmd == "buf" or cmdline_cmd == "b"

    if ev.event == "CmdlineChanged" and is_relevant and cmdline:match("^%a* ") then
      vim.fn.wildtrigger()
    end
  end,
})
