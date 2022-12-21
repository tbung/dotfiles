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
    use("tpope/vim-fugitive")
    use("tpope/vim-repeat")
    use("tpope/vim-eunuch")
    use("wellle/targets.vim")
    use("mbbill/undotree")
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

    -- Colors
    use({
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
        require("catppuccin").setup({})
        vim.cmd("colorscheme catppuccin")
      end,
    })

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
      "williamboman/mason-lspconfig.nvim",
      requires = { "neovim/nvim-lspconfig", "williamboman/mason.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "sumneko_lua",
            "rust_analyzer",
            "pyright",
            "clangd",
            "arduino_language_server",
            "bashls",
            "marksman",
            "gopls",
            "texlab",
          },
        })

        require("mason-tool-installer").setup({
          ensure_installed = {
            "stylua",
            "prettier",
            "shellcheck",
            "shfmt",
            "delve",
          },
        })

        require("plugins.lsp")
      end,
    })
    use("jose-elias-alvarez/null-ls.nvim")

    use("onsails/lspkind-nvim")
    use({
      "smjonas/inc-rename.nvim",
      config = function()
        require("inc_rename").setup({ input_buffer_type = "dressing" })
      end,
    })
    use({
      "simrat39/rust-tools.nvim",
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
        "kdheepak/cmp-latex-symbols",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-omni",
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
      run = function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end,
      config = function()
        require("plugins.treesitter")
      end,
    })

    use({ "nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "RRethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "nvim-treesitter/playground", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "yioneko/nvim-yati", requires = "nvim-treesitter/nvim-treesitter" })

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
    use("jbyuki/one-small-step-for-vimkind")

    use({
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("plugins.todo-comments")
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

    use({
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
      config = function()
        require("nvim-navic").setup({
          separator = " ⟩ ",
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
    use({
      "lervag/vimtex",
      config = function()
        vim.g.vimtex_view_general_viewer = "zathura"
      end,
    })
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
      after = "catppuccin",
      config = function()
        local navic = require("nvim-navic")

        local components = require("feline.default_components").winbar.icons

        table.insert(components.active[1], {
          provider = function()
            local loc = navic.get_location()
            -- `[\\%]` in latex fucks this up
            loc = string.gsub(loc, "\\%%", "percent")
            return loc
          end,
          enabled = function()
            return navic.is_available()
          end,
          hl = {
            fg = "skyblue",
            bg = "NONE",
            style = "NONE",
          },
          left_sep = {
            str = " ⟩ ",
            hl = {
              fg = "skyblue",
              bg = "NONE",
            },
          },
        })

        local ctp_feline = require("catppuccin.groups.integrations.feline")
        ctp_feline.setup({})

        -- require("plugins.statusline")
        require("feline").setup({
          components = ctp_feline.get(),
        })
        -- require("feline").winbar.setup()
        require("feline").winbar.setup({ components = components })
      end,
      requires = "kyazdani42/nvim-web-devicons",
    })

    use({
      "petertriho/nvim-scrollbar",
      config = function()
        -- local colors = require("tokyonight.colors").setup({})
        local colors = require("catppuccin.palettes").get_palette()

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
          integrations = {
            diffview = true,
          },
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
      "mickael-menu/zk-nvim",
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
        require("neogen").setup({
          languages = {
            python = {
              template = {
                annotation_convention = "reST",
              },
            },
          },
        })
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
        require("mini.starter").setup({
          items = {
            require("mini.starter").sections.recent_files(5, true, false),
            require("mini.starter").sections.builtin_actions(),
          },
        })
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
          output = {
            enabled = true,
            open_on_run = "yes",
          },
          adapters = {
            require("neotest-python")({
              runner = "pytest",
              dap = { justMyCode = false, console = "integratedTerminal" },
            }),
          },
        })
      end,
    })

    use({
      "kevinhwang91/nvim-ufo",
      requires = "kevinhwang91/promise-async",
      config = function()
        vim.o.foldcolumn = "0"
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
        require("ufo").setup({
          provider_selector = function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
          end,
        })
      end,
    })

    use({
      "max397574/colortils.nvim",
      cmd = "Colortils",
      config = function()
        require("colortils").setup()
      end,
    })

    use({
      "levouh/tint.nvim",
      config = function()
        -- Default configuration
        require("tint").setup()
      end,
    })

    use({
      "stevearc/dressing.nvim",
      config = function()
        require("dressing").setup({
          input = {
            get_config = function(opts)
              if opts.dressing ~= nil then
                return {
                  relative = opts.relative,
                }
              end

              return nil
            end,
          },
        })
      end,
    })

    use({
      "vigoux/notifier.nvim",
      config = function()
        require("notifier").setup({
          -- You configuration here
        })
      end,
    })

    use({
      "hkupty/iron.nvim",
      config = function()
        local iron = require("iron.core")

        iron.setup({
          config = {
            -- Whether a repl should be discarded or not
            scratch_repl = true,
            -- Your repl definitions come here
            repl_definition = {
              sh = {
                command = { "zsh" },
              },
            },
            -- How the repl window will be displayed
            -- See below for more information
            repl_open_cmd = require("iron.view").split.vertical(),
          },
          -- Iron doesn't set keymaps by default anymore.
          -- You can set them here or manually add keymaps to the functions in iron.core
          keymaps = {
            send_motion = "<leader>sc",
            visual_send = "<leader>sc",
            send_file = "<leader>sf",
            send_line = "<leader>sl",
            -- send_mark = "<space>sm",
            -- mark_motion = "<space>mc",
            -- mark_visual = "<space>mc",
            -- remove_mark = "<space>md",
            -- cr = "<space>s<cr>",
            interrupt = "<leader>s<space>",
            exit = "<leader>sq",
            -- clear = "<space>cl",
          },
          -- If the highlight is on, you can change how it looks
          -- For the available options, check nvim_set_hl
          highlight = {
            -- italic = true,
            bg = require("catppuccin.palettes").get_palette().surface0,
          },
        })
      end,
    })

    use({
      "karb94/neoscroll.nvim",
      config = function()
        require("neoscroll").setup()

        local t = {}
        t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "80" } }
        t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "80" } }
        t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "100" } }
        t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "100" } }
        t["zt"] = { "zt", { "80" } }
        t["zz"] = { "zz", { "80" } }
        t["zb"] = { "zb", { "80" } }

        require("neoscroll.config").set_mappings(t)
      end,
    })

    use({
      "smjonas/live-command.nvim",
      config = function()
        require("live-command").setup({
          commands = {
            Norm = { cmd = "norm" },
            Gg = { cmd = "g" },
          },
          enable_highlighting = true,
        })
      end,
    })

    use({
      "toppair/peek.nvim",
      run = "deno task --quiet build:fast",
      config = function()
        -- default config:
        require("peek").setup({
          auto_load = true, -- whether to automatically load preview when
          -- entering another markdown buffer
          close_on_bdelete = true, -- close preview window on buffer delete

          syntax = true, -- enable syntax highlighting, affects performance

          theme = "dark", -- 'dark' or 'light'

          update_on_change = true,

          -- relevant if update_on_change is true
          throttle_at = 200000, -- start throttling when file exceeds this
          -- amount of bytes in size
          throttle_time = "auto", -- minimum amount of time in milliseconds
          -- that has to pass before starting new render
        })

        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      end,
    })
  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
    max_jobs = 8,
  },
})
