call plug#begin()

Plug 'scrooloose/nerdtree'
Plug 'valloric/youcompleteme'
Plug 'sheerun/vim-polyglot'
Plug 'sainnhe/sonokai'
Plug 'tribela/vim-transparent'

call plug#end() 


" Colorscheme

set termguicolors
let g:sonokai_style = 'atlantis'
let g:sonokai_better_performance = 1

colorscheme sonokai


" disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of
" file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number relativenumber
" Change number highlight color.
highlight LineNr ctermfg=gray

" Show matching words during a search.
set showmatch

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" Make YCM working
set encoding=utf-8

" 4 spaces instead of tabs
set expandtab
set tabstop=4

" Shiftwidth
set shiftwidth=4

" Smartcase
set smartcase

" For dark version.
set background=dark

" Set opacity to transparent
hi! Normal guibg=NONE ctermbg=NONE


" Make mouse working in alacritty
set mouse=a
set ttymouse=sgr
