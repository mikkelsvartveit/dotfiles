" NEOVIM SETTINGS - settings regarding Neovim itself

" Set leader key to comma, since the default sucks for nordic keyboards
let mapleader = ','

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Always show 4 lines above and below the cursor
set scrolloff=4

" Allow using uppercase :W to save
command W call VSCodeCall('workbench.action.files.save')

" Make yank use system clipboard as default
:nnoremap <expr> y (v:register ==# '"' ? '"+' : '') . 'y'
:nnoremap <expr> yy (v:register ==# '"' ? '"+' : '') . 'yy'
:nnoremap <expr> Y (v:register ==# '"' ? '"+' : '') . 'Y'
:xnoremap <expr> y (v:register ==# '"' ? '"+' : '') . 'y'
:xnoremap <expr> Y (v:register ==# '"' ? '"+' : '') . 'Y'

" Map 'gp' to paste from system clipboard
:nnoremap <expr> gp (v:register ==# '"' ? '"+' : '') . 'p'
:nnoremap <expr> gP (v:register ==# '"' ? '"+' : '') . 'P'
:xnoremap <expr> gp (v:register ==# '"' ? '"+' : '') . 'p'
:xnoremap <expr> gP (v:register ==# '"' ? '"+' : '') . 'P'

" Map leader bindings to VSCode commands
nnoremap <leader>p <cmd>call VSCodeNotify('workbench.action.quickOpen')<cr>
nnoremap <leader>b <cmd>call VSCodeNotify('workbench.action.showAllEditors')<cr>
nnoremap <leader>o <cmd>call VSCodeNotify('workbench.action.quickOpen')<cr>
nnoremap <leader>f <cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>
nnoremap <leader>: <cmd>call VSCodeNotify('workbench.action.showCommands')<cr>
nnoremap <leader>d <cmd>call VSCodeNotify('workbench.view.scm')<cr>
nnoremap <leader>n <cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>

" Disable arrow keys in normal mode - enforce hjkl instead
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>



" PLUGINS - installation and configuration

" Install Plug (plugin manager) if not already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * q
endif

" Install plugins automatically when launching Neovim
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Fetch plugins with Plug
call plug#begin()

" Easy commenting/uncommenting
Plug 'numToStr/Comment.nvim'

" Easy handling of surroundings (tags, brackets etc.)
Plug 'tpope/vim-surround'

" End of plugin fetching
call plug#end()

" Configure Comment.nvim
lua require('Comment').setup()
