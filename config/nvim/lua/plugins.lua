local execute = vim.api.nvim_command
local fn = vim.fn

if not pcall(require, 'packer') then
    local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
      execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
      execute 'packadd packer.nvim'
    end
end
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- use({ "wbthomason/packer.nvim", opt = true })

    use 'tpope/vim-surround'               -- Easy surrounding things with brackets
    use 'tpope/vim-fugitive'               -- In-vim git stuff
    -- use 'tpope/vim-commentary'             -- Easy comment-out stuff
    use 'tpope/vim-repeat'                 -- Enable plugin motion repeat
    use 'tpope/vim-eunuch'                 -- Unix commands made easy
    use 'tpope/vim-abolish'		   -- Smart replace words
    -- use 'tpope/vim-obsession'
    use 'tpope/vim-vinegar'

    -- use 'justinmk/vim-sneak'               -- Fast moving around
    use 'ggandor/lightspeed.nvim'

    use 'wellle/targets.vim'
    use 'junegunn/vim-easy-align'          -- Align stuff easily
    use 'mbbill/undotree'

    -- Colors
    use 'folke/tokyonight.nvim'

    -- FZF
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use {
        'ThePrimeagen/git-worktree.nvim',
        config = function ()
            require('git-worktree').setup()
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-project.nvim',
            'nvim-telescope/telescope-symbols.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
        config = function ()
            require('config.telescope')
        end,
    }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'ray-x/lsp_signature.nvim'
    use 'onsails/lspkind-nvim'

    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function ()
            require('config.cmp')
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        requires = {
            { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
            "nvim-treesitter/nvim-treesitter-textobjects",
            "RRethy/nvim-treesitter-textsubjects",
            'p00f/nvim-ts-rainbow',
            'romgrk/nvim-treesitter-context',
        },
        config = function ()
            require('config.treesitter')
        end,
    }
    use {
        'folke/trouble.nvim',
        config = function ()
            require('trouble').setup()
        end,
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function ()
            require('indent_blankline').setup({
                char = "│",
                use_treesitter = true,
                buftype_exclude = {"terminal"},
                filetype_exclude = {"dashboard"}
            })
        end,
    }
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require('config.autopairs')
        end,
    }
    -- use 'puremourning/vimspector'
    use 'szw/vim-maximizer'
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'mfussenegger/nvim-dap-python'

    use 'ludovicchabant/vim-gutentags'     -- CTAGS management
    use {
        'norcalli/nvim-colorizer.lua',
        config = function ()
            require 'colorizer'.setup()
        end,
    }

    -- Language-specific stuff
    use { 'psf/black',  tag = 'stable', ft = {'python'} }
    use {
        'goerz/jupytext.vim',
        config = function ()
            vim.g.jupytext_fmt = "py:percent"
        end
    }
    use { 'prettier/vim-prettier', run = 'npm install', ft = {'javascript', 'typescript', 'json'} }
    use { 'tikhomirov/vim-glsl', ft = {'glsl'} }

    -- Writing
    use { 'godlygeek/tabular', ft = 'markdown' }
    use 'lervag/vimtex'                    -- Better latex support
    use 'vimwiki/vimwiki'

    -- Snippets
    use {
        'L3MON4D3/LuaSnip',
        config = function ()
            require('config.luasnip')
        end
    }
    use 'rafamadriz/friendly-snippets'

    use 'HiPhish/info.vim'
    use {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        wants = "plenary.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("config.gitsigns")
        end,
    }

    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup()
        end
    }

    use {
        "norcalli/nvim-terminal.lua",
        config = function()
            require("terminal").setup()
        end
    }

    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
            }
        end
    }

    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use { 'michaelb/sniprun', run = 'bash ./install.sh'}

    use({
        "simrat39/symbols-outline.nvim",
        cmd = { "SymbolsOutline" },
    })

    use {
        'lewis6991/spellsitter.nvim',
        config = function()
            require('spellsitter').setup()
        end
    }

    use {
        'gelguy/wilder.nvim',
        config = function ()
            require('config.wilder')
        end
    }

    use {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        module = "persistence",
        config = function()
            require("persistence").setup()
        end,
    }

    use {
        'kosayoda/nvim-lightbulb',
        config = function()
            vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
        end
    }

    use {
        'ThePrimeagen/harpoon',
    }

    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        },
        config = function ()
            require('config.refactoring')
        end
    }

    use {
        "rcarriga/nvim-notify",
        config = function ()
            require("notify").setup()
            vim.notify = require("notify")
        end
    }

    use {
        'kyazdani42/nvim-tree.lua',
        cmd = { "NvimTreeOpen", "NvimTreeToggle" },
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require'nvim-tree'.setup {
                diagnostics = {
                    enable = true,
                },
                view = {
                    auto_resize = true,
                }
            }
        end
    }

    use "jbyuki/venn.nvim"

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use 'sindrets/diffview.nvim'
end)
