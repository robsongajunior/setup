""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" => GENERAL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
set encoding=utf8
set confirm
set autoread "Set to auto read when a file is changed from the outside
set nobackup
set nowritebackup
#set shell=/bin/bash

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab "Use spaces instead of tabs
set smarttab "Be smart when using tabs


"1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set nowrap "Disable wrap lines
set autoindent "Auto indent
set smartindent


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => USER INTERFACE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on

set nu "Show number lines
set ruler "Always show current position
set hlsearch "Highlight search results 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VUNDLE PLUGINS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 'editorconfig/editorconfig-vim'
	Plugin 'mattn/emmet-vim'
    Plugin 'wuelnerdotexe/vim-astro'
    Plugin 'vim-autoformat/vim-autoformat'
    Plugin 'cakebaker/scss-syntax.vim'
    " Plugin 'posva/vim-vue'
call vundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => https://github.com/wuelnerdotexe/vim-astro - Astro JS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:astro_typescript = 'enable'
let g:astro_stylus = 'enable'
