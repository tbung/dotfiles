function search_zotero()
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    require('telescope').extensions.media_files.media_files({
        cwd = "~/Zotero",
        find_cmd = {"fd", "-t f", "pdf"},

        attach_mappings=function(prompt_bufnr,map)
            actions.select:replace(function()
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if entry[1] then
                    local filename = entry[1]
                    -- local cmd="call setreg(v:register,'"..filename.."')";
                    -- vim.cmd(cmd)
                    print(filename)
                end
            end
            )
            return true
        end,
    })
end
