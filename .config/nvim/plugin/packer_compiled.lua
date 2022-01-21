-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/tillb/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/tillb/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/tillb/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/tillb/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/tillb/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\1\0025\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\1\2Z\0\0\3\0\5\0\n4\0\0\0%\1\1\0>\0\2\0027\0\2\0004\1\0\0%\2\3\0>\1\2\0027\1\4\1>\0\2\1G\0\1\0\topts\22plugins.dashboard\nsetup\nalpha\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-dictionary"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-dictionary",
    url = "https://github.com/uga-rosa/cmp-dictionary"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  ["cmp-under-comparator"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp-under-comparator",
    url = "https://github.com/lukas-reineke/cmp-under-comparator"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["dial.nvim"] = {
    config = { "\27LJ\1\2,\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\17plugins.dial\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.statusline\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/galaxyline.nvim",
    url = "https://github.com/glepnir/galaxyline.nvim"
  },
  ["git-worktree.nvim"] = {
    config = { "\27LJ\1\2:\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\17git-worktree\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/git-worktree.nvim",
    url = "https://github.com/ThePrimeagen/git-worktree.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\1\0020\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\21plugins.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim",
    wants = { "plenary.nvim" }
  },
  ["grammar-guard.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/grammar-guard.nvim",
    url = "https://github.com/brymer-meneses/grammar-guard.nvim"
  },
  harpoon = {
    config = { "\27LJ\1\2È\1\0\0\4\0\b\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\6\0003\2\3\0003\3\4\0:\3\5\2:\2\a\1>\0\2\1G\0\1\0\20global_settings\1\0\0\23excluded_filetypes\1\2\0\0\fharpoon\1\0\4\27tmux_autoclose_windows\1\19save_on_toggle\1\21enter_on_sendcmd\2\19save_on_change\2\nsetup\fharpoon\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\1\2°\1\0\0\3\0\b\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\4\0:\2\5\0013\2\6\0:\2\a\1>\0\2\1G\0\1\0\21filetype_exclude\1\3\0\0\14dashboard\nalpha\20buftype_exclude\1\2\0\0\rterminal\1\0\2\19use_treesitter\2\tchar\bâ”‚\nsetup\21indent_blankline\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["info.vim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/info.vim",
    url = "https://github.com/HiPhish/info.vim"
  },
  ["jupytext.vim"] = {
    config = { "\27LJ\1\0029\0\0\2\0\4\0\0054\0\0\0007\0\1\0%\1\3\0:\1\2\0G\0\1\0\15py:percent\17jupytext_fmt\6g\bvim\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/jupytext.vim",
    url = "https://github.com/goerz/jupytext.vim"
  },
  ["lightspeed.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["magma-nvim"] = {
    config = { "\27LJ\1\2T\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0005let g:magma_automatically_open_output = 0\n      \bcmd\bvim\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/magma-nvim",
    url = "/home/tillb/Projects/magma-nvim"
  },
  neorg = {
    config = { "\27LJ\1\2¥\4\0\0\6\0\30\0+4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\28\0003\2\3\0002\3\0\0:\3\4\0023\3\6\0003\4\5\0:\4\a\3:\3\b\0023\3\n\0003\4\t\0:\4\a\3:\3\v\0023\3\r\0003\4\f\0:\4\a\3:\3\14\0023\3\18\0003\4\16\0003\5\15\0:\5\17\4:\4\a\3:\3\19\0023\3\21\0003\4\20\0:\4\a\3:\3\22\0023\3\23\0002\4\0\0:\4\a\3:\3\24\0023\3\25\0002\4\0\0:\4\a\3:\3\26\0022\3\0\0:\3\27\2:\2\29\1>\0\2\1G\0\1\0\tload\1\0\0 core.integrations.telescope\22core.norg.journal\1\0\0\22core.norg.qol.toc\1\0\0\19core.presenter\1\0\0\1\0\1\rzen_mode\rzen-mode\21core.norg.dirman\1\0\0\15workspaces\1\0\0\1\0\1\17my_workspace\f~/neorg\25core.norg.completion\1\0\0\1\0\1\vengine\rnvim-cmp\24core.norg.concealer\1\0\0\1\0\1\18markup_preset\vdimmed\18core.keybinds\vconfig\1\0\0\1\0\2\17neorg_leader\14<Leader>o\21default_keybinds\2\18core.defaults\1\0\0\nsetup\nneorg\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/neorg",
    url = "https://github.com/nvim-neorg/neorg"
  },
  ["neorg-telescope"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/neorg-telescope",
    url = "https://github.com/nvim-neorg/neorg-telescope"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins.autopairs\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16plugins.cmp\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16plugins.lsp\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\1\2L\0\0\3\0\4\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\0014\0\3\0004\1\0\0%\2\1\0>\1\2\2:\1\1\0G\0\1\0\bvim\nsetup\vnotify\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-scrollbar"] = {
    config = { "\27LJ\1\2Û\2\0\0\6\0\29\0*4\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\0024\1\0\0%\2\3\0>\1\2\0027\1\2\0013\2\a\0003\3\5\0007\4\4\0:\4\6\3:\3\b\0023\3\v\0003\4\n\0007\5\t\0:\5\6\4:\4\f\0033\4\14\0007\5\r\0:\5\6\4:\4\15\0033\4\17\0007\5\16\0:\5\6\4:\4\18\0033\4\20\0007\5\19\0:\5\6\4:\4\21\0033\4\23\0007\5\22\0:\5\6\4:\4\24\0033\4\26\0007\5\25\0:\5\6\4:\4\27\3:\3\28\2>\1\2\1G\0\1\0\nmarks\tMisc\1\0\0\vpurple\tHint\1\0\0\thint\tInfo\1\0\0\tinfo\tWarn\1\0\0\fwarning\nError\1\0\0\nerror\vSearch\1\0\0\1\0\0\vorange\vhandle\1\0\0\ncolor\1\0\0\17bg_highlight\14scrollbar\nsetup\22tokyonight.colors\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-scrollbar",
    url = "https://github.com/petertriho/nvim-scrollbar"
  },
  ["nvim-terminal.lua"] = {
    config = { "\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rterminal\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-terminal.lua",
    url = "https://github.com/norcalli/nvim-terminal.lua"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\1\2³\1\0\0\3\0\v\0\0154\0\0\0007\0\1\0'\1\1\0:\1\2\0004\0\3\0%\1\4\0>\0\2\0027\0\5\0003\1\6\0003\2\a\0:\2\b\0013\2\t\0:\2\n\1>\0\2\1G\0\1\0\tview\1\0\1\16auto_resize\2\16diagnostics\1\0\1\venable\2\1\0\1\15auto_close\2\nsetup\14nvim-tree\frequire\27nvim_tree_quit_on_open\6g\bvim\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.treesitter\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["persistence.nvim"] = {
    config = { "\27LJ\1\0029\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\16persistence\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/opt/persistence.nvim",
    url = "https://github.com/folke/persistence.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["spellsitter.nvim"] = {
    config = { "\27LJ\1\0029\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\16spellsitter\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/spellsitter.nvim",
    url = "https://github.com/lewis6991/spellsitter.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins.telescope\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\1\2;\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\1\0025\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["twilight.nvim"] = {
    config = { "\27LJ\1\2:\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\rtwilight\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  undotree = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-doge"] = {
    config = { "\27LJ\1\2@\0\0\2\0\4\0\0054\0\0\0007\0\1\0%\1\3\0:\1\2\0G\0\1\0\nnumpy\29doge_doc_standard_python\6g\bvim\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-doge",
    url = "https://github.com/kkoomen/vim-doge"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-glsl"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/opt/vim-glsl",
    url = "https://github.com/tikhomirov/vim-glsl"
  },
  ["vim-kitty"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-kitty",
    url = "https://github.com/fladson/vim-kitty"
  },
  ["vim-maximizer"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-maximizer",
    url = "https://github.com/szw/vim-maximizer"
  },
  ["vim-pandoc-syntax"] = {
    config = { "\27LJ\1\2’\1\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0s  augroup pandoc_syntax\n  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc\n  augroup END\n  \bcmd\bvim\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-pandoc-syntax",
    url = "https://github.com/vim-pandoc/vim-pandoc-syntax"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  vimtex = {
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/vimtex",
    url = "https://github.com/lervag/vimtex"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\1\2;\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "/home/tillb/Projects/which-key.nvim"
  },
  ["wiki.vim"] = {
    config = { "\27LJ\1\2Ô\1\0\0\2\0\v\0\0214\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0003\1\5\0:\1\4\0004\0\0\0007\0\1\0%\1\a\0:\1\6\0004\0\0\0007\0\1\0%\1\t\0:\1\b\0004\0\0\0007\0\1\0)\1\2\0:\1\n\0G\0\1\0\31pandoc#syntax#conceal#urls\amd\26wiki_link_target_type\b.md\24wiki_link_extension\1\2\0\0\amd\19wiki_filetypes\v~/wiki\14wiki_root\6g\bvim\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/wiki.vim",
    url = "https://github.com/lervag/wiki.vim"
  },
  ["wilder.nvim"] = {
    config = { "\27LJ\1\2.\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\19plugins.wilder\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/wilder.nvim",
    url = "https://github.com/gelguy/wilder.nvim"
  },
  ["zen-mode.nvim"] = {
    config = { "\27LJ\1\2:\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\rzen-mode\frequire\0" },
    loaded = true,
    path = "/home/tillb/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^persistence"] = "persistence.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: dial.nvim
time([[Config for dial.nvim]], true)
try_loadstring("\27LJ\1\2,\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\17plugins.dial\frequire\0", "config", "dial.nvim")
time([[Config for dial.nvim]], false)
-- Config for: wilder.nvim
time([[Config for wilder.nvim]], true)
try_loadstring("\27LJ\1\2.\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\19plugins.wilder\frequire\0", "config", "wilder.nvim")
time([[Config for wilder.nvim]], false)
-- Config for: harpoon
time([[Config for harpoon]], true)
try_loadstring("\27LJ\1\2È\1\0\0\4\0\b\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\6\0003\2\3\0003\3\4\0:\3\5\2:\2\a\1>\0\2\1G\0\1\0\20global_settings\1\0\0\23excluded_filetypes\1\2\0\0\fharpoon\1\0\4\27tmux_autoclose_windows\1\19save_on_toggle\1\21enter_on_sendcmd\2\19save_on_change\2\nsetup\fharpoon\frequire\0", "config", "harpoon")
time([[Config for harpoon]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\1\2Z\0\0\3\0\5\0\n4\0\0\0%\1\1\0>\0\2\0027\0\2\0004\1\0\0%\2\3\0>\1\2\0027\1\4\1>\0\2\1G\0\1\0\topts\22plugins.dashboard\nsetup\nalpha\frequire\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\1\0025\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\1\0025\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: twilight.nvim
time([[Config for twilight.nvim]], true)
try_loadstring("\27LJ\1\2:\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\rtwilight\frequire\0", "config", "twilight.nvim")
time([[Config for twilight.nvim]], false)
-- Config for: jupytext.vim
time([[Config for jupytext.vim]], true)
try_loadstring("\27LJ\1\0029\0\0\2\0\4\0\0054\0\0\0007\0\1\0%\1\3\0:\1\2\0G\0\1\0\15py:percent\17jupytext_fmt\6g\bvim\0", "config", "jupytext.vim")
time([[Config for jupytext.vim]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.statusline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: neorg
time([[Config for neorg]], true)
try_loadstring("\27LJ\1\2¥\4\0\0\6\0\30\0+4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\28\0003\2\3\0002\3\0\0:\3\4\0023\3\6\0003\4\5\0:\4\a\3:\3\b\0023\3\n\0003\4\t\0:\4\a\3:\3\v\0023\3\r\0003\4\f\0:\4\a\3:\3\14\0023\3\18\0003\4\16\0003\5\15\0:\5\17\4:\4\a\3:\3\19\0023\3\21\0003\4\20\0:\4\a\3:\3\22\0023\3\23\0002\4\0\0:\4\a\3:\3\24\0023\3\25\0002\4\0\0:\4\a\3:\3\26\0022\3\0\0:\3\27\2:\2\29\1>\0\2\1G\0\1\0\tload\1\0\0 core.integrations.telescope\22core.norg.journal\1\0\0\22core.norg.qol.toc\1\0\0\19core.presenter\1\0\0\1\0\1\rzen_mode\rzen-mode\21core.norg.dirman\1\0\0\15workspaces\1\0\0\1\0\1\17my_workspace\f~/neorg\25core.norg.completion\1\0\0\1\0\1\vengine\rnvim-cmp\24core.norg.concealer\1\0\0\1\0\1\18markup_preset\vdimmed\18core.keybinds\vconfig\1\0\0\1\0\2\17neorg_leader\14<Leader>o\21default_keybinds\2\18core.defaults\1\0\0\nsetup\nneorg\frequire\0", "config", "neorg")
time([[Config for neorg]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins.autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: nvim-scrollbar
time([[Config for nvim-scrollbar]], true)
try_loadstring("\27LJ\1\2Û\2\0\0\6\0\29\0*4\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\0024\1\0\0%\2\3\0>\1\2\0027\1\2\0013\2\a\0003\3\5\0007\4\4\0:\4\6\3:\3\b\0023\3\v\0003\4\n\0007\5\t\0:\5\6\4:\4\f\0033\4\14\0007\5\r\0:\5\6\4:\4\15\0033\4\17\0007\5\16\0:\5\6\4:\4\18\0033\4\20\0007\5\19\0:\5\6\4:\4\21\0033\4\23\0007\5\22\0:\5\6\4:\4\24\0033\4\26\0007\5\25\0:\5\6\4:\4\27\3:\3\28\2>\1\2\1G\0\1\0\nmarks\tMisc\1\0\0\vpurple\tHint\1\0\0\thint\tInfo\1\0\0\tinfo\tWarn\1\0\0\fwarning\nError\1\0\0\nerror\vSearch\1\0\0\1\0\0\vorange\vhandle\1\0\0\ncolor\1\0\0\17bg_highlight\14scrollbar\nsetup\22tokyonight.colors\frequire\0", "config", "nvim-scrollbar")
time([[Config for nvim-scrollbar]], false)
-- Config for: git-worktree.nvim
time([[Config for git-worktree.nvim]], true)
try_loadstring("\27LJ\1\2:\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\17git-worktree\frequire\0", "config", "git-worktree.nvim")
time([[Config for git-worktree.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: magma-nvim
time([[Config for magma-nvim]], true)
try_loadstring("\27LJ\1\2T\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0005let g:magma_automatically_open_output = 0\n      \bcmd\bvim\0", "config", "magma-nvim")
time([[Config for magma-nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\1\2³\1\0\0\3\0\v\0\0154\0\0\0007\0\1\0'\1\1\0:\1\2\0004\0\3\0%\1\4\0>\0\2\0027\0\5\0003\1\6\0003\2\a\0:\2\b\0013\2\t\0:\2\n\1>\0\2\1G\0\1\0\tview\1\0\1\16auto_resize\2\16diagnostics\1\0\1\venable\2\1\0\1\15auto_close\2\nsetup\14nvim-tree\frequire\27nvim_tree_quit_on_open\6g\bvim\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: wiki.vim
time([[Config for wiki.vim]], true)
try_loadstring("\27LJ\1\2Ô\1\0\0\2\0\v\0\0214\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0003\1\5\0:\1\4\0004\0\0\0007\0\1\0%\1\a\0:\1\6\0004\0\0\0007\0\1\0%\1\t\0:\1\b\0004\0\0\0007\0\1\0)\1\2\0:\1\n\0G\0\1\0\31pandoc#syntax#conceal#urls\amd\26wiki_link_target_type\b.md\24wiki_link_extension\1\2\0\0\amd\19wiki_filetypes\v~/wiki\14wiki_root\6g\bvim\0", "config", "wiki.vim")
time([[Config for wiki.vim]], false)
-- Config for: nvim-terminal.lua
time([[Config for nvim-terminal.lua]], true)
try_loadstring("\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rterminal\frequire\0", "config", "nvim-terminal.lua")
time([[Config for nvim-terminal.lua]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\1\2;\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: spellsitter.nvim
time([[Config for spellsitter.nvim]], true)
try_loadstring("\27LJ\1\0029\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\16spellsitter\frequire\0", "config", "spellsitter.nvim")
time([[Config for spellsitter.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16plugins.cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: vim-pandoc-syntax
time([[Config for vim-pandoc-syntax]], true)
try_loadstring("\27LJ\1\2’\1\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0s  augroup pandoc_syntax\n  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc\n  augroup END\n  \bcmd\bvim\0", "config", "vim-pandoc-syntax")
time([[Config for vim-pandoc-syntax]], false)
-- Config for: vim-doge
time([[Config for vim-doge]], true)
try_loadstring("\27LJ\1\2@\0\0\2\0\4\0\0054\0\0\0007\0\1\0%\1\3\0:\1\2\0G\0\1\0\nnumpy\29doge_doc_standard_python\6g\bvim\0", "config", "vim-doge")
time([[Config for vim-doge]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\1\2;\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16plugins.lsp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\1\2L\0\0\3\0\4\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\0014\0\3\0004\1\0\0%\2\1\0>\1\2\2:\1\1\0G\0\1\0\bvim\nsetup\vnotify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\1\2:\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\1\2°\1\0\0\3\0\b\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0003\2\4\0:\2\5\0013\2\6\0:\2\a\1>\0\2\1G\0\1\0\21filetype_exclude\1\3\0\0\14dashboard\nalpha\20buftype_exclude\1\2\0\0\rterminal\1\0\2\19use_treesitter\2\tchar\bâ”‚\nsetup\21indent_blankline\frequire\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType glsl ++once lua require("packer.load")({'vim-glsl'}, { ft = "glsl" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'gitsigns.nvim', 'persistence.nvim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/tillb/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]], true)
vim.cmd [[source /home/tillb/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]]
time([[Sourcing ftdetect script at: /home/tillb/.local/share/nvim/site/pack/packer/opt/vim-glsl/ftdetect/glsl.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
