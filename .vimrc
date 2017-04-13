if has('vim_starting')
  set nocompatible               " Be iMproved
endif

source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

"*****************************************************************************
"" Vim-Plug core
"*****************************************************************************

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

let g:vim_bootstrap_langs = "html,javascript"
let g:vim_bootstrap_editor = "nvim"				" nvim or vim

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif


"*****************************************************************************
"" Plug install packages
"*****************************************************************************

" Required:
call plug#begin(expand('~/.config/nvim/plugged'))

Plug 'ctrlpvim/ctrlp.vim'        " Fuzzy file, buffer, mru, tag, etc finder
Plug 'tpope/vim-fugitive'        " A Git wrapper so awesome, it should be illegal
Plug 'mattn/emmet-vim'           " Expanding abbreviations
Plug 'scrooloose/syntastic'      " Syntax checking hacks for vim
Plug 'neomake/neomake'           " Asynchronous linting and make framework for Neovim/Vim
Plug 'airblade/vim-gitgutter'    " Git diff in the gutter (sign column) and stages/undoes hunks
Plug 'vim-airline/vim-airline'   " lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline-themes'

" Required:
call plug#end()


"*****************************************************************************
"" Usability
"*****************************************************************************

" Highlight the current cursor line
set cursorline

" Syntax highlighting for odd extensions
syntax on

" Open up new split panes on right
set splitright

" Line numbers
set number

" Fonts
set guifont=Bitstream\ Vera\ Sans\ Mono:h14

" Use system clipboard
set clipboard=unnamed

" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" Indentation
set expandtab
set tabstop=2
set shiftwidth=2

"*****************************************************************************
"" Theme
"*****************************************************************************

syntax enable
set background=light
colorscheme ayu


"*****************************************************************************
"" File Types
"*****************************************************************************

" Enables file detection, plugins, and indentation
filetype plugin indent on

au BufNewFile,BufRead *.soy set filetype=html
au BufNewFile,BufRead *.kit set filetype=html
au BufNewFile,BufRead *.less set filetype=css

" Do not create swap or tilde files
set noswapfile
set nobackup
set nowritebackup

" Disable creating undo files
set noundofile

"Show hidden characters, spaces, tabs, eol etc...
set list
set listchars=eol:$,tab:>-,space:·,trail:~,extends:>,precedes:<
hi SpecialKey ctermfg=7 " set them to light gray

set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
set fileformats=unix


"*****************************************************************************
"" Custom Key Bindings
"*****************************************************************************

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind <Leader> w to switching windows
nnoremap <Leader>w <C-w>

" create a custom find command to use grep and open a cwindow
command -nargs=+ -complete=file -bar Find silent! grep! <args>|cwindow|redraw!
" bind <C-F> to search
nnoremap <C-F> :Find<SPACE>


"*****************************************************************************
"" Uncategorized
"*****************************************************************************

set path=.,/usr/include,,**

let $PYTHONPATH="/usr/lib/python3.3/site-packages"
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Quickly open/reload vim
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Remape esc in the terminal to exit
if has("nvim")
  :tnoremap <Esc> <C-\><C-n>
endif


"*****************************************************************************
"" Linting
"*****************************************************************************

let s:eslint_path = system('PATH=$(npm bin):$PATH && which eslint')
let g:neomake_javascript_eslint_exe = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
let g:neomake_verbose=3
let g:neomake_open_list = 2

autocmd! BufWritePost * Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
" Always make neomake lint column present even if there are no errors
augroup mine
    au BufWinEnter * sign define mysign
    au BufWinEnter * exe "sign place 1337 line=1 name=mysign buffer=" . bufnr('%')
augroup END
let g:neomake_warning_sign = {
  \ 'text': '>>',
  \ }
let g:neomake_error_sign = {
  \ 'text': '>>',
  \ }


"*****************************************************************************
"" CtrlP
"*****************************************************************************

" Always open files in a new tab
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }


"*****************************************************************************
"" Silver Searcher
"*****************************************************************************

" Enables faster searching in vim
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif


"*****************************************************************************
"" Git Fugitive
"*****************************************************************************

map gd :Gvdiff<CR>
map gs :Gstatus<CR>


"*****************************************************************************
"" Git Gutter
"*****************************************************************************

let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=7
highlight GitGutterAdd ctermbg=green
highlight GitGutterChange ctermbg=yellow
highlight GitGutterChangeDelete ctermbg=yellow
highlight GitGutterDelete ctermbg=red

"*****************************************************************************
"" Airline Status Bar
"*****************************************************************************

let g:Powerline_symbols = 'fancy'
let g:airline_theme = 'powerlineish'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif
