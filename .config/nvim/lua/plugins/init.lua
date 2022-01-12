local execute = vim.api.nvim_command
local fn = vim.fn

if not pcall(require, "packer") then
  local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute("packadd packer.nvim")
  end
end

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost $XDG_CONFIG_HOME/nvim/lua/plugins/*.lua source <afile> | PackerCompile
autocmd BufWritePost $HOME/Projects/dotfiles/.config/nvim/lua/plugins/*.lua source <afile> | PackerCompile
autocmd BufWritePost ~//.dotfiles/./.config/nvim/lua/plugins/*.lua source <afile> | PackerCompile  " needed until plenary's path normalize is fixed
augroup end
]])

vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- Packer manages itself
  use("wbthomason/packer.nvim")

  -- Stuff that should just be builtin
  use("tpope/vim-surround")
  use("tpope/vim-fugitive")
  use("tpope/vim-repeat")
  use("tpope/vim-eunuch")
  use("wellle/targets.vim")
  use("mbbill/undotree")
  use("ggandor/lightspeed.nvim")
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })

  -- Colors
  use("folke/tokyonight.nvim")

  -- Required by almost all modern plugins
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
      },
      {
        "ThePrimeagen/git-worktree.nvim",
        config = function()
          require("git-worktree").setup()
        end,
      },
    },
    config = function()
      require("plugins.telescope")
    end,
  })

  use({
    "neovim/nvim-lspconfig",
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      "ray-x/lsp_signature.nvim",
      "onsails/lspkind-nvim",
      "williamboman/nvim-lsp-installer",
    },
    config = function()
      require("plugins.lsp")
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      -- "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
      {
        "windwp/nvim-autopairs",
        config = function()
          require("plugins.autopairs")
        end,
      },
      "f3fora/cmp-spell",
      "uga-rosa/cmp-dictionary",
    },
    config = function()
      require("plugins.cmp")
    end,
  })

  use("L3MON4D3/LuaSnip")
  use("rafamadriz/friendly-snippets")

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      "p00f/nvim-ts-rainbow",
      {
        "lewis6991/spellsitter.nvim",
        config = function()
          require("spellsitter").setup()
        end,
      },
    },
    config = function()
      require("plugins.treesitter")
    end,
  })

  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  })

  -- END OF BASICS

  use({
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.gitsigns")
    end,
  })

  use({
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        char = "│",
        use_treesitter = true,
        buftype_exclude = { "terminal" },
        filetype_exclude = { "dashboard", "alpha" },
      })
    end,
  })

  use("szw/vim-maximizer")

  use({
    "goerz/jupytext.vim",
    config = function()
      vim.g.jupytext_fmt = "py:percent"
    end,
  })
  use({ "tikhomirov/vim-glsl", ft = { "glsl" } })
  use("lervag/vimtex")
  use("HiPhish/info.vim")
  use({
    "vim-pandoc/vim-pandoc-syntax",
    config = function()
      vim.cmd([[
  augroup pandoc_syntax
  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  augroup END
  ]])
    end,
  })

  use({
    "lervag/wiki.vim",
    config = function()
      vim.g.wiki_root = "~/wiki"
      vim.g.wiki_filetypes = { "md" }
      vim.g.wiki_link_extension = ".md"
      vim.g.wiki_link_target_type = "md"
      vim.g["pandoc#syntax#conceal#urls"] = true
    end,
  })

  use({
    "norcalli/nvim-terminal.lua",
    config = function()
      require("terminal").setup()
    end,
  })

  use({
    -- "folke/which-key.nvim",
    "~/Projects/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  })

  use({
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({})
    end,
  })

  use({
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({})
    end,
  })

  use({
    "gelguy/wilder.nvim",
    config = function()
      require("plugins.wilder")
    end,
  })

  use({
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  })

  use({
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({
        global_settings = {
          save_on_toggle = false,
          save_on_change = true,
          enter_on_sendcmd = true,
          tmux_autoclose_windows = false,
          excluded_filetypes = { "harpoon" },
        },
      })
    end,
  })

  use({
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup()
      vim.notify = require("notify")
    end,
  })

  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      vim.g.nvim_tree_quit_on_open = 1
      require("nvim-tree").setup({
        auto_close = true,
        diagnostics = {
          enable = true,
        },
        view = {
          auto_resize = true,
        },
      })
    end,
  })

  use("sindrets/diffview.nvim")

  use({
    "glepnir/galaxyline.nvim",
    branch = "main",
    config = function()
      require("plugins.statusline")
    end,
    requires = "kyazdani42/nvim-web-devicons",
  })

  use({
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("plugins.dashboard").opts)
    end,
  })

  use({
    "dccsillag/magma-nvim",
    run = ":UpdateRemotePlugins",
  })

  use({
    "petertriho/nvim-scrollbar",
    config = function()
      local colors = require("tokyonight.colors").setup()

      require("scrollbar").setup({
        handle = {
          color = colors.bg_highlight,
        },
        marks = {
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
        },
      })
    end,
  })

  use({
    "monaqa/dial.nvim",
    config = function()
      require("plugins.dial")
    end,
  })

  use({
    "brymer-meneses/grammar-guard.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/nvim-lsp-installer",
    },
  })
  use({
    "kkoomen/vim-doge",
    run = function()
      vim.api.nvim_exec([[call doge#install()]])
    end,
    config = function()
      vim.g.doge_doc_standard_python = "numpy"
    end,
  })

  use({
    "nvim-neorg/neorg",
    config = function()
      require("neorg").setup({
        -- Tell Neorg what modules to load
        load = {
          ["core.defaults"] = {}, -- Load all the default modules
          ["core.keybinds"] = { -- Configure core.keybinds
            config = {
              default_keybinds = true, -- Generate the default keybinds
              neorg_leader = "<Leader>o", -- This is the default if unspecified
            },
          },
          ["core.norg.concealer"] = {
            config = {
              markup_preset = "dimmed",
            },
          }, -- Allows for use of icons
          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
              workspaces = {
                my_workspace = "~/neorg",
              },
            },
          },
          ["core.presenter"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              zen_mode = "zen-mode",
            },
          },
          ["core.norg.qol.toc"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              -- Configuration here
            },
          },
          ["core.norg.journal"] = {
            config = { -- Note that this table is optional and doesn't need to be provided
              -- Configuration here
            },
          },
          ["core.integrations.telescope"] = {},
        },
      })
    end,
    requires = "nvim-neorg/neorg-telescope",
  })
end)
