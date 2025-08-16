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

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = group,
  once = true,
  callback = function()
    if vim.version().minor >= 12 then
      require("vim._extui").enable({})
    end
  end,
})

vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  once = true,
  callback = function()
    vim.schedule(function()
      vim.lsp.enable({ "luals", "clangd", "basedpyright", "ruff" })
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

      vim.api.nvim_create_user_command("EditMakeprg", function()
        require("tillb.terminal").edit_makeprg()
      end, {})

      vim.api.nvim_create_user_command("TMake", function()
        require("tillb.terminal").terminal_make()
      end, {})
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
