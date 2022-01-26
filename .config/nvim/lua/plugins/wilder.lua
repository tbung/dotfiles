vim.cmd([[
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({'hide_in_substitute': 1}),
      \     wilder#search_pipeline(),
      \   ),
      \ ])

" call wilder#set_option('renderer', wilder#wildmenu_renderer({
"       \ 'highlighter': wilder#basic_highlighter(),
"       \ }))
]])
