---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        },
    },
}
