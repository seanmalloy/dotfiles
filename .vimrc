" Sean Malloy's .vimrc file.

" Load plugins using pathogen
filetype on
execute pathogen#infect()
execute pathogen#helptags()

" Use Vim setting instead of Vi settings. Must be first.
set nocompatible

syntax on                        " enable syntax highlighting
set number                       " show line numbers
set autowrite                    " write files when switching between files
set history=50                   " keep 50 lines of command line history
set hlsearch                     " highlight searchs
set incsearch                    " do incremental searching
set nowrap                       " do not wrap lines
set ruler                        " show the cursor position all the time
set showcmd                      " display incomplete commands
set visualbell                   " visual bell instead of beeping
set autoindent                   " preserves current indent on new lines
set backspace=indent,eol,start   " make backspaces delete sensibly
set shiftround                   " indent/outdent to nearest tabstop
set matchpairs+=<:>              " all % to bounce between angles too
"set textwidth=78                " wrap at this column

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" File Type Plugin Settings
filetype on
filetype plugin on
filetype indent on
filetype plugin indent on

" Color Scheme
colorscheme darkblue

" delimitMate Plugin Config
au FileType c      let b:delimitMate_expand_cr = 1
au FileType cpp    let b:delimitMate_expand_cr = 1
au FileType perl   let b:delimitMate_expand_cr = 1
au FileType puppet let b:delimitMate_expand_cr = 1
au FileType sh     let b:delimitMate_expand_cr = 1

let delimitMate_matchpairs = '(:),{:},[:]'

" in command mode expand %% to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

