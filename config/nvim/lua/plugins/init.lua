local execute = vim.api.nvim_command
local fn = vim.fn

if not pcall(require, "packer") then
  local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute("packadd packer.nvim")
  end
end

vim.cmd([[packadd packer.nvim]])

return require("packer").startup({
  function(use)
    -- Packer manages itself
    use("wbthomason/packer.nvim")

    use("lewis6991/impatient.nvim")

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
    use({ "catppuccin/nvim", as = "catppuccin" })

    -- Required by almost all modern plugins
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")

    -- #############
    -- # Telescope #
    -- #############
    use({
      "nvim-telescope/telescope.nvim",
      config = function()
        require("plugins.telescope")
      end,
    })
    use({
      "nvim-telescope/telescope-file-browser.nvim",
      requires = "nvim-telescope/telescope.nvim",
    })
    use({
      "nvim-telescope/telescope-project.nvim",
      requires = "nvim-telescope/telescope.nvim",
    })
    use({
      "nvim-telescope/telescope-symbols.nvim",
      requires = "nvim-telescope/telescope.nvim",
    })
    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      requires = "nvim-telescope/telescope.nvim",
      run = "make",
    })
    use({
      "ThePrimeagen/git-worktree.nvim",
      requires = "nvim-telescope/telescope.nvim",
      config = function()
        require("git-worktree").setup()
      end,
    })

    -- #######
    -- # LSP #
    -- #######
    use({
      "neovim/nvim-lspconfig",
      config = function()
        require("plugins.lsp")
      end,
    })
    use("jose-elias-alvarez/null-ls.nvim")
    use("onsails/lspkind-nvim")
    use("williamboman/nvim-lsp-installer")
    use({
      "filipdutescu/renamer.nvim",
      branch = "master",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("renamer").setup({})
      end,
    })

    -- ##############
    -- # Completion #
    -- ##############
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "f3fora/cmp-spell",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "lukas-reineke/cmp-under-comparator",
        "saadparwaiz1/cmp_luasnip",
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
      "mfussenegger/nvim-dap",
      config = function()
        require("plugins.dap")
      end,
    })
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")
    use("mfussenegger/nvim-dap-python")
    use("nvim-telescope/telescope-dap.nvim")

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
          filetype_exclude = { "dashboard", "alpha", "starter", "neo-tree" },
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
    use("lervag/vimtex")
    use("fladson/vim-kitty")
    use({
      "HiPhish/info.vim",
      config = function()
        vim.g.infoprg = "/opt/homebrew/opt/texinfo/bin/info"
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
        require("which-key").setup({
          plugins = {
            spelling = {
              enabled = true,
            },
          },
        })
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
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      },
      config = function()
        -- Unless you are still migrating, remove the deprecated commands from v1.x
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

        require("neo-tree").setup({
          close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
          window = {
            width = 30,
          },
          filesystem = {
            follow_current_file = true, -- This will find and focus the file in the active buffer every
            -- time the current file is changed while the tree is open.
            use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
            -- instead of relying on nvim autocmd events.
          },
          buffers = {
            follow_current_file = true, -- This will find and focus the file in the active buffer every
            -- time the current file is changed while the tree is open.
          },
        })
      end,
    })

    use("sindrets/diffview.nvim")

    use({
      "feline-nvim/feline.nvim",
      config = function()
        -- require("plugins.statusline")
        require("feline").setup({
          components = require("catppuccin.core.integrations.feline"),
        })
        require("feline").winbar.setup()
      end,
      requires = "kyazdani42/nvim-web-devicons",
    })

    use({
      vim.fn.expand("~/Projects/magma-nvim"),
      run = ":UpdateRemotePlugins",
      config = function()
        vim.cmd([[
      let g:magma_automatically_open_output = 0
      let g:magma_image_provider = "kitty"
      ]])
      end,
    })

    use({
      "petertriho/nvim-scrollbar",
      config = function()
        local colors = require("tokyonight.colors").setup({})

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
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("neogit").setup({
          disable_commit_confirmation = true,
          disable_builtin_notifications = true,
          kind = "split",
          signs = {
            -- { CLOSED, OPENED }
            section = { "", "" },
            item = { "", "" },
            hunk = { "", "" },
          },
        })
      end,
    })

    use({
      "ThePrimeagen/refactoring.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
        -- load refactoring Telescope extension
        require("telescope").load_extension("refactoring")

        -- remap to open the Telescope refactoring menu in visual mode
        vim.api.nvim_set_keymap(
          "v",
          "<leader>vrr",
          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
          { noremap = true }
        )

        -- You can also use below = true here to to change the position of the printf
        -- statement (or set two remaps for either one). This remap must be made in normal mode.
        vim.api.nvim_set_keymap(
          "n",
          "<leader>vrp",
          ":lua require('refactoring').debug.printf({below = false})<CR>",
          { noremap = true }
        )

        -- Print var: this remap should be made in visual mode
        vim.api.nvim_set_keymap(
          "v",
          "<leader>vrv",
          ":lua require('refactoring').debug.print_var({})<CR>",
          { noremap = true }
        )

        -- Cleanup function: this remap should be made in normal mode
        vim.api.nvim_set_keymap(
          "n",
          "<leader>vrc",
          ":lua require('refactoring').debug.cleanup({})<CR>",
          { noremap = true }
        )
      end,
    })

    use({
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
    })

    use({
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup({})
      end,
    })

    use({
      "mickael-menu/zk-nvim",
      config = function()
        require("zk").setup({
          -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
          -- it's recommended to use "telescope" or "fzf"
          picker = "telescope",

          lsp = {
            -- `config` is passed to `vim.lsp.start_client(config)`
            config = {
              cmd = { "zk", "lsp" },
              name = "zk",
              -- on_attach = ...
              -- etc, see `:h vim.lsp.start_client()`
            },

            -- automatically attach buffers in a zk notebook that match the given filetypes
            auto_attach = {
              enabled = true,
              filetypes = { "markdown" },
            },
          },
        })
      end,
    })

    use({
      "nvim-telescope/telescope-bibtex.nvim",
      requires = {
        { "nvim-telescope/telescope.nvim" },
      },
    })

    use({
      "danymat/neogen",
      config = function()
        require("neogen").setup({})
      end,
      requires = "nvim-treesitter/nvim-treesitter",
    })

    use({
      "chentoast/marks.nvim",
      config = function()
        require("marks").setup({
          default_mappings = true,
          -- builtin_marks = { ".", "<", ">", "^" },
          builtin_marks = {},
          cyclic = true,
        })
      end,
    })

    use("simrat39/symbols-outline.nvim")

    use({
      "echasnovski/mini.nvim",
      config = function()
        require("mini.starter").setup({})
      end,
    })

    use("rcarriga/neotest-python")
    use({
      "rcarriga/neotest",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-python")({
              runner = "pytest",
              -- dap = { justMyCode = false, console = "integratedTerminal" },
            }),
          },
        })
      end,
    })
  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
    max_jobs = 8,
  },
})
