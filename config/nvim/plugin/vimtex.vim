" Tell vim to assume latex instead of plaintex
let g:tex_flavor='latex'
let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:vimtex_view_method="zathura"
let g:vimtex_fold_enabled=1
let g:completor_tex_omni_trigger=g:vimtex#re#neocomplete
let g:vimtex_grammar_textidote =  {'jar': '/opt/textidote/textidote.jar',
                                  \ 'args': '--read-all'}
