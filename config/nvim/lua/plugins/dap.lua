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
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
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

-- local function get_python_path()
--   local conda_env = os.getenv("CONDA_PREFIX")
--
--   if conda_env then
--     return conda_env .. "/bin/python"
--   end
--
--   return nil
-- end
--
-- require("dap-python").setup("~/.mamba/envs/debugpy/bin/python", { pythonPath = get_python_path() })
require("dap-python").setup()
require("dap-python").test_runner = "pytest"

require("dapui").setup()

vim.fn.sign_define("DapBreakpoint", { text = "Ⓑ", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "Ⓑ", texthl = "Warning", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "Ⓑ", texthl = "Hint", linehl = "", numhl = "" })
