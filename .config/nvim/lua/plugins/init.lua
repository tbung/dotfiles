local execute = vim.api.nvim_command
local fn = vim.fn

if not pcall(require, 'packer') then
    local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
      execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
      execute 'packadd packer.nvim'
    end
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost $XDG_CONFIG_HOME/nvim/lua/plugins/*.lua source <afile> | PackerCompile
  augroup end
]])

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(
  function(use)
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Stuff that should just be builtin
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-eunuch'
    use 'wellle/targets.vim'
    use 'mbbill/undotree'
    use 'ggandor/lightspeed.nvim'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- Colors
    use 'folke/tokyonight.nvim'

    -- Required by almost all modern plugins
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-telescope/telescope-project.nvim',
        'nvim-telescope/telescope-symbols.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
	  run = 'make'
        },
        {
          'ThePrimeagen/git-worktree.nvim',
          config = function ()
            require('git-worktree').setup()
          end
        }
      },
      config = function ()
        require('plugins.telescope')
      end,
    }

    use {
      'neovim/nvim-lspconfig',
      requires = {
        use 'jose-elias-alvarez/null-ls.nvim',
        use 'ray-x/lsp_signature.nvim',
        use 'onsails/lspkind-nvim',
      },
      config = function ()
        require('plugins.lsp')
      end,
    }

    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lua',
        'saadparwaiz1/cmp_luasnip',
        {
          'windwp/nvim-autopairs',
          config = function ()
            require('plugins.autopairs')
          end,
        }
      },
      config = function ()
        require('plugins.cmp')
      end
    }

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        'nvim-treesitter/playground',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'RRethy/nvim-treesitter-textsubjects',
        'p00f/nvim-ts-rainbow',
         {
           'lewis6991/spellsitter.nvim',
           config = function()
             require('spellsitter').setup()
           end
         },
      },
      config = function ()
        require('plugins.treesitter')
      end
    }
  end
)

