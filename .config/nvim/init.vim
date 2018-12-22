" start load plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'scrooloose/nerdtree'

call plug#end()
" end load plugins

" general settings
set number             " show line numbers
set autowrite          " write files when switching between files
set nowrap             " do not wrap lines
set visualbell         " visual bell instead of beeping
set shiftround         " indent/outdent to nearest tabstop
set matchpairs+=<:>    " % to bounce between angles too

" folding settings
set foldmethod=indent  " fold based on indent
set foldnestmax=10     " deepest fold is 10 levels
set nofoldenable       " dont fold by default
set foldlevel=1        " this is just what i use

" color scheme
colorscheme darkblue

" in command mode expand %% to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"
" NerdTree Settings
"

" start on vim load
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" exit if NerdTree is the only window left
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ctrl+n open NerdTree
map <C-n> :NERDTreeToggle<CR>
