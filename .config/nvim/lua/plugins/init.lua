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
augroup end
]])

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost $HOME/Projects/dotfiles/.config/nvim/lua/plugins/*.lua source <afile> | PackerCompile
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
      use("jose-elias-alvarez/null-ls.nvim"),
      use("ray-x/lsp_signature.nvim"),
      use("onsails/lspkind-nvim"),
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
      "saadparwaiz1/cmp_luasnip",
      {
        "windwp/nvim-autopairs",
        config = function()
          require("plugins.autopairs")
        end,
      },
    },
    config = function()
      require("plugins.cmp")
    end,
  })

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
    "renerocksai/telekasten.nvim",
    config = function()
      local home = vim.fn.expand("~/wiki")
      require("telekasten").setup({
        home = home,
        take_over_my_home = true,
        auto_set_filetype = false,
        dailies = home .. "/" .. "journal",
        extension = ".md",
        follow_creates_nonexisting = true,
        dailies_create_nonexisting = true,
        weeklies_create_nonexisting = true,
        close_after_yanking = false,
        insert_after_inserting = true,
        tag_notation = "#tag",
        command_palette_theme = "ivy",
        show_tags_theme = "ivy",
        subdirs_in_links = true,
        template_handling = "smart",
        new_note_location = "smart",
      })
    end,
  })

  use({
    "norcalli/nvim-terminal.lua",
    config = function()
      require("terminal").setup()
    end,
  })

  use({
    "folke/which-key.nvim",
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
end)
