set number
set numberwidth=5

set softtabstop=4
set tabstop=4
set shiftwidth=4
set wrap

set showcmd
set wildmenu
set wildmode=list:full

set hlsearch
set incsearch

set expandtab "Convert tab to spaces, for haskell.
set foldmethod=syntax
set colorcolumn=72

set viminfo+=n~/.vim/f/viminfo

filetype plugin indent on

syntax on
colorscheme molokai
set t_Co=256

nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>


"Syntastic Configurations
let g:syntastic_cpp_checkers = ['g++']
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '-Werror -Wuninitialized -std=c++14 -D EVIL_DEBUG'


"Temporary
"let g:syntastic_python_python_exec='/usr/bin/python2'
set shell=bash\ --login


"Automation


"My tweaks

