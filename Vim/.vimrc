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
set number
" Change number highlight color.
highlight LineNr ctermfg=lightgray

" Show matching words during a search.
set showmatch

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest


" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" PLUGINS
"


call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

call plug#end()

" :PlugInstall


" Make mouse working in alacritty
set mouse=a
set ttymouse=sgr
