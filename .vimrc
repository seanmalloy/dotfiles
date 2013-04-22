" Sean Malloy's .vimrc file.

" Use Vim setting instead of Vi settings
" Must be first.
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
"set autoindent                   " preserves current indent on new lines
"set smartindent                  
set backspace=indent,eol,start   " make backspaces delete sensibly
"set tabstop=4                    " indentation levels every 4 columns
set softtabstop=4                " 
set expandtab                    " convert all tabs typed to spaces
set shiftwidth=4                 " indent/outdent by 4 columns
set shiftround                   " indent/outdent to nearest tabstop

set matchpairs+=<:>              " all % to bounce between angles too

" set textwidth=78                 " wrap at this column

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
let delimitMate_apostrophes = ''
let delimitMate_autoclose = 1
let delimitMate_balance_matchpairs = 0
let delimitMate_eol_marker = ''
let delimitMate_excluded_ft = ''
let delimitMate_excluded_regions = 'Comment'
let delimitMate_expand_cr = 1                      " not default
let delimitMate_expand_space = 0
let delimitMate_matchpairs = '(:),{:},[:],<:>'
let delimitMate_nesting_quotes = []
let delimitMate_quotes = '" '' `'
let delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|\$\|_\|["'']\s*\S\)'
let delimitMate_smart_quotes = 1

"-------------------------------------------------------------------------------
" comma always followed by a space
"-------------------------------------------------------------------------------
"inoremap  ,  ,<Space>
"
"-------------------------------------------------------------------------------
" autocomplete parenthesis, (brackets) and braces
"-------------------------------------------------------------------------------
" inoremap  (  ()<Left>
" inoremap  [  []<Left>
" inoremap  {  {}<Left>

" vnoremap  (  s()<Esc>P<Right>%
" vnoremap  [  s[]<Esc>P<Right>%
" vnoremap  {  s{}<Esc>P<Right>%

" surround content with additional spaces
" vnoremap  )  s(  )<Esc><Left>P<Right><Right>%
" vnoremap  ]  s[  ]<Esc><Left>P<Right><Right>%
" vnoremap  }  s{  }<Esc><Left>P<Right><Right>%

