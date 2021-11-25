local Job = require("plenary.job")

function P(x)
    print(vim.inspect(x))
end

local function is_git_worktree(dir)
    local inside_worktree_job = Job:new({
        'git', 'rev-parse', '--is-inside-work-tree',
        cwd = dir
    })
    local stdout, code = inside_worktree_job:sync()
    if code ~= 0 then
        return false
    end
    stdout = table.concat(stdout, "")
    if stdout == "true" then
        return true
    end
    return false
end

-- local function git_branches()
--     local all_branches_job = Job:new({
--         "git", "for-each-ref", "--format='%(refname:short)'", "refs/heads",
--     })
--
--     local branches = {}
--     for branch in f:lines() do
--         table.insert(branches, branch)
--     end
--     f:close()
--     return branches
-- end

local function git_remotes()
    local all_remotes_job = Job:new({
        "git", "remote",
    })

    local stdout, code = all_remotes_job:sync()
    if code ~= 0 then
        return ""
    end
    return stdout
end

function git_worktree()
    -- TODO: Return branch of current file instead of cwd?
    local cwd = vim.loop.cwd()
    local current_branch_job = Job:new({
        'git', 'branch', '--show-current',
        cwd = cwd
    })

    if is_git_worktree(cwd) then
        local stdout, code = current_branch_job:sync()
        if code ~= 0 then
            return ""
        end
        stdout = table.concat(stdout, "")
        return " " .. stdout
    end

    return ""
end

function PushCluster()
    local cwd = vim.loop.cwd()
    if (not is_git_worktree(cwd)) then
        print("Not in git repository")
        return
    end

    if (not vim.tbl_contains(git_remotes(), "cluster")) then
        print("Not remote named cluster")
        return
    end

    local push_cluster_job = Job:new({
        "git", "push", "cluster", "-f",
        cwd = cwd,
        on_stdout = function(err, data, self)
            print(data)
        end,
        on_stderr = function(err, data, self)
            print(data)
        end,
    })

    push_cluster_job:sync()
end

vim.cmd([[command! PushCluster lua PushCluster()]])

function git_toggle()
    local buffers = vim.api.nvim_list_bufs()
    local bufid = nil
    for i, buf in ipairs(buffers) do
        if vim.api.nvim_buf_get_option(buf, "filetype") == "fugitive" then
            bufid = buf
        end
    end
    if bufid == nil then
        vim.cmd[[Git]]
    else
        vim.api.nvim_buf_delete(bufid, {})
    end
end
