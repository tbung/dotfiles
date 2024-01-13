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
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "microsoft/python-type-stubs",
    },
    config = function()
      require("neodev").setup()

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
        pyright = {
          settings = {
            python = {
              analysis = {
                stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
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

      vim.api.nvim_set_hl(
        0,
        "DiagnosticUnderlineError",
        { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineError", true).special }
      )
      vim.api.nvim_set_hl(
        0,
        "DiagnosticUnderlineWarn",
        { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineWarn", true).special }
      )
      vim.api.nvim_set_hl(
        0,
        "DiagnosticUnderlineInfo",
        { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineInfo", true).special }
      )
      vim.api.nvim_set_hl(
        0,
        "DiagnosticUnderlineHint",
        { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineHint", true).special }
      )

      vim.cmd([[sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=]])
      vim.cmd([[sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=]])
      vim.cmd([[sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=]])
      vim.cmd([[sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=]])

      -- HACK: this is a workaround from https://github.com/neovim/neovim/issues/23291#issuecomment-1687088266

      local FSWATCH_EVENTS = {
        Created = 1,
        Updated = 2,
        Removed = 3,
        -- Renamed
        OwnerModified = 2,
        AttributeModified = 2,
        MovedFrom = 1,
        MovedTo = 3,
        -- IsFile
        -- IsDir
        -- IsSymLink
        -- Link
        -- Overflow
      }

      --- @param data string
      --- @param opts table
      --- @param callback fun(path: string, event: integer)
      local function fswatch_output_handler(data, opts, callback)
        local d = vim.split(data, "%s+")
        local cpath = d[1]

        for i = 2, #d do
          if d[i] == "IsDir" or d[i] == "IsSymLink" or d[i] == "PlatformSpecific" then
            return
          end
        end

        if opts.include_pattern and opts.include_pattern:match(cpath) == nil then
          return
        end

        if opts.exclude_pattern and opts.exclude_pattern:match(cpath) ~= nil then
          return
        end

        for i = 2, #d do
          local e = FSWATCH_EVENTS[d[i]]
          if e then
            callback(cpath, e)
          end
        end
      end

      local function fswatch(path, opts, callback)
        local obj = vim.system({
          "fswatch",
          "--recursive",
          "--event-flags",
          "--exclude",
          "/.git/",
          path,
        }, {
          stdout = function(_, data)
            if not data then
              return
            end
            for line in vim.gsplit(data, "\n", { plain = true, trimempty = true }) do
              fswatch_output_handler(line, opts, callback)
            end
          end,
        })

        return function()
          obj:kill(2)
        end
      end

      if vim.fn.executable("fswatch") == 1 then
        require("vim.lsp._watchfiles")._watchfunc = fswatch
      end
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
    keys = {
      {
        "<leader>vf",
        function()
          require("conform").format({
            async = true,
            lsp_fallback = "always",
            filter = function(client)
              return client.name ~= "ruff_lsp"
            end,
          })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        bash = { "shfmt" },
        sh = { "shfmt" },
      },

      formatters = {
        black = {
          prepend_args = { "--safe" },
        },
      },
    },
  },
}
