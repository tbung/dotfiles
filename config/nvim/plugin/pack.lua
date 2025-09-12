vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",

  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/j-hui/fidget.nvim",

  "https://github.com/MeanderingProgrammer/render-markdown.nvim",

  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/ravitemer/mcphub.nvim",
}, { load = false })

---@param cmd string|string[]
local function command_stub(cmd, callback)
  if type(cmd) == "string" then
    cmd = { cmd }
  end

  vim.iter(cmd):map(function(c)
    vim.api.nvim_create_user_command(c, function(args)
      vim.iter(cmd):map(vim.api.nvim_del_user_command) -- remove stub commands
      print("test")
      callback()
      vim.cmd(c)
    end, {})
  end)
end

local group = vim.api.nvim_create_augroup("tillb-pack", {})

vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  once = true,
  callback = function(args)
    vim.schedule(function()
      require("fidget").setup({})
      require("mini.surround").setup({})
      require("mini.pick").setup({})
      vim.ui.select = require("mini.pick").ui_select

      vim.cmd.packadd("vim-fugitive")
      vim.cmd.packadd("vim-eunuch")
      vim.cmd.packadd("gitsigns.nvim")

      command_stub({ "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd", "MCPHub" },
        function(cargs)
          vim.cmd.packadd("plenary.nvim")
          vim.cmd.packadd("mcphub.nvim")
          vim.cmd.packadd("codecompanion.nvim")

          require("mcphub").setup({ cmd = "npx", cmdArgs = { "mcp-hub@latest" } })
          require("codecompanion").setup({
            extensions = {
              mcphub = {
                callback = "mcphub.extensions.codecompanion",
                opts = { make_vars = true, make_slash_commands = true, show_result_in_chat = true },
              },
            },
          })
        end)
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
require("catppuccin").setup({
  float = { transparent = true },

  custom_highlights = function(colors)
    return {
      Folded = { bg = colors.mantle },
      Normal = { bg = colors.none },
      NormalNC = { bg = colors.none },
      Pmenu = { fg = colors.overlay2, bg = colors.surface0 },
      PmenuMatch = { fg = colors.text, bg = colors.surface0 },
      PmenuSel = { fg = colors.overlay2, bg = colors.surface1 },
      PmenuMatchSel = { fg = colors.text, bg = colors.surface1 },
      WinBar = { style = { "bold" } },

      -- NOTE: without this, light-mode makes the cursor hard to see
      TermCursor = { bg = colors.none },
      TermCursorNC = { bg = colors.none },
    }
  end,

  integrations = {
    blink_cmp = true,
    gitsigns = true,
    mini = true,
    markdown = true,
    snacks = { enabled = true },
    native_lsp = {
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
        ok = { "undercurl" },
      },
    },
  },
})
vim.cmd.colorscheme("catppuccin")

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
