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

" Color theme
Plug 'sonph/onehalf', { 'rtp': 'vim' }
" Plug 'arcticicestudio/nord-vim'

" VSCode-like language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax highlighting for almost every language
Plug 'sheerun/vim-polyglot'

" Add two-character motions with s and S
Plug 'ggandor/leap.nvim'
Plug 'tpope/vim-repeat'

" VSCode-like multi-cursor support
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Easy commenting/uncommenting
Plug 'numToStr/Comment.nvim'

" Easy handling of surroundings (tags, brackets etc.)
Plug 'tpope/vim-surround'

" Github Copilot
Plug 'github/copilot.vim'

" Auto-restore session when opening Neovim
Plug 'rmagatti/auto-session'

" File explorer sidebar
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua', { 'commit': 'e14989c' }

" Fuzzy finder for files, buffers, etc. (including dependencies)
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Persistent terminal that can be toggled with a keybinding
Plug 'akinsho/toggleterm.nvim', {'tag': '2.3.0'}

" Easily run code with a keybinding
Plug 'CRAG666/code_runner.nvim'

" Live Markdown preview in browser
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }

" Git integration: show modified lines next to line numbers
Plug 'lewis6991/gitsigns.nvim'

" Tool for resolving Git merge conflicts
Plug 'rhysd/conflict-marker.vim'

" VSCode-like scrollbar with Git and diagnostic markers
Plug 'petertriho/nvim-scrollbar'

" Smooth scrolling
Plug 'karb94/neoscroll.nvim'

" End of plugin fetching
call plug#end()

" Set color scheme
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme onehalfdark
let g:terminal_color_8 = '#6f7a90'

" Install Coc extenstions
let g:coc_global_extensions = [
  \ 'coc-pyright', 
  \ 'coc-clangd', 
  \ 'coc-tsserver', 
  \ '@yaegassy/coc-volar', 
  \ 'coc-svelte',
  \ 'coc-emmet', 
  \ 'coc-prettier', 
  \ 'coc-eslint',
  \ ]

" Custom options for Coc
let g:python_highlight_space_errors = 0
command! -nargs=0 Format :CocCommand format
command! -nargs=0 F :Format
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

" Configure vim-polyglot
let g:vim_svelte_plugin_load_full_syntax = 1
let g:vim_svelte_plugin_use_typescript = 1
let g:vim_svelte_plugin_use_sass = 1

" Configure leap
lua require('leap').add_default_mappings()

" Configure Comment.nvim
lua require('Comment').setup()

" Disable Github Copilot on launch and configure commands
autocmd BufRead * let b:copilot_enabled = v:false
command! -nargs=0 CPE :let b:copilot_enabled = v:true
command! -nargs=0 CPD :let b:copilot_enabled = v:false

" Configure auto-session
lua require("auto-session").setup{
  \ log_level = "error",
  \ }

" Configure nvim-tree
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
nmap gx :!open <c-r><c-a>
nnoremap <silent><leader>n :NvimTreeToggle<CR>
lua require("nvim-tree").setup({
  \ update_focused_file = {
  \   enable = true,
  \ },
  \ view = {
  \   signcolumn = "auto",
  \   adaptive_size = true,
  \   mappings = {
  \     list = {
  \       { key = "+", action = "cd" },
  \     },      
  \   },
  \ },
  \ })

" Configure Telescope
lua require('telescope').setup{}
lua require('telescope').load_extension('fzf')
nnoremap <leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>f <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>o <cmd>Telescope oldfiles<cr>
nnoremap <leader>t <cmd>Telescope tags<cr>
nnoremap <leader>: <cmd>Telescope commands<cr>
nnoremap <leader>d <cmd>Telescope git_status<cr>
nnoremap <leader><leader> <cmd>Telescope resume<cr>

" Configure ToggleTerm
lua require("toggleterm").setup{
  \ size = 20,
  \ hide_numbers = true,
  \ direction = 'horizontal',
  \ open_mapping = [[<C-j>]],
  \ shade_terminals = true,
  \ shading_factor = 2,
  \ shell = 'fish'
  \ }

" Configure code_runner
lua require('code_runner').setup{
  \ mode = "toggleterm",
  \ filetype = {
    \ python = "python",
    \ javascript = "node",
    \ typescript = "node",
    \ c = "gcc -o main % && ./main",
    \ },
  \ }
nnoremap <leader><CR> :w<CR>:RunCode<CR>

" Configure markdown-preview
let g:mkdp_auto_close = 0

" Configure gitsigns.nvim
lua require('gitsigns').setup()
lua require("scrollbar.handlers.gitsigns").setup()

" Configure conflict-marker
let g:conflict_marker_highlight_group = ''
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'
highlight ConflictMarkerBegin guibg=#2f7366
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guibg=#2f628e
highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81

" Configure nvim-scrollbar
lua require("scrollbar").setup({
  \   marks = {
  \       Search = { color = "#ff9e64" },
  \       Error = { color = "#db4b4b" },
  \       Warn = { color = "#e0af68" },
  \       Info = { color = "#0db9d7" },
  \       Hint = { color = "#1abc9c" },
  \       Misc = { color = "#9d7cd8" },
  \       GitAdd = { color = "#9ece6a" },
  \       GitChange = { color = "#e0af68" },
  \       GitDelete = { color = "#914c54" },
  \   }
  \ })

" Configure neoscroll
lua require('neoscroll').setup({ easing_function = 'sine' })



" COC DEFAULT CONFIG - required for autocompletion etc. to work properly
" Copied from the readme: github.com/neoclide/coc.nvim

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
