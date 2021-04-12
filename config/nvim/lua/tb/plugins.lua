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

return require('packer').startup(function()

    use 'tpope/vim-surround'               -- Easy surrounding things with brackets
    use 'tpope/vim-fugitive'               -- In-vim git stuff
    use 'tpope/vim-commentary'             -- Easy comment-out stuff
    use 'tpope/vim-repeat'                 -- Enable plugin motion repeat
    use 'tpope/vim-dispatch'               -- Dispatch console cmd
    use 'tpope/vim-eunuch'                 -- Unix commands made easy
    use 'tpope/vim-abolish'		-- Smart replace words

    use 'justinmk/vim-sneak'               -- Fast moving around
    use 'wellle/targets.vim'
    use 'junegunn/vim-easy-align'          -- Align stuff easily
    use 'mbbill/undotree'

    -- Colors
    use 'connorholyday/vim-snazzy'

    -- FZF
    -- use 'junegunn/fzf'                     -- Fzf integration
    -- use 'junegunn/fzf.vim'                 -- Preconfigured fzf integration
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- IDE-like features
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/completion-nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    use 'jpalardy/vim-slime'
    use 'ludovicchabant/vim-gutentags'     -- CTAGS management
    use { 'ms-jpq/chadtree', branch = 'chad', run = 'python3 -m chadtree deps' }
    use 'liuchengxu/vista.vim'             -- Tag tree sidebar
    -- use 'dense-analysis/ale'               -- Syntax checker, requires checker itself
    -- to be installed

    -- Language-specific stuff
    -- use 'numirias/semshi', { 'do': ':UpdateRemoteuseins', 'for': ['python'] }
    use { 'psf/black',  branch = 'stable', ft = {'python'} }
    use { 'prettier/vim-prettier', run = 'npm install', ft = {'javascript', 'typescript'} }

    -- Writing
    use { 'godlygeek/tabular', ft = 'markdown' }
    -- use 'plasticboy/vim-markdown', { 'for': 'markdown' }
    use 'lervag/vimtex'                    -- Better latex support
    use 'junegunn/goyo.vim'                -- Distraction free writing
    use 'junegunn/limelight.vim'           -- Even more distraction free writing
    use 'vimwiki/vimwiki'

    -- Snippets
    use 'SirVer/ultisnips'                 -- Snippets engine
    use 'honza/vim-snippets'               -- Some default snippets

end)
