vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",

  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/stevearc/oil.nvim",

  "https://github.com/folke/snacks.nvim",
}, { load = false })

local group = vim.api.nvim_create_augroup("tillb.pack", {})

vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  once = true,
  callback = function(args)
    vim.schedule(function()
      require("mini.surround").setup({})

      vim.cmd.packadd("mini.pick")
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

      vim.cmd.packadd("vim-eunuch")

      vim.cmd.packadd("vim-fugitive")
      vim.cmd.packadd("gitsigns.nvim")
      vim.cmd.packadd("diffview.nvim")
      require("diffview").setup({
        file_panel = {
          listing_style = "list",
          win_config = { position = "bottom", height = 10, win_opts = {} },
        },
      })

      vim.cmd.packadd("nvim-treesitter")
    end)
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = group,
  callback = function(args)
    require("nvim-treesitter").install({ vim.treesitter.language.get_lang(vim.bo.filetype) })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    require("treesitter-context").setup({ enable = true })
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

-- NOTE: these have to be loaded immediately to work properly
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

require("snacks").setup({ image = { enabled = true } })
