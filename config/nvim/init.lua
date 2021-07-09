require('tb.plugins')
require('tb.mappings')
require('tb.options')
require('tb.lsp')
require('tb.treesitter')
-- require('tb.floatterm')

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

require('telescope').setup{
    -- defaults = {
    --     layout_strategy = "horizontal",
    --     layout_config = {
    --         horizontal = {
    --             mirror = false,
    --         },
    --         vertical = {
    --             mirror = false,
    --         },
    --     },
    -- },
    -- extensions = {
    -- project = {
    --   base_dir = '~/Projects',
    --   max_depth = 3
    -- }
  -- }
}
require('telescope').load_extension('project')
require('telescope').load_extension('media_files')


require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  }
}

require 'colorizer'.setup()

require'lsp_signature'.on_attach()
-- require("luasnip/loaders/from_vscode").load({ path = '.local/share/nvim/site/pack/packer/start/friendly-snippets/snippets' })
require("trouble").setup({})
require('nvim-autopairs').setup({
    disable_filetype = { "TelescopePrompt" },
    check_ts = true,
})
require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true -- it will auto insert `(` after select function or method item
})
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

npairs.add_rules({
    Rule("$", "$", {"tex", "latex"})
})
