" Some nice defaults borrowed from Neovim
set nocompatible
set autoindent
set autoread
set belloff=all
set backspace=indent,eol,start
set encoding=utf-8
set laststatus=2
set history=10000
set hlsearch
set incsearch
set smarttab
set ttimeout
set ttimeoutlen=50
set ttyfast
set wildmenu
syntax on
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Set relative line numbers to make it easier to jump to a line
set number
set relativenumber

" Always show filename and modified marker in status line
set statusline=%f\ %m
  
" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable mouse support
set mouse+=a

" Use 2 spaces as default indentation
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

" Enable soft line wrapping
set wrap
set linebreak
set breakindent

" Always show 4 lines above and below the cursor
set scrolloff=4

" Allow using uppercase W and Q commands to save/quit
command WQ wq
command Wq wq
command W w
command Q q

" Type :C to open this config file
command! -nargs=0 C :e $MYVIMRC

" Type ':R' to reload config file
command! -nargs=0 R :source $MYVIMRC

" Press Enter to clear search highlighting
nnoremap <silent><CR> :nohlsearch<CR>
