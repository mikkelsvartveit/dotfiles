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

" Press Enter to clear search highlighting
nnoremap <silent><CR> :nohlsearch<CR>

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
nnoremap <leader>c <cmd>call VSCodeNotify('workbench.action.showCommands')<cr>
nnoremap <leader>d <cmd>call VSCodeNotify('workbench.view.scm')<cr>
nnoremap <leader>n <cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>
nnoremap <leader>rn <cmd>call VSCodeNotify('editor.action.rename')<cr>
xnoremap gc <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
nnoremap gc <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
nnoremap gcc <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
xnoremap gb <Cmd>call VSCodeNotify('editor.action.blockComment')<CR>
nnoremap gb <Cmd>call VSCodeNotify('editor.action.blockComment')<CR>

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

" Easy handling of surroundings (tags, brackets etc.)
Plug 'tpope/vim-surround'

" End of plugin fetching
call plug#end()

" Fix for output panel opening on search
set shortmess+=s

" Fix for hanging in VSCode
set re=0
