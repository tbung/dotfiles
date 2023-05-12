return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason" },
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("neodev").setup()

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "arduino_language_server",
          -- "clangd",
          -- "pyright",
          -- "lua_ls",
          -- "texlab",
        },
      })

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
                executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                args = { "-b", "%l", "%p", "%f" },
              },
            },
          },
        },

        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy" },
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
      }

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local function setup(server_name) -- default handler (optional)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, overrides[server_name] or {})

        require("lspconfig")[server_name].setup(server_opts)
      end

      require("mason-lspconfig").setup_handlers({ setup })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- "black",
          -- "codelldb",
          -- "isort",
          -- "stylua",
        },
      })
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.diagnostics.pylint.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            timeout = 10000,
            condition = function(utils)
              return vim.fn.executable("pylint") > 0
            end,
          }),
          null_ls.builtins.diagnostics.mypy.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            timeout = 10000,
            condition = function(utils)
              return vim.fn.executable("mypy") > 0
            end,
          }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.prettier,
        },
      }
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
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      return {
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
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          fields = { "abbr", "menu", "kind" },
          format = function(entry, item)
            local short_name = {
              nvim_lsp = "LSP",
              nvim_lua = "nvim",
            }

            local menu_name = short_name[entry.source.name] or entry.source.name

            item.menu = string.format("[%s]", menu_name)
            return item
          end,
        },
      }
    end,
  },
}
