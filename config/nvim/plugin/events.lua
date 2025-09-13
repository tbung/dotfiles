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
      vim.lsp.enable({ "lua_ls", "texlab", "basedpyright", "ruff", "bashls", "jsonls", "clangd" })

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
          vim.cmd("find " .. opts.args)
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
