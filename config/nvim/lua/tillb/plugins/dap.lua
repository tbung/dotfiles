return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    "nvim-telescope/telescope-dap.nvim",
  },
  keys = {
    {"<leader>dc", function() require("dap").continue() end, desc = "Continue debugging" },
    {"<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    {"<leader>dbb", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    {"<leader>dss", function() require("dap").step_over() end, desc = "Step over" },
    {"<leader>dsi", function() require("dap").step_into() end, desc = "Step into" },
    {"<leader>dso", function() require("dap").step_out() end, desc = "Step out" },
    {"<leader>dkk", function() require("dap").terminate() end, desc = "Terminate debug process" },
  },
  config = function()
    local dap = require("dap")

    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = false,
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
      commented = false,
      show_stop_reason = true,
      virt_text_pos = "eol",
      all_frames = false,
    })

    -- local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
    -- local codelldb_path = extension_path .. "adapter/codelldb"
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
      --   -- CHANGE THIS to your path!
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }

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

  end,
}
