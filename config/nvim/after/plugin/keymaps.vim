" Disable arrow keys in normal mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Disable arrow keys in insert mode
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" Sane pane switching
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" FZF key bindings
nnoremap <silent> <C-p> :Files<cr>
nnoremap <silent> - :Buffers<cr>
nnoremap <silent> <C-t> :Tags <C-R><C-W><CR>

" EasyAlign key bindings
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
