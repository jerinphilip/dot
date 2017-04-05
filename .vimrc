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


"Pathogen
execute pathogen#infect()


"My tweaks
"
"XML folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

"Latex stuff
set grepprg=grep\ -nH\ $*
let g:tex_flavor = 'latex'

set background=light
colorscheme lucius
