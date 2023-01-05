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
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    use("lewis6991/impatient.nvim")

    use({
      "nvim-telescope/telescope.nvim",
      tag = "0.1.0",
      requires = { { "nvim-lua/plenary.nvim" } },
    })

    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    use({
      "catppuccin/nvim",
      as = "catppuccin",
    })

    use("mbbill/undotree")
    use("tpope/vim-fugitive")
    use({
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({
          attach_to_untracked = true,
        })
      end,
    })
    use("tpope/vim-repeat")
    use("tpope/vim-eunuch")
    use("wellle/targets.vim")
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup({})
      end,
    })
    use({
      "jinh0/eyeliner.nvim",
      config = function()
        require("eyeliner").setup({
          highlight_on_key = true,
        })
      end,
    })

    use({
      "VonHeikemen/lsp-zero.nvim",
      requires = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },

        -- Snippets
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },
      },
    })
    use("jose-elias-alvarez/null-ls.nvim")
    use({ "WhoIsSethDaniel/mason-tool-installer.nvim" })

    use({
      "mfussenegger/nvim-dap",
    })
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")
    use("mfussenegger/nvim-dap-python")
    use("nvim-telescope/telescope-dap.nvim")

    use({
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup({})
      end,
    })

    use({
      "hkupty/iron.nvim",
    })

    use({
      "karb94/neoscroll.nvim",
    })

    use({
      "echasnovski/mini.nvim",
    })

    use({
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      },
    })

    use({
      "vigoux/notifier.nvim",
      config = function()
        require("notifier").setup({})
      end,
    })

    use({
      "feline-nvim/feline.nvim",
      after = "catppuccin",
      requires = "kyazdani42/nvim-web-devicons",
    })

    use({
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup({})
      end,
    })

    use({
      "ThePrimeagen/harpoon",
    })

    use({
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup({})
      end,
    })
  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
    max_jobs = 8,
  },
})
