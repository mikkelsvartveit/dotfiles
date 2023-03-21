" NEOVIM SETTINGS - settings regarding Neovim itself

" Set leader key to comma, since the default sucks for nordic keyboards
let mapleader = ','

" Set UI language to English
set langmenu=en_US
let $LANG = 'en_US'

" Disable splash screen
set shortmess+=I

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

" Disable mouse support (to force myself to use the keyboard)
set mouse=

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

" Save and close all buffers with ZZ
nnoremap ZZ :wa<CR>:qa<CR>

" Exit Terminal mode with Ctrl+k
tnoremap <C-k> <C-\><C-n>

" Make yank use system clipboard as default
nnoremap <expr> y (v:register ==# '"' ? '"+' : '') . 'y'
nnoremap <expr> yy (v:register ==# '"' ? '"+' : '') . 'yy'
nnoremap <expr> Y (v:register ==# '"' ? '"+' : '') . 'Y'
xnoremap <expr> y (v:register ==# '"' ? '"+' : '') . 'y'
xnoremap <expr> Y (v:register ==# '"' ? '"+' : '') . 'Y'

" Map 'gp' to paste from system clipboard
nnoremap <expr> gp (v:register ==# '"' ? '"+' : '') . 'p'
nnoremap <expr> gP (v:register ==# '"' ? '"+' : '') . 'P'
xnoremap <expr> gp (v:register ==# '"' ? '"+' : '') . 'p'
xnoremap <expr> gP (v:register ==# '"' ? '"+' : '') . 'P'

" Press Enter to clear search highlighting
nnoremap <silent><CR> :nohlsearch<CR>

" Disable arrow keys in normal mode - enforce hjkl instead
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Fix terminal cursor after exiting
au VimLeave * set guicursor=a:ver100

" Use Bash as shell for internal Vim commands (fish is slow)
set shell=/bin/bash

" Load default Coc config from separate file
lua require("coc-defaults")

" Load plugins from separate file
lua require("plugins")
