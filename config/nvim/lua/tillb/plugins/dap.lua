return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    "nvim-telescope/telescope-dap.nvim",
  },
  config = function()
    -- FIX: https://github.com/mfussenegger/nvim-dap/pull/839
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dap-repl",
      callback = function(args)
        vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
      end,
    })

    local dap = require("dap")

    require("nvim-dap-virtual-text").setup({
      enabled = true,

      -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
      enabled_commands = false,

      -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_changed_variables = true,
      highlight_new_as_changed = true,

      -- prefix virtual text with comment string
      commented = false,

      show_stop_reason = true,

      -- experimental features:
      virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false,    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    })

    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
        host = function()
          local value = vim.fn.input("Host [127.0.0.1]: ")
          if value ~= "" then
            return value
          end
          return "127.0.0.1"
        end,
        port = function()
          local val = tonumber(vim.fn.input("Port: "))
          assert(val, "Please provide a port number")
          return val
        end,
      },
    }

    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host, port = config.port })
    end

    -- local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
    -- local codelldb_path = extension_path .. "adapter/codelldb"
    -- local liblldb_path
    --
    -- local os = vim.loop.os_uname().sysname
    --
    -- if os == "Darwin" then
    --   liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
    -- elseif os == "Linux" then
    --   liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    -- end
    -- dap.adapters.codelldb = {
    --   type = "server",
    --   port = "${port}",
    --   executable = {
    --     -- CHANGE THIS to your path!
    --     command = codelldb_path,
    --     args = { "--port", "${port}" },
    --   },
    -- }

    dap.configurations.c = {
      {
        name = "Launch file with args",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        args = function()
          return vim.fn.input("args: ")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "c", "cpp" } })
    require("dap.ext.vscode").load_launchjs(vim.fn.getcwd() .. "/launch.json", { codelldb = { "c", "cpp" } })

    require("dap-python").setup()
    require("dap-python").test_runner = "pytest"

    require("dapui").setup()

    vim.fn.sign_define("DapBreakpoint", { text = "Ⓑ", texthl = "Error", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "Ⓑ", texthl = "Warning", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "Ⓑ", texthl = "Hint", linehl = "", numhl = "" })

    vim.keymap.set("n", "<leader>dc", function()
      require("dap").continue()
    end, { desc = "Continue debugging" })

    vim.keymap.set("n", "<leader>du", function()
      require("dapui").toggle()
    end, { desc = "Toggle DAP UI" })

    vim.keymap.set("n", "<leader>dbb", function()
      require("dap").toggle_breakpoint()
    end, { desc = "Toggle breakpoint" })

    vim.keymap.set("n", "<leader>dss", function()
      require("dap").step_over()
    end, { desc = "Step over" })

    vim.keymap.set("n", "<leader>dsi", function()
      require("dap").step_into()
    end, { desc = "Step into" })

    vim.keymap.set("n", "<leader>dso", function()
      require("dap").step_out()
    end, { desc = "Step out" })

    vim.keymap.set("n", "<leader>dkk", function()
      require("dap").terminate()
    end, { desc = "Terminate debug process" })
  end,
}
