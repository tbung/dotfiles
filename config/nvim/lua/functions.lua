function P(x)
    print(vim.inspect(x))
end

function is_cwd_git_repo()
    return os.execute("git status") == 0
end

function git_branches()
    local f = io.popen("git for-each-ref --format='%(refname:short)' refs/heads")
    local branches = {}
    for branch in f:lines() do
        table.insert(branches, branch)
    end
    f:close()
    return branches
end

function git_remotes()
    local f = io.popen("git remote")
    local remotes = {}
    for remote in f:lines() do
        table.insert(remotes, remote)
    end
    f:close()
    return remotes
end

function PushCluster()
    if (not is_cwd_git_repo()) then
        print("Not in git repository")
        return
    end

    if (not vim.tbl_contains(git_remotes(), "cluster")) then
        print("Not remote named cluster")
        return
    end

    vim.cmd([[Git push cluster -f]])
end

vim.cmd([[command! PushCluster lua PushCluster()]])
