setlocal foldmethod=indent
let b:ale_fixers=['autopep8']

" Open IPython terminal split and tell slime about it
nmap <C-c><C-s> :vsplit term://ipython<CR>
let g:slime_target = "neovim"
let g:slime_dont_ask_default = 1
let g:slime_preserve_curpos = 0
autocmd TermOpen * let g:slime_default_config = {"jobid": &channel}
