" Install vim-plug if not found.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Load (and maybe install) plugins.
call plug#begin('~/.vim/plugged')
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'itchyny/lightline.vim'
call plug#end()

" Setup theme.
syntax on
set t_Co=256
set cursorline
set laststatus=2
set number
colorscheme onehalfdark
let g:lightline = { 'colorscheme': 'onehalfdark' }

" Anti typo (command aliases).
ca W w
ca Q q

" Enable mouse mode. Use xterm >= 277 for mouse mode for large terms.
set mouse=a

" Make arrow keys wrap lines and whitespace properly.
set whichwrap=b,s,<,>,[,]
