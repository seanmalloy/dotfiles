" general settings
set number             " show line numbers
set autowrite          " write files when switching between files
set nowrap             " do not wrap lines
set visualbell         " visual bell instead of beeping
set shiftround         " indent/outdent to nearest tabstop
set matchpairs+=<:>    " all % to bounce between angles too

" folding settings
set foldmethod=indent  " fold based on indent
set foldnestmax=10     " deepest fold is 10 levels
set nofoldenable       " dont fold by default
set foldlevel=1        " this is just what i use

" color scheme
colorscheme darkblue

" in command mode expand %% to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" TODO
"
" delimitMate Plugin Config
" au FileType c      let b:delimitMate_expand_cr = 1
" au FileType cpp    let b:delimitMate_expand_cr = 1
" au FileType perl   let b:delimitMate_expand_cr = 1
" au FileType puppet let b:delimitMate_expand_cr = 1
" au FileType sh     let b:delimitMate_expand_cr = 1
" let delimitMate_matchpairs = '(:),{:},[:]'
