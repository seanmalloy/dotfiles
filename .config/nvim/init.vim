" start load plugins using junegunn/vim-plug
call plug#begin()
Plug 'neovim/nvim-lspconfig', { 'tag': 'v0.1.2' }
call plug#end()
" end load plugins

" general settings
set number           " show line numbers
set autowrite        " write files when switching between files
set nowrap           " do not wrap lines
set visualbell       " visual bell instead of beeping
set shiftround       " indent/outdent to nearest tabstop
set matchpairs+=<:>  " % to bounce between angles too
set inccommand=split " real time preview of substitutions

" folding settings
set foldmethod=indent " fold based on indent
set foldnestmax=10    " deepest fold is 10 levels
set nofoldenable      " dont fold by default
set foldlevel=1       " this is just what i use

" color scheme
colorscheme darkblue

" in command mode expand %% to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

