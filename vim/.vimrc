" Download vim plug if not available

set nocompatible
if !filereadable(expand('~/.vim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ~/.vim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.vim/autoload/plug.vim
endif

" start vim plug
call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'                                     " For Latex Files
Plug 'tpope/vim-surround'                                " For parenthesis manipulations
Plug 'scrooloose/syntastic'                              " for syntax checking
Plug 'scrooloose/nerdtree'                               " nerd-tree
Plug 'ajh17/spacegray.vim'                               " color scheme
Plug 'vim-scripts/L9'                                    " for fuzzy finder
" Plug 'valloric/youcompleteme'                          " completion auto
Plug 'neoclide/coc.nvim', {'branch': 'release'}          " conquer of completion code
call plug#end()

" Fuzzy finder
set path+=**
set wildmenu

let mapleader=","
let maplocalleader=","

" Omni completion
filetype plugin on
set omnifunc=syntaxComplete#Complete

" Font
set guifont=Operator\ Mono\ 12

" GVIM
set guioptions-=m                   " hide menubar
set guioptions-=T                   " hide topmenu

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" clipboard
set clipboard+=unnamedplus
nnoremap y "+y
vnoremap y "+y
nnoremap p "+p

syntax enable

" Beep and whistles
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set title

set tabstop=4			" number of visual spaces per TAB
set softtabstop=4		" number of spaces in tab when editing
set shiftwidth=0
set number              " show line numbers
set expandtab
set lazyredraw

filetype indent on      " load filetype-specific indent files
nnoremap <leader><space> :nohlsearch<CR>


" vimtex specific for minted

let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
