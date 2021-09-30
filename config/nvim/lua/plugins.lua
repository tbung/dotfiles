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

    use 'tpope/vim-surround'               -- Easy surrounding things with brackets
    use 'tpope/vim-fugitive'               -- In-vim git stuff
    use 'tpope/vim-commentary'             -- Easy comment-out stuff
    use 'tpope/vim-repeat'                 -- Enable plugin motion repeat
    use 'tpope/vim-eunuch'                 -- Unix commands made easy
    use 'tpope/vim-abolish'		   -- Smart replace words
    -- use 'tpope/vim-obsession'
    use 'tpope/vim-vinegar'

    use 'justinmk/vim-sneak'               -- Fast moving around
    use 'wellle/targets.vim'
    use 'junegunn/vim-easy-align'          -- Align stuff easily
    use 'mbbill/undotree'

    -- Colors
    use 'folke/tokyonight.nvim'

    -- FZF
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-project.nvim',
            'nvim-telescope/telescope-media-files.nvim',
            {
                'ThePrimeagen/git-worktree.nvim',
                config = function ()
                    require('git-worktree').setup()
                end
            }
        },
        config = function ()
            require('config.telescope')
        end,
    }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'ray-x/lsp_signature.nvim'
    use 'onsails/lspkind-nvim'

    -- use {
    --     'hrsh7th/nvim-compe',
    --     config = function ()
    --         require('config.compe')
    --     end
    -- }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
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
    use 'kyazdani42/nvim-web-devicons'
    use {
        'folke/trouble.nvim',
        config = function ()
            require('trouble').setup()
        end,
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        setup = function ()
            vim.g.indent_blankline_char = "│"
            vim.g.indent_blankline_use_treesitter = true
        end
    }
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require('config.autopairs')
        end,
    }
    use 'puremourning/vimspector'
    use 'szw/vim-maximizer'

    use 'ludovicchabant/vim-gutentags'     -- CTAGS management
    use {
        'norcalli/nvim-colorizer.lua',
        config = function ()
            require 'colorizer'.setup()
        end,
    }

    -- Language-specific stuff
    use { 'psf/black',  tag = 'stable', ft = {'python'} }
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

    use {
        'jbyuki/nabla.nvim',
        config = vim.cmd[[
        nnoremap <F5> :lua require("nabla").action()<CR>
        ]],
    }

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
        -- event = "BufReadPre", -- this will only start session saving when an actual file was opened
        module = "persistence",
        config = function()
            require("persistence").setup()
            -- restore the session for the current directory
            vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})

            -- restore the last session
            vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

            -- stop Persistence => session won't be saved on exit
            vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})

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
        config = function ()
            require('config.harpoon')
        end
    }

end)

