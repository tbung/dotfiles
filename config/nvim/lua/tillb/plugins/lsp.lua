return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "Mason" },
    dependencies = {
      { "folke/lazydev.nvim", config = true },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "microsoft/python-type-stubs",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local overrides = {
        ["arduino_language_server"] = {
          cmd = {
            "arduino-language-server",
            "-clangd",
            "/usr/bin/clangd",
            "-cli",
            "arduino-cli",
            "-cli-config",
            "/home/tillb/.arduino15/arduino-cli.yaml",
          },
        },

        texlab = {
          settings = {
            texlab = {
              auxDirectory = "./build",
              build = {
                args = { "-pdf", "-output-directory=./build", "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = true,
              },
              latexindent = {
                modifyLineBreaks = true,
              },
              forwardSearch = {
                -- TODO: this is currently macos specific, make it os agnostic
                executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                args = { "-b", "%l", "%p", "%f" },
              },
            },
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "--clang-tidy",
            "--background-index",
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        -- TODO: ruff_lsp and black currently don't like jupytext, need to find fix for that
        ruff_lsp = {
          -- ruff only provides hover for noqa comments, I don't need that
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
          end,
        },
        basedpyright = {
          settings = {
            python = {
              analysis = {
                stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      }

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )

      local function setup(server_name)
        local server_opts = vim.tbl_deep_extend("error", {
          capabilities = vim.deepcopy(capabilities),
        }, overrides[server_name] or {})

        require("lspconfig")[server_name].setup(server_opts)
      end

      require("mason-lspconfig").setup_handlers({ setup })

      -- Not installed via mason so need to setup manually
      setup("clangd")

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = true,
      })

      -- TODO: Do we need this with the respective catppuccin settings? Do we use lsp ever without catppuccin?
      local function underline_to_undercurl(hlname)
        local hl = vim.api.nvim_get_hl(0, { name = hlname })
        hl.undercurl = true
        hl.underline = nil
        vim.api.nvim_set_hl(0, hlname, hl)
      end

      underline_to_undercurl("DiagnosticUnderlineError")
      underline_to_undercurl("DiagnosticUnderlineWarn")
      underline_to_undercurl("DiagnosticUnderlineInfo")
      underline_to_undercurl("DiagnosticUnderlineHint")

      vim.diagnostic.config({
        virtual_text = {
          severity = { min = vim.diagnostic.severity.INFO },
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          },
        },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        cmdline = {
          preset = "default",
          ["<Up>"] = { "fallback" },
          ["<Down>"] = { "fallback" },
        },
      },

      appearance = {
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- experimental signature help support
      signature = { enabled = true },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        markdown = { "prettier" },
        tex = { "latexindent" },
      },

      formatters = {
        black = {
          prepend_args = { "--safe" },
        },
      },
    },
    init = function()
      vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
    end,
  },
}
