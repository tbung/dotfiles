local M = {}

local fnames = {} ---@type string[]
local handle ---@type vim.SystemObj?

function M.refresh()
  if handle ~= nil then
    return
  end

  fnames = {}

  local prev

  handle = vim.system({ "fd", "-t", "f", "--hidden", "--color=never", "-E", ".git" },
    {
      stdout = function(err, data)
        assert(not err, err)
        if not data then
          return
        end

        if prev then
          data = prev .. data
        end

        if data[#data] == "\n" then
          vim.list_extend(fnames, vim.split(data, "\n", { trimempty = true }))
        else
          local parts = vim.split(data, "\n", { trimempty = true })
          prev = parts[#parts]
          parts[#parts] = nil
          vim.list_extend(fnames, parts)
        end
      end,
    }, function(obj)
      handle = nil
    end)


  vim.api.nvim_create_autocmd("CmdlineLeave", {
    once = true,
    callback = function()
      if handle then
        handle:wait(0)
        handle = nil
      end
    end,
  })

  vim.wait(200, function() return #fnames > 0 end, 50, true)
end

function M.fd_findfunc(cmdarg, _cmdcomplete)
  if #cmdarg == 0 then
    return fnames
  else
    return vim.fn.matchfuzzy(fnames, cmdarg, { matchseq = 1, limit = 100 })
  end
end

return M
