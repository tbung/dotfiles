if vim.g.basic then
  return {}
end

local cmp_kinds = {
  Text = "  ",
  Method = "  ",
  Function = "  ",
  Constructor = "  ",
  Field = "  ",
  Variable = "  ",
  Class = "  ",
  Interface = "  ",
  Module = "  ",
  Property = "  ",
  Unit = "  ",
  Value = "  ",
  Enum = "  ",
  Keyword = "  ",
  Snippet = "  ",
  Color = "  ",
  File = "  ",
  Reference = "  ",
  Folder = "  ",
  EnumMember = "  ",
  Constant = "  ",
  Struct = "  ",
  Event = "  ",
  Operator = "  ",
  TypeParameter = "  ",
  Copilot = "  ",
}

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
          capabilities = {
            textDocument = { semanticTokens = vim.NIL },
            workspace = { semanticTokens = vim.NIL },
          },
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
            "--background-index",
            -- TODO: these should be project local
            -- "--query-driver=/home/tillb/.espressif/tools/xtensa-esp32-elf/esp-2021r1-8.4.0/**/bin/xtensa-esp32-elf-*",
            -- "--query-driver=/home/tillb/.espressif/tools/riscv32-esp-elf/esp-12.2.0_20230208/**/bin/riscv32-esp-elf-*",
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
        require("cmp_nvim_lsp").default_capabilities()
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
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    lazy = true,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "lazydev", group_index = 0 },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          fields = { "abbr", "menu", "kind" },
          format = function(entry, item)
            item.kind = (cmp_kinds[item.kind] or "") .. item.kind
            return item
          end,
        },
      })

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
        }),
      })
    end,
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
      },

      formatters = {
        black = {
          prepend_args = { "--safe" },
        },
      },
    },
    init = function()
      -- vim.o.formatexpr = [[v:lua.require("conform").formatexpr({ async = true, lsp_fallback = "always", filter = function(client) return client.name ~= "ruff_lsp" end })]]
      vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
    end,
  },
}
