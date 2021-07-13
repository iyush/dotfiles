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
"Plug 'scrooloose/syntastic'                             " for syntax checking
"Plug 'dense-analysis/ale'                               " async syntax checking
Plug 'scrooloose/nerdtree'                               " nerd-tree
Plug 'tomasr/molokai'                                    " color scheme
Plug 'neoclide/coc.nvim', {'branch': 'release'}          " conquer of completion code

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'posva/vim-vue', {'for': 'vue'}                     " vue mode
call plug#end()

" Fuzzy finder
set path+=**
set wildmenu
set wildmode=list:longest,full

" set underscore as word break
set iskeyword-=_

" mouse mode
set mouse=a
" colorscheme molokai
" let g:molokai_original = 1

let mapleader=","
let maplocalleader=","

" Omni completion
filetype plugin on
set omnifunc=syntaxComplete#Complete

set hidden


" Set incremental search to be on
set incsearch

" Ignore case when searching
set ignorecase


" Font
set guifont=Source\ Code\ Pro\ 12

" GVIM
set guioptions-=m                   " hide menubar
set guioptions-=T                   " hide topmenu

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" clipboard
set clipboard+=unnamedplus

syntax enable

" Beep and whistles
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

set title

set number              " show line numbers
set lazyredraw

au BufNewFile,BufRead *.py
                        \ set tabstop=4     |
                        \ set softtabstop=4 |
                        \ set shiftwidth=4  |
                        \ set textwidth=79  |
                        \ set autoindent    |
                        \ set fileformat=unix

au BufNewFile,BufRead *.js,*.html,*.css,*.tsx,*.ts,*.jsx
                        \ set tabstop=2     |
                        \ set shiftwidth=2  |
                        \ set textwidth=79  |
                        \ set autoindent    

set expandtab

filetype indent on      " load filetype-specific indent files


"Remaps
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>n :nohlsearch<CR>
nnoremap <leader>p :Files<CR>
nnoremap <leader>B :Buffers<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <expr> <leader>b g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : "\:NERDTreeFind<CR>"


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

" Vue and ALE you need to install vim-vue and eslint 
" (sudo npm i -g eslint eslint-plugin-vue)
" let g:ale_linter_aliases = {'vue': ['vue', 'javascript']}
" let g:ale_linters = {'vue': ['eslint', 'vls']}
let g:tex_flavor = "latex"


" COC for react and typescript
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-json', 'coc-jedi' ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
        let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
        let g:coc_global_extensions += ['coc-eslint']
endif
