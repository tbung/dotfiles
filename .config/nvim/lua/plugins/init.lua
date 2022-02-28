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

    -- Required by almost all modern plugins
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")

    use("nvim-telescope/telescope-file-browser.nvim")
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
      "filipdutescu/renamer.nvim",
      branch = "master",
      requires = { { "nvim-lua/plenary.nvim" } },
      config = function()
        local renamer = require("renamer")
        local strings = require("renamer.constants").strings
        local lsp_utils = require("vim.lsp.util")
        renamer.setup()
        renamer._apply_workspace_edit = function(resp)
          local params = vim.lsp.util.make_position_params()
          local results_lsp, _ = vim.lsp.buf_request_sync(0, strings.lsp_req_rename, params)
          local client_id = results_lsp and next(results_lsp) or nil
          local client = vim.lsp.get_client_by_id(client_id)

          lsp_utils.apply_workspace_edit(resp, client.offset_encoding)
        end
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
        "f3fora/cmp-spell",
        -- "uga-rosa/cmp-dictionary",
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
      "/Users/tillb/Projects/magma-nvim",
      run = ":UpdateRemotePlugins",
      config = function()
        vim.cmd([[
      let g:magma_automatically_open_output = 0
      " let g:magma_image_provider = "kitty"
      ]])
      end,
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
        -- require("plugins.dial")
      end,
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
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("neogit").setup({
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

    -- use({ "romgrk/hologram.nvim", commit = "1614bc1d0b5875f93180e7b13975e6f0fa51e988" })
    use({ "edluffy/hologram.nvim" })

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
  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
    max_jobs = 8,
  },
})
