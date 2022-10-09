-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

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
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/tillb/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/tillb/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/tillb/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/tillb/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/tillb/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
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
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  catppuccin = {
    after = { "feline.nvim" },
    config = { "\27LJ\2\nµ\1\0\0\4\0\f\0\0176\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\4\0'\2\5\0B\0\2\0029\0\6\0005\2\b\0005\3\a\0=\3\t\2B\0\2\0016\0\0\0009\0\n\0'\2\v\0B\0\2\1K\0\1\0\27colorscheme catppuccin\bcmd\fcompile\1\0\0\1\0\1\fenabled\2\nsetup\15catppuccin\frequire\nmocha\23catppuccin_flavour\6g\bvim\0" },
    loaded = true,
    only_config = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-omni"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-omni",
    url = "https://github.com/hrsh7th/cmp-omni"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  ["cmp-under-comparator"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp-under-comparator",
    url = "https://github.com/lukas-reineke/cmp-under-comparator"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["colortils.nvim"] = {
    commands = { "Colortils" },
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colortils\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/opt/colortils.nvim",
    url = "https://github.com/max397574/colortils.nvim"
  },
  ["dial.nvim"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17plugins.dial\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dressing.nvim"] = {
    config = { "\27LJ\2\n@\0\1\3\0\3\0\t9\1\0\0\n\1\0\0X\1\4€5\1\2\0009\2\1\0=\2\1\1L\1\2\0+\1\0\0L\1\2\0\1\0\0\rrelative\rdressingb\1\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0003\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\ninput\1\0\0\15get_config\1\0\0\0\nsetup\rdressing\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["feline.nvim"] = {
    config = { "\27LJ\2\nZ\0\0\6\1\5\0\v-\0\0\0009\0\0\0B\0\1\0026\1\1\0009\1\2\1\18\3\0\0'\4\3\0'\5\4\0B\1\4\2\18\0\1\0L\0\2\0\0À\fpercent\b\\%%\tgsub\vstring\17get_location\"\0\0\2\1\1\0\3-\0\0\0009\0\0\0D\0\1\0\0À\17is_availableÇ\3\1\0\b\0\25\00016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\0019\1\4\0016\2\5\0009\2\6\0029\4\a\1:\4\1\0045\5\t\0003\6\b\0=\6\n\0053\6\v\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0005\a\16\0=\a\14\6=\6\17\5B\2\3\0016\2\0\0'\4\18\0B\2\2\0029\3\19\0024\5\0\0B\3\2\0016\3\0\0'\5\20\0B\3\2\0029\3\19\0035\5\22\0009\6\21\2B\6\1\2=\6\23\5B\3\2\0016\3\0\0'\5\20\0B\3\2\0029\3\3\0039\3\19\0035\5\24\0=\1\23\5B\3\2\0012\0\0€K\0\1\0\1\0\0\15components\1\0\0\bget\vfeline\nsetup*catppuccin.groups.integrations.feline\rleft_sep\1\0\2\afg\fskyblue\abg\tNONE\1\0\1\bstr\n âŸ© \ahl\1\0\3\afg\fskyblue\nstyle\tNONE\abg\tNONE\fenabled\0\rprovider\1\0\0\0\vactive\vinsert\ntable\nicons\vwinbar\30feline.default_components\15nvim-navic\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/opt/feline.nvim",
    url = "https://github.com/feline-nvim/feline.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["git-worktree.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-worktree\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/git-worktree.nvim",
    url = "https://github.com/ThePrimeagen/git-worktree.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21plugins.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim",
    wants = { "plenary.nvim" }
  },
  harpoon = {
    config = { "\27LJ\2\nÈ\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\20global_settings\1\0\0\23excluded_filetypes\1\2\0\0\fharpoon\1\0\4\27tmux_autoclose_windows\1\21enter_on_sendcmd\2\19save_on_change\2\19save_on_toggle\1\nsetup\fharpoon\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["inc-rename.nvim"] = {
    config = { "\27LJ\2\nZ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\22input_buffer_type\rdressing\nsetup\15inc_rename\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/inc-rename.nvim",
    url = "https://github.com/smjonas/inc-rename.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\nÁ\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\21filetype_exclude\1\5\0\0\14dashboard\nalpha\fstarter\rneo-tree\20buftype_exclude\1\2\0\0\rterminal\1\0\2\19use_treesitter\2\tchar\bâ”‚\nsetup\21indent_blankline\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["info.vim"] = {
    config = { "\27LJ\2\nL\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0'/opt/homebrew/opt/texinfo/bin/info\finfoprg\6g\bvim\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/info.vim",
    url = "https://github.com/HiPhish/info.vim"
  },
  ["iron.nvim"] = {
    config = { "\27LJ\2\n…\4\0\0\b\0\20\0\0266\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\14\0005\4\3\0005\5\a\0005\6\5\0005\a\4\0=\a\6\6=\6\b\5=\5\t\0046\5\0\0'\a\n\0B\5\2\0029\5\v\0059\5\f\5B\5\1\2=\5\r\4=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\3B\1\2\1K\0\1\0\14highlight\1\0\1\vitalic\2\fkeymaps\1\0\f\16send_motion\14<space>sc\16mark_visual\14<space>mc\texit\14<space>sq\16remove_mark\14<space>md\nclear\14<space>cl\14interrupt\20<space>s<space>\16mark_motion\14<space>mc\16visual_send\14<space>sc\14send_mark\14<space>sm\acr\17<space>s<cr>\14send_file\14<space>sf\14send_line\14<space>sl\vconfig\1\0\0\18repl_open_cmd\rvertical\nsplit\14iron.view\20repl_definition\ash\1\0\0\fcommand\1\0\0\1\2\0\0\bzsh\1\0\1\17scratch_repl\2\nsetup\14iron.core\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/iron.nvim",
    url = "https://github.com/hkupty/iron.nvim"
  },
  ["jupytext.vim"] = {
    config = { "\27LJ\2\n9\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\15py:percent\17jupytext_fmt\6g\bvim\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/jupytext.vim",
    url = "https://github.com/goerz/jupytext.vim"
  },
  ["leap.nvim"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\24set_default_keymaps\tleap\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/leap.nvim",
    url = "https://github.com/ggandor/leap.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["magma-nvim"] = {
    config = { "\27LJ\2\n…\1\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0f      let g:magma_automatically_open_output = 0\n      let g:magma_image_provider = \"kitty\"\n      \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/magma-nvim",
    url = "/Users/tillb/Projects/magma-nvim"
  },
  ["marks.nvim"] = {
    config = { "\27LJ\2\nj\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\18builtin_marks\1\0\2\vcyclic\2\21default_mappings\2\nsetup\nmarks\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/marks.nvim",
    url = "https://github.com/chentoast/marks.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    config = { "\27LJ\2\nÍ\2\0\0\4\0\v\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0005\2\5\0005\3\4\0=\3\6\2B\0\2\0016\0\0\0'\2\a\0B\0\2\0029\0\2\0005\2\t\0005\3\b\0=\3\6\2B\0\2\0016\0\0\0'\2\n\0B\0\2\1K\0\1\0\16plugins.lsp\1\0\0\1\6\0\0\vstylua\rprettier\15shellcheck\nshfmt\ndelve\25mason-tool-installer\21ensure_installed\1\0\0\1\t\0\0\16sumneko_lua\18rust_analyzer\fpyright\vclangd\28arduino_language_server\vbashls\rmarksman\ngopls\20mason-lspconfig\nsetup\nmason\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason-tool-installer.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/mason-tool-installer.nvim",
    url = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["mini.nvim"] = {
    config = { "\27LJ\2\n¿\1\0\0\t\0\b\1\0266\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0004\3\3\0006\4\0\0'\6\1\0B\4\2\0029\4\3\0049\4\4\4)\6\5\0+\a\2\0+\b\1\0B\4\4\2>\4\1\0036\4\0\0'\6\1\0B\4\2\0029\4\3\0049\4\5\4B\4\1\0?\4\0\0=\3\a\2B\0\2\1K\0\1\0\nitems\1\0\0\20builtin_actions\17recent_files\rsections\nsetup\17mini.starter\frequire\5€€À™\4\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/mini.nvim",
    url = "https://github.com/echasnovski/mini.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\nœ\2\0\0\4\0\r\0\0176\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0005\3\a\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\2B\0\2\1K\0\1\0\fbuffers\1\0\1\24follow_current_file\2\15filesystem\1\0\2\27use_libuv_file_watcher\2\24follow_current_file\2\vwindow\1\0\1\nwidth\3\30\1\0\1\25close_if_last_window\2\nsetup\rneo-tree\frequire0 let g:neo_tree_remove_legacy_commands = 1 \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  neogen = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogen\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/neogen",
    url = "https://github.com/danymat/neogen"
  },
  neogit = {
    config = { "\27LJ\2\ný\1\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\nsigns\thunk\1\3\0\0\5\5\titem\1\3\0\0\bï‘ \bï‘¼\fsection\1\0\0\1\3\0\0\bï‘ \bï‘¼\17integrations\1\0\1\rdiffview\2\1\0\3 disable_commit_confirmation\2\tkind\nsplit\"disable_builtin_notifications\2\nsetup\vneogit\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\næ\3\0\0\4\0\26\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0014\0\0\0005\1\4\0005\2\5\0>\2\2\1=\1\3\0005\1\a\0005\2\b\0>\2\2\1=\1\6\0005\1\n\0005\2\v\0>\2\2\1=\1\t\0005\1\r\0005\2\14\0>\2\2\1=\1\f\0005\1\16\0005\2\17\0>\2\2\1=\1\15\0005\1\19\0005\2\20\0>\2\2\1=\1\18\0005\1\22\0005\2\23\0>\2\2\1=\1\21\0006\1\0\0'\3\24\0B\1\2\0029\1\25\1\18\3\0\0B\1\2\1K\0\1\0\17set_mappings\21neoscroll.config\1\2\0\0\a80\1\2\0\0\azb\azb\1\2\0\0\a80\1\2\0\0\azz\azz\1\2\0\0\a80\1\2\0\0\azt\azt\1\4\0\0#vim.api.nvim_win_get_height(0)\ttrue\b100\1\2\0\0\vscroll\n<C-f>\1\4\0\0$-vim.api.nvim_win_get_height(0)\ttrue\b100\1\2\0\0\vscroll\n<C-b>\1\4\0\0\18vim.wo.scroll\ttrue\a80\1\2\0\0\vscroll\n<C-d>\1\4\0\0\19-vim.wo.scroll\ttrue\a80\1\2\0\0\vscroll\n<C-u>\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  neotest = {
    config = { "\27LJ\2\nì\1\0\0\b\0\v\1\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\3\0006\4\0\0'\6\6\0B\4\2\0025\6\a\0005\a\b\0=\a\t\6B\4\2\0?\4\0\0=\3\n\2B\0\2\1K\0\1\0\radapters\bdap\1\0\2\15justMyCode\1\fconsole\23integratedTerminal\1\0\1\vrunner\vpytest\19neotest-python\voutput\1\0\0\1\0\2\fenabled\2\16open_on_run\byes\nsetup\fneotest\frequire\3€€À™\4\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/neotest",
    url = "https://github.com/rcarriga/neotest"
  },
  ["neotest-python"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/neotest-python",
    url = "https://github.com/rcarriga/neotest-python"
  },
  ["notifier.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rnotifier\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/notifier.nvim",
    url = "https://github.com/vigoux/notifier.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.cmp\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.dap\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-navic"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\14separator\n âŸ© \nsetup\15nvim-navic\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-navic",
    url = "https://github.com/SmiteshP/nvim-navic"
  },
  ["nvim-scrollbar"] = {
    config = { "\27LJ\2\né\2\0\0\a\0\30\0*6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0026\1\0\0'\3\3\0B\1\2\0029\1\4\0015\3\b\0005\4\6\0009\5\5\0=\5\a\4=\4\t\0035\4\f\0005\5\v\0009\6\n\0=\6\a\5=\5\r\0045\5\15\0009\6\14\0=\6\a\5=\5\16\0045\5\18\0009\6\17\0=\6\a\5=\5\19\0045\5\21\0009\6\20\0=\6\a\5=\5\22\0045\5\24\0009\6\23\0=\6\a\5=\5\25\0045\5\27\0009\6\26\0=\6\a\5=\5\28\4=\4\29\3B\1\2\1K\0\1\0\nmarks\tMisc\1\0\0\vpurple\tHint\1\0\0\thint\tInfo\1\0\0\tinfo\tWarn\1\0\0\fwarning\nError\1\0\0\nerror\vSearch\1\0\0\1\0\0\vorange\vhandle\1\0\0\ncolor\1\0\0\17bg_highlight\nsetup\14scrollbar\16get_palette\24catppuccin.palettes\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-scrollbar",
    url = "https://github.com/petertriho/nvim-scrollbar"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-terminal.lua"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rterminal\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-terminal.lua",
    url = "https://github.com/norcalli/nvim-terminal.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23plugins.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-ufo"] = {
    config = { "\27LJ\2\n%\0\3\4\0\1\0\0025\3\0\0L\3\2\0\1\3\0\0\15treesitter\vindentÈ\2\1\0\a\0\20\0-6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1c\0=\1\4\0006\0\0\0009\0\1\0)\1c\0=\1\5\0006\0\0\0009\0\1\0+\1\2\0=\1\6\0006\0\0\0009\0\a\0009\0\b\0'\2\t\0'\3\n\0006\4\v\0'\6\f\0B\4\2\0029\4\r\4B\0\4\0016\0\0\0009\0\a\0009\0\b\0'\2\t\0'\3\14\0006\4\v\0'\6\f\0B\4\2\0029\4\15\4B\0\4\0016\0\v\0'\2\f\0B\0\2\0029\0\16\0005\2\18\0003\3\17\0=\3\19\2B\0\2\1K\0\1\0\22provider_selector\1\0\0\0\nsetup\18closeAllFolds\azM\17openAllFolds\bufo\frequire\azR\6n\bset\vkeymap\15foldenable\19foldlevelstart\14foldlevel\0060\15foldcolumn\6o\bvim\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-ufo",
    url = "https://github.com/kevinhwang91/nvim-ufo"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["nvim-yati"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/nvim-yati",
    url = "https://github.com/yioneko/nvim-yati"
  },
  ["one-small-step-for-vimkind"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/one-small-step-for-vimkind",
    url = "https://github.com/jbyuki/one-small-step-for-vimkind"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["possession.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15possession\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/possession.nvim",
    url = "https://github.com/jedrzejboczar/possession.nvim"
  },
  ["promise-async"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/promise-async",
    url = "https://github.com/kevinhwang91/promise-async"
  },
  ["refactoring.nvim"] = {
    config = { "\27LJ\2\nº\4\0\0\6\0\21\0'6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\4\0009\0\5\0009\0\6\0'\2\a\0'\3\b\0'\4\t\0005\5\n\0B\0\5\0016\0\4\0009\0\5\0009\0\6\0'\2\v\0'\3\f\0'\4\r\0005\5\14\0B\0\5\0016\0\4\0009\0\5\0009\0\6\0'\2\a\0'\3\15\0'\4\16\0005\5\17\0B\0\5\0016\0\4\0009\0\5\0009\0\6\0'\2\v\0'\3\18\0'\4\19\0005\5\20\0B\0\5\1K\0\1\0\1\0\1\fnoremap\0026:lua require('refactoring').debug.cleanup({})<CR>\16<leader>vrc\1\0\1\fnoremap\0028:lua require('refactoring').debug.print_var({})<CR>\16<leader>vrv\1\0\1\fnoremap\2B:lua require('refactoring').debug.printf({below = false})<CR>\16<leader>vrp\6n\1\0\1\fnoremap\2N<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>\16<leader>vrr\6v\20nvim_set_keymap\bapi\bvim\16refactoring\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/refactoring.nvim",
    url = "https://github.com/ThePrimeagen/refactoring.nvim"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["symbols-outline.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-bibtex.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/telescope-bibtex.nvim",
    url = "https://github.com/nvim-telescope/telescope-bibtex.nvim"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tint.nvim"] = {
    config = { "\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ttint\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/tint.nvim",
    url = "https://github.com/levouh/tint.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26plugins.todo-comments\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["twilight.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rtwilight\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  undotree = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-kitty"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/vim-kitty",
    url = "https://github.com/fladson/vim-kitty"
  },
  ["vim-maximizer"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/vim-maximizer",
    url = "https://github.com/szw/vim-maximizer"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  vimtex = {
    config = { "\27LJ\2\nD\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\fzathura\31vimtex_view_general_viewer\6g\bvim\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/vimtex",
    url = "https://github.com/lervag/vimtex"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nn\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\fplugins\1\0\0\rspelling\1\0\0\1\0\1\fenabled\2\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["zen-mode.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rzen-mode\frequire\0" },
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  },
  ["zk-nvim"] = {
    loaded = true,
    path = "/Users/tillb/.local/share/nvim/site/pack/packer/start/zk-nvim",
    url = "https://github.com/mickael-menu/zk-nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: dressing.nvim
time([[Config for dressing.nvim]], true)
try_loadstring("\27LJ\2\n@\0\1\3\0\3\0\t9\1\0\0\n\1\0\0X\1\4€5\1\2\0009\2\1\0=\2\1\1L\1\2\0+\1\0\0L\1\2\0\1\0\0\rrelative\rdressingb\1\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0003\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\ninput\1\0\0\15get_config\1\0\0\0\nsetup\rdressing\frequire\0", "config", "dressing.nvim")
time([[Config for dressing.nvim]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\nœ\2\0\0\4\0\r\0\0176\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\6\0005\3\a\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\2B\0\2\1K\0\1\0\fbuffers\1\0\1\24follow_current_file\2\15filesystem\1\0\2\27use_libuv_file_watcher\2\24follow_current_file\2\vwindow\1\0\1\nwidth\3\30\1\0\1\25close_if_last_window\2\nsetup\rneo-tree\frequire0 let g:neo_tree_remove_legacy_commands = 1 \bcmd\bvim\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: nvim-terminal.lua
time([[Config for nvim-terminal.lua]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rterminal\frequire\0", "config", "nvim-terminal.lua")
time([[Config for nvim-terminal.lua]], false)
-- Config for: mini.nvim
time([[Config for mini.nvim]], true)
try_loadstring("\27LJ\2\n¿\1\0\0\t\0\b\1\0266\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0004\3\3\0006\4\0\0'\6\1\0B\4\2\0029\4\3\0049\4\4\4)\6\5\0+\a\2\0+\b\1\0B\4\4\2>\4\1\0036\4\0\0'\6\1\0B\4\2\0029\4\3\0049\4\5\4B\4\1\0?\4\0\0=\3\a\2B\0\2\1K\0\1\0\nitems\1\0\0\20builtin_actions\17recent_files\rsections\nsetup\17mini.starter\frequire\5€€À™\4\0", "config", "mini.nvim")
time([[Config for mini.nvim]], false)
-- Config for: nvim-navic
time([[Config for nvim-navic]], true)
try_loadstring("\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\14separator\n âŸ© \nsetup\15nvim-navic\frequire\0", "config", "nvim-navic")
time([[Config for nvim-navic]], false)
-- Config for: dial.nvim
time([[Config for dial.nvim]], true)
try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17plugins.dial\frequire\0", "config", "dial.nvim")
time([[Config for dial.nvim]], false)
-- Config for: nvim-scrollbar
time([[Config for nvim-scrollbar]], true)
try_loadstring("\27LJ\2\né\2\0\0\a\0\30\0*6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0026\1\0\0'\3\3\0B\1\2\0029\1\4\0015\3\b\0005\4\6\0009\5\5\0=\5\a\4=\4\t\0035\4\f\0005\5\v\0009\6\n\0=\6\a\5=\5\r\0045\5\15\0009\6\14\0=\6\a\5=\5\16\0045\5\18\0009\6\17\0=\6\a\5=\5\19\0045\5\21\0009\6\20\0=\6\a\5=\5\22\0045\5\24\0009\6\23\0=\6\a\5=\5\25\0045\5\27\0009\6\26\0=\6\a\5=\5\28\4=\4\29\3B\1\2\1K\0\1\0\nmarks\tMisc\1\0\0\vpurple\tHint\1\0\0\thint\tInfo\1\0\0\tinfo\tWarn\1\0\0\fwarning\nError\1\0\0\nerror\vSearch\1\0\0\1\0\0\vorange\vhandle\1\0\0\ncolor\1\0\0\17bg_highlight\nsetup\14scrollbar\16get_palette\24catppuccin.palettes\frequire\0", "config", "nvim-scrollbar")
time([[Config for nvim-scrollbar]], false)
-- Config for: mason-lspconfig.nvim
time([[Config for mason-lspconfig.nvim]], true)
try_loadstring("\27LJ\2\nÍ\2\0\0\4\0\v\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0005\2\5\0005\3\4\0=\3\6\2B\0\2\0016\0\0\0'\2\a\0B\0\2\0029\0\2\0005\2\t\0005\3\b\0=\3\6\2B\0\2\0016\0\0\0'\2\n\0B\0\2\1K\0\1\0\16plugins.lsp\1\0\0\1\6\0\0\vstylua\rprettier\15shellcheck\nshfmt\ndelve\25mason-tool-installer\21ensure_installed\1\0\0\1\t\0\0\16sumneko_lua\18rust_analyzer\fpyright\vclangd\28arduino_language_server\vbashls\rmarksman\ngopls\20mason-lspconfig\nsetup\nmason\frequire\0", "config", "mason-lspconfig.nvim")
time([[Config for mason-lspconfig.nvim]], false)
-- Config for: marks.nvim
time([[Config for marks.nvim]], true)
try_loadstring("\27LJ\2\nj\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\18builtin_marks\1\0\2\vcyclic\2\21default_mappings\2\nsetup\nmarks\frequire\0", "config", "marks.nvim")
time([[Config for marks.nvim]], false)
-- Config for: nvim-surround
time([[Config for nvim-surround]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0", "config", "nvim-surround")
time([[Config for nvim-surround]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rzen-mode\frequire\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
-- Config for: magma-nvim
time([[Config for magma-nvim]], true)
try_loadstring("\27LJ\2\n…\1\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0f      let g:magma_automatically_open_output = 0\n      let g:magma_image_provider = \"kitty\"\n      \bcmd\bvim\0", "config", "magma-nvim")
time([[Config for magma-nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\nn\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\fplugins\1\0\0\rspelling\1\0\0\1\0\1\fenabled\2\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: vimtex
time([[Config for vimtex]], true)
try_loadstring("\27LJ\2\nD\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\fzathura\31vimtex_view_general_viewer\6g\bvim\0", "config", "vimtex")
time([[Config for vimtex]], false)
-- Config for: leap.nvim
time([[Config for leap.nvim]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\24set_default_keymaps\tleap\frequire\0", "config", "leap.nvim")
time([[Config for leap.nvim]], false)
-- Config for: refactoring.nvim
time([[Config for refactoring.nvim]], true)
try_loadstring("\27LJ\2\nº\4\0\0\6\0\21\0'6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\4\0009\0\5\0009\0\6\0'\2\a\0'\3\b\0'\4\t\0005\5\n\0B\0\5\0016\0\4\0009\0\5\0009\0\6\0'\2\v\0'\3\f\0'\4\r\0005\5\14\0B\0\5\0016\0\4\0009\0\5\0009\0\6\0'\2\a\0'\3\15\0'\4\16\0005\5\17\0B\0\5\0016\0\4\0009\0\5\0009\0\6\0'\2\v\0'\3\18\0'\4\19\0005\5\20\0B\0\5\1K\0\1\0\1\0\1\fnoremap\0026:lua require('refactoring').debug.cleanup({})<CR>\16<leader>vrc\1\0\1\fnoremap\0028:lua require('refactoring').debug.print_var({})<CR>\16<leader>vrv\1\0\1\fnoremap\2B:lua require('refactoring').debug.printf({below = false})<CR>\16<leader>vrp\6n\1\0\1\fnoremap\2N<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>\16<leader>vrr\6v\20nvim_set_keymap\bapi\bvim\16refactoring\19load_extension\14telescope\frequire\0", "config", "refactoring.nvim")
time([[Config for refactoring.nvim]], false)
-- Config for: jupytext.vim
time([[Config for jupytext.vim]], true)
try_loadstring("\27LJ\2\n9\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0\15py:percent\17jupytext_fmt\6g\bvim\0", "config", "jupytext.vim")
time([[Config for jupytext.vim]], false)
-- Config for: iron.nvim
time([[Config for iron.nvim]], true)
try_loadstring("\27LJ\2\n…\4\0\0\b\0\20\0\0266\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\14\0005\4\3\0005\5\a\0005\6\5\0005\a\4\0=\a\6\6=\6\b\5=\5\t\0046\5\0\0'\a\n\0B\5\2\0029\5\v\0059\5\f\5B\5\1\2=\5\r\4=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\3B\1\2\1K\0\1\0\14highlight\1\0\1\vitalic\2\fkeymaps\1\0\f\16send_motion\14<space>sc\16mark_visual\14<space>mc\texit\14<space>sq\16remove_mark\14<space>md\nclear\14<space>cl\14interrupt\20<space>s<space>\16mark_motion\14<space>mc\16visual_send\14<space>sc\14send_mark\14<space>sm\acr\17<space>s<cr>\14send_file\14<space>sf\14send_line\14<space>sl\vconfig\1\0\0\18repl_open_cmd\rvertical\nsplit\14iron.view\20repl_definition\ash\1\0\0\fcommand\1\0\0\1\2\0\0\bzsh\1\0\1\17scratch_repl\2\nsetup\14iron.core\frequire\0", "config", "iron.nvim")
time([[Config for iron.nvim]], false)
-- Config for: possession.nvim
time([[Config for possession.nvim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15possession\frequire\0", "config", "possession.nvim")
time([[Config for possession.nvim]], false)
-- Config for: info.vim
time([[Config for info.vim]], true)
try_loadstring("\27LJ\2\nL\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0'/opt/homebrew/opt/texinfo/bin/info\finfoprg\6g\bvim\0", "config", "info.vim")
time([[Config for info.vim]], false)
-- Config for: neogit
time([[Config for neogit]], true)
try_loadstring("\27LJ\2\ný\1\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\nsigns\thunk\1\3\0\0\5\5\titem\1\3\0\0\bï‘ \bï‘¼\fsection\1\0\0\1\3\0\0\bï‘ \bï‘¼\17integrations\1\0\1\rdiffview\2\1\0\3 disable_commit_confirmation\2\tkind\nsplit\"disable_builtin_notifications\2\nsetup\vneogit\frequire\0", "config", "neogit")
time([[Config for neogit]], false)
-- Config for: inc-rename.nvim
time([[Config for inc-rename.nvim]], true)
try_loadstring("\27LJ\2\nZ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\22input_buffer_type\rdressing\nsetup\15inc_rename\frequire\0", "config", "inc-rename.nvim")
time([[Config for inc-rename.nvim]], false)
-- Config for: neogen
time([[Config for neogen]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogen\frequire\0", "config", "neogen")
time([[Config for neogen]], false)
-- Config for: neotest
time([[Config for neotest]], true)
try_loadstring("\27LJ\2\nì\1\0\0\b\0\v\1\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\3\0006\4\0\0'\6\6\0B\4\2\0025\6\a\0005\a\b\0=\a\t\6B\4\2\0?\4\0\0=\3\n\2B\0\2\1K\0\1\0\radapters\bdap\1\0\2\15justMyCode\1\fconsole\23integratedTerminal\1\0\1\vrunner\vpytest\19neotest-python\voutput\1\0\0\1\0\2\fenabled\2\16open_on_run\byes\nsetup\fneotest\frequire\3€€À™\4\0", "config", "neotest")
time([[Config for neotest]], false)
-- Config for: nvim-ufo
time([[Config for nvim-ufo]], true)
try_loadstring("\27LJ\2\n%\0\3\4\0\1\0\0025\3\0\0L\3\2\0\1\3\0\0\15treesitter\vindentÈ\2\1\0\a\0\20\0-6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1c\0=\1\4\0006\0\0\0009\0\1\0)\1c\0=\1\5\0006\0\0\0009\0\1\0+\1\2\0=\1\6\0006\0\0\0009\0\a\0009\0\b\0'\2\t\0'\3\n\0006\4\v\0'\6\f\0B\4\2\0029\4\r\4B\0\4\0016\0\0\0009\0\a\0009\0\b\0'\2\t\0'\3\14\0006\4\v\0'\6\f\0B\4\2\0029\4\15\4B\0\4\0016\0\v\0'\2\f\0B\0\2\0029\0\16\0005\2\18\0003\3\17\0=\3\19\2B\0\2\1K\0\1\0\22provider_selector\1\0\0\0\nsetup\18closeAllFolds\azM\17openAllFolds\bufo\frequire\azR\6n\bset\vkeymap\15foldenable\19foldlevelstart\14foldlevel\0060\15foldcolumn\6o\bvim\0", "config", "nvim-ufo")
time([[Config for nvim-ufo]], false)
-- Config for: harpoon
time([[Config for harpoon]], true)
try_loadstring("\27LJ\2\nÈ\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\20global_settings\1\0\0\23excluded_filetypes\1\2\0\0\fharpoon\1\0\4\27tmux_autoclose_windows\1\21enter_on_sendcmd\2\19save_on_change\2\19save_on_toggle\1\nsetup\fharpoon\frequire\0", "config", "harpoon")
time([[Config for harpoon]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\næ\3\0\0\4\0\26\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0014\0\0\0005\1\4\0005\2\5\0>\2\2\1=\1\3\0005\1\a\0005\2\b\0>\2\2\1=\1\6\0005\1\n\0005\2\v\0>\2\2\1=\1\t\0005\1\r\0005\2\14\0>\2\2\1=\1\f\0005\1\16\0005\2\17\0>\2\2\1=\1\15\0005\1\19\0005\2\20\0>\2\2\1=\1\18\0005\1\22\0005\2\23\0>\2\2\1=\1\21\0006\1\0\0'\3\24\0B\1\2\0029\1\25\1\18\3\0\0B\1\2\1K\0\1\0\17set_mappings\21neoscroll.config\1\2\0\0\a80\1\2\0\0\azb\azb\1\2\0\0\a80\1\2\0\0\azz\azz\1\2\0\0\a80\1\2\0\0\azt\azt\1\4\0\0#vim.api.nvim_win_get_height(0)\ttrue\b100\1\2\0\0\vscroll\n<C-f>\1\4\0\0$-vim.api.nvim_win_get_height(0)\ttrue\b100\1\2\0\0\vscroll\n<C-b>\1\4\0\0\18vim.wo.scroll\ttrue\a80\1\2\0\0\vscroll\n<C-d>\1\4\0\0\19-vim.wo.scroll\ttrue\a80\1\2\0\0\vscroll\n<C-u>\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: twilight.nvim
time([[Config for twilight.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rtwilight\frequire\0", "config", "twilight.nvim")
time([[Config for twilight.nvim]], false)
-- Config for: catppuccin
time([[Config for catppuccin]], true)
try_loadstring("\27LJ\2\nµ\1\0\0\4\0\f\0\0176\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\4\0'\2\5\0B\0\2\0029\0\6\0005\2\b\0005\3\a\0=\3\t\2B\0\2\0016\0\0\0009\0\n\0'\2\v\0B\0\2\1K\0\1\0\27colorscheme catppuccin\bcmd\fcompile\1\0\0\1\0\1\fenabled\2\nsetup\15catppuccin\frequire\nmocha\23catppuccin_flavour\6g\bvim\0", "config", "catppuccin")
time([[Config for catppuccin]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.dap\frequire\0", "config", "nvim-dap")
time([[Config for nvim-dap]], false)
-- Config for: notifier.nvim
time([[Config for notifier.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\rnotifier\frequire\0", "config", "notifier.nvim")
time([[Config for notifier.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\nÁ\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\21filetype_exclude\1\5\0\0\14dashboard\nalpha\fstarter\rneo-tree\20buftype_exclude\1\2\0\0\rterminal\1\0\2\19use_treesitter\2\tchar\bâ”‚\nsetup\21indent_blankline\frequire\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: git-worktree.nvim
time([[Config for git-worktree.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-worktree\frequire\0", "config", "git-worktree.nvim")
time([[Config for git-worktree.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26plugins.todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: tint.nvim
time([[Config for tint.nvim]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ttint\frequire\0", "config", "tint.nvim")
time([[Config for tint.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd feline.nvim ]]

-- Config for: feline.nvim
try_loadstring("\27LJ\2\nZ\0\0\6\1\5\0\v-\0\0\0009\0\0\0B\0\1\0026\1\1\0009\1\2\1\18\3\0\0'\4\3\0'\5\4\0B\1\4\2\18\0\1\0L\0\2\0\0À\fpercent\b\\%%\tgsub\vstring\17get_location\"\0\0\2\1\1\0\3-\0\0\0009\0\0\0D\0\1\0\0À\17is_availableÇ\3\1\0\b\0\25\00016\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\0019\1\4\0016\2\5\0009\2\6\0029\4\a\1:\4\1\0045\5\t\0003\6\b\0=\6\n\0053\6\v\0=\6\f\0055\6\r\0=\6\14\0055\6\15\0005\a\16\0=\a\14\6=\6\17\5B\2\3\0016\2\0\0'\4\18\0B\2\2\0029\3\19\0024\5\0\0B\3\2\0016\3\0\0'\5\20\0B\3\2\0029\3\19\0035\5\22\0009\6\21\2B\6\1\2=\6\23\5B\3\2\0016\3\0\0'\5\20\0B\3\2\0029\3\3\0039\3\19\0035\5\24\0=\1\23\5B\3\2\0012\0\0€K\0\1\0\1\0\0\15components\1\0\0\bget\vfeline\nsetup*catppuccin.groups.integrations.feline\rleft_sep\1\0\2\afg\fskyblue\abg\tNONE\1\0\1\bstr\n âŸ© \ahl\1\0\3\afg\fskyblue\nstyle\tNONE\abg\tNONE\fenabled\0\rprovider\1\0\0\0\vactive\vinsert\ntable\nicons\vwinbar\30feline.default_components\15nvim-navic\frequire\0", "config", "feline.nvim")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Colortils lua require("packer.load")({'colortils.nvim'}, { cmd = "Colortils", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'gitsigns.nvim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
