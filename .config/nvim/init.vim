" start load plugins using junegunn/vim-plug
call plug#begin()
Plug 'neovim/nvim-lspconfig', { 'tag': 'v0.1.2' }
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
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

" enable spell checker
set spelllang=en
nnoremap <silent> <F3> :set spell!<CR>
inoremap <silent> <F3> <C-O>:set spell!<CR>

" folding settings
set foldmethod=indent " fold based on indent
set foldnestmax=10    " deepest fold is 10 levels
set nofoldenable      " dont fold by default
set foldlevel=1       " this is just what i use

" color scheme
colorscheme darkblue

" in command mode expand %% to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" LSP Setup using plugin hrsh7th/nvim-cmp
set completeopt=menu,menuone,noselect
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Add additional capabilities supported by nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  local lspconfig = require('lspconfig')

  -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
  local servers = { 'gopls', 'rls' }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      -- on_attach = my_custom_on_attach,
      capabilities = capabilities,
    }
  end
EOF

