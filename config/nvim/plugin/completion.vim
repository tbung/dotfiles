" Set up completion
autocmd BufEnter * lua require'completion'.on_attach()
" Show snippets in completion
let g:completion_enable_snippet = 'UltiSnips'
"map <c-p> to manually trigger completion
imap <silent> <c-p> <Plug>(completion_trigger)

