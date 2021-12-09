local gl = require('galaxyline')
local colors = require('galaxyline.theme').default
local condition = require('galaxyline.condition')
local gls = gl.section

gl.short_line_list = {'NvimTree','vista','dbui','packer','Trouble'}

gls.left = {}

table.insert(
    gls.left,
    {
        FileIcon = {
            provider = 'FileIcon',
            condition = condition.buffer_not_empty,
            highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
        },
    }
)

table.insert(
    gls.left,
    {
        FilePath = {
            provider = function()
                local path = vim.fn.expand("%:h")
                if path ~= '' then
                    path = path .. '/'
                end
                return path
            end,
            condition = condition.buffer_not_empty,
            highlight = {colors.fg,colors.bg}
        }
    }
)

table.insert(
    gls.left,
    {
        FileName = {
            provider = 'FileName',
            condition = condition.buffer_not_empty,
            highlight = {colors.fg,colors.bg,'bold'}
        }
    }
)

table.insert(
    gls.left,
    {
        GitSeparator = {
            provider = function() return '  |' end,
            condition = function()
                return condition.check_git_workspace() and condition.buffer_not_empty()
            end,
            separator = ' ',
            separator_highlight = {'NONE', colors.bg},
            highlight = {colors.fg,colors.bg},
        }
    }
)

local color_git = '#888888'
table.insert(
    gls.left,
    {
        GitIcon = {
            provider = function() return ' ' end,
            condition = condition.check_git_workspace,
            separator = ' ',
            separator_highlight = {'NONE', colors.bg},
            highlight = {color_git,colors.bg,'bold'},
        }
    }
)

table.insert(
    gls.left,
    {
        GitBranch = {
            provider = 'GitBranch',
            condition = condition.check_git_workspace,
            highlight = {color_git,colors.bg,'bold'},
        }
    }
)


table.insert(
    gls.left,
    {
        DiagnosticSeparator = {
            provider = function() return '   | ' end,
            separator = ' ',
            separator_highlight = {'NONE', colors.bg},
            highlight = {colors.fg,colors.bg},
        }
    }
)

table.insert(
    gls.left,
    {
        DiagnosticError = {
            provider = function ()
                return #vim.diagnostic.get(0, {severity = "Error"})
            end,
            icon = ' ',
            separator = ' ',
            separator_highlight = {'NONE', colors.bg},
            highlight = {colors.red,colors.bg}
        }
    }
)

table.insert(
    gls.left,
    {
        DiagnosticWarn = {
            provider = function ()
                return #vim.diagnostic.get(0, {severity = "Warn"})
            end,
            icon = '  ',
            separator = ' ',
            separator_highlight = {'NONE', colors.bg},
            highlight = {colors.yellow,colors.bg},
        }
    }
)

table.insert(
    gls.left,
    {
        DiagnosticHint = {
            provider = function ()
                return #vim.diagnostic.get(0, {severity = "Hint"})
            end,
            icon = '  ',
            separator = ' ',
            separator_highlight = {'NONE', colors.bg},
            highlight = {colors.cyan,colors.bg},
        }
    }
)

table.insert(
    gls.left,
    {
        DiagnosticInfo = {
            provider = function ()
                return #vim.diagnostic.get(0, {severity = "Info"})
            end,
            icon = '  ',
            highlight = {colors.blue,colors.bg},
        }
    }
)

gls.mid = {}

-- table.insert(
--     gls.mid,
--     {
--         ShowLspClient = {
--             provider = 'GetLspClient',
--             condition = function ()
--                 local tbl = {['dashboard'] = true,['']=true}
--                 if tbl[vim.bo.filetype] then
--                     return false
--                 end
--                 return true
--             end,
--             icon = ' LSP:',
--             highlight = {colors.cyan,colors.bg,'bold'}
--         }
--     }
-- )

gls.right = {}

-- table.insert(
--     gls.right,
--     {
--         FileEncode = {
--             provider = 'FileEncode',
--             condition = condition.hide_in_width,
--             separator = ' ',
--             separator_highlight = {'NONE',colors.bg},
--             highlight = {colors.green,colors.bg,'bold'}
--         }
--     }
-- )

-- table.insert(
--     gls.right,
--     {
--         FileFormat = {
--             provider = 'FileFormat',
--             condition = condition.hide_in_width,
--             separator = ' ',
--             separator_highlight = {'NONE',colors.bg},
--             highlight = {colors.green,colors.bg,'bold'}
--         }
--     }
-- )

table.insert(
    gls.right,
    {
        LineInfo = {
            provider = function ()
                local line = vim.fn.line('.')
                local column = vim.fn.col('.')
                return string.format("%4d,%-3d ", line, column)
            end,
            separator = '',
            separator_highlight = {'NONE',colors.bg},
            highlight = {colors.fg,colors.bg},
        },
    }
)

table.insert(
    gls.right,
    {
        PerCent = {
            provider = 'LinePercent',
            separator = '    ',
            separator_highlight = {'NONE',colors.bg},
            highlight = {colors.fg,colors.bg,'bold'},
        }
    }
)

-- table.insert(
--     gls.right,
--     {
--         DiffAdd = {
--             provider = 'DiffAdd',
--             condition = condition.hide_in_width,
--             icon = '  ',
--             highlight = {colors.green,colors.bg},
--         }
--     }
-- )

-- table.insert(
--     gls.right,
--     {
--         DiffModified = {
--             provider = 'DiffModified',
--             condition = condition.hide_in_width,
--             icon = ' 柳',
--             highlight = {colors.orange,colors.bg},
--         }
--     }
-- )

-- table.insert(
--     gls.right,
--     {
--         DiffRemove = {
--             provider = 'DiffRemove',
--             condition = condition.hide_in_width,
--             icon = '  ',
--             highlight = {colors.red,colors.bg},
--         }
--     }
-- )

-- table.insert(
--     gls.right,
--     {
--         RainbowBlue = {
--             provider = function() return ' ▊' end,
--             highlight = {colors.blue,colors.bg}
--         },
--     }
-- )

gls.short_line_left = {}

table.insert(
    gls.short_line_left,
    {
        BufferType = {
            provider = 'FileTypeName',
            separator = ' ',
            separator_highlight = {'NONE',colors.bg},
            highlight = {colors.blue,colors.bg,'bold'}
        }
    }
)

table.insert(
    gls.short_line_left,
    {
        SFileName = {
            provider =  'SFileName',
            condition = condition.buffer_not_empty,
            highlight = {colors.fg,colors.bg,'bold'}
        }
    }
)

gls.short_line_right = {}

table.insert(
    gls.short_line_right,
    {
        BufferIcon = {
            provider= 'BufferIcon',
            highlight = {colors.fg,colors.bg}
        }
    }
)
