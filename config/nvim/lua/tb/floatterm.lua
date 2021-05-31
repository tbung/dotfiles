-- Run a command in a floating terminal window
function run_floatterm(cmd)
    local ui = vim.api.nvim_list_uis()[1]

    local buf = vim.api.nvim_create_buf(false, true)

    local width = 120
    local height = 30

    local win = vim.api.nvim_open_win(buf, true, {
        relative='editor',
        width=width,
        height=height,
        col=(ui.width/2) - (width/2),
        row=(ui.height/2) - (height/2),
        -- style='minimal',
    })
    local function run()
        return vim.fn.termopen(cmd)
    end
    vim.api.nvim_buf_call(buf, run)
end

vim.api.nvim_command("command -range -nargs=* FloatTerm :lua run_floatterm(vim.fn.expandcmd([[<args>]]))")
