vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { load = false })

vim.pack.add({
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",
})

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
}, {
  load = function()
    vim.cmd.packadd("nvim-treesitter")
    vim.cmd.packadd("nvim-treesitter-context")

    local group = vim.api.nvim_create_augroup("tillb.pack", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        local installed = require("nvim-treesitter").get_installed("parsers")
        if vim.tbl_contains(installed, lang) then
          return
        end
        local langs = require("nvim-treesitter").get_available()
        if vim.tbl_contains(langs, lang) then
          require("nvim-treesitter").install({ lang })
        end
      end,
    })

    vim.api.nvim_create_autocmd("PackChanged", {
      group = group,
      callback = function(args)
        local spec = args.data.spec

        if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
          vim.notify("nvim-treesitter was updated, updating parsers", vim.log.levels.INFO)

          vim.schedule(function()
            require("nvim-treesitter").update()
          end)
        end
      end,
    })
  end
})

vim.pack.add({ "https://github.com/echasnovski/mini.nvim" }, {
  load = function()
    vim.schedule(function()
      vim.cmd.packadd("mini.nvim")
      require("mini.surround").setup({})

      require("mini.pick").setup({
        options = { content_from_bottom = true },
        window = {
          config = {
            width = 10000,
            height = math.floor(0.5 * vim.o.lines),
            relative = "editor",
            border = { "", { "─", "MsgSeparator" }, "", "", "", " ", "", "" },
            row = vim.o.lines - vim.o.cmdheight,
            col = 0,
          },
        },
      })
      vim.ui.select = require("mini.pick").ui_select

      require("mini.extra").setup()
    end)
  end,
})

vim.pack.add({ "https://github.com/stevearc/oil.nvim" }, {
  load = function()
    vim.cmd.packadd("oil.nvim")
    local permission_hlgroups = {
      ["-"] = "NonText",
      ["r"] = "DiagnosticSignWarn",
      ["w"] = "DiagnosticSignError",
      ["x"] = "DiagnosticSignOk",
    }

    require("oil").setup({
      columns = {
        {
          "permissions",
          highlight = function(permission_str)
            local hls = {}
            for i = 1, #permission_str do
              local char = permission_str:sub(i, i)
              table.insert(hls, { permission_hlgroups[char], i - 1, i })
            end
            return hls
          end,
        },
        { "size", highlight = "Special" },
        { "mtime", highlight = "Number" },
        { "icon", add_padding = true },
      },
    })
  end,
})

vim.pack.add({ "https://github.com/folke/snacks.nvim" }, {
  load = function()
    vim.cmd.packadd("snacks.nvim")
    require("snacks").setup({ image = { enabled = true } })
  end,
})
