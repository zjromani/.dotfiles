set nocompatible " be iMproved
execute pathogen#infect()
set number
colorscheme molokai
filetype plugin indent on
" show existing tab with 2 spaces width
set tabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" On pressing tab, insert 2 spaces
set expandtab
" get rid of vim auto load promt when branch changes
set autoread
au CursorHold * checktime

syntax on
set nowrap
set autoread
au CursorHold * checktime "auto read on file change
set spell
set guifont=Monaco:h13
set guioptions=

let g:mustache_abbreviations = 1
let g:NERDTreeWinPos = "right"

let mapleader = ","
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.o,*.so,*.swp,*.zip,*/node_modules/*,*/bower_components/*
" edit and source vimrc
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>

set nofoldenable
:nnoremap <leader><leader>f :set foldmethod=indent<CR>


set iskeyword=@,48-57,_,192-255
:nnoremap <leader>ef :set hlsearch!<CR>

map <Leader> <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-overwin-f)

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" insert mode maps
:inoremap jk <Esc>
:inoremap zz byebug
:inoremap qq # TODO - @zjromani -
" ctrl d to delete line in insert
" when in insert mode, ctrl d to delete and stay in insert
:inoremap <c-d> <esc>ddi
" upcase a word in insert
:inoremap <c-u> <esc>viwU


:nnoremap  <C-j> :tabp<CR>
:nnoremap  <C-k> :tabn<CR>
" press space when on a word to highlight and go into visual mode
:nnoremap <space> viw
" move a line down or up one line
:nnoremap _ ddkP
:nnoremap - ddp
" copy and insert line under
:nnoremap <leader>d YP

" surround quotes
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
" go to front and last part of line
nnoremap H ^
nnoremap L $

:nnoremap <leader>cv :%s/:\([^ ]*\)\(\s*\)=>/\1:/g


vnoremap H ^
vnoremap L $

" ctrl b to then <number> <cr> to switch buffer
:nnoremap <C-b> :CtrlPBuffer<CR>
" ctrl d delete all buffs
:nnoremap <leader><leader>d :bufdo bd<CR>

:nnoremap { :vertical resize +5<CR>
:nnoremap } :vertical resize -5<CR>

" Ruby auto group/ abrev and cmds
augroup filetype_rb
  autocmd!
  autocmd FileType ruby :iabbrev <buffer> def def<enter>end jkkA
  autocmd BufWritePre * %s/\s\+$//e
augroup END

"copy file name
nnoremap <leader>cs :let @*=expand("%")<CR>

" NerdTree
:nnoremap <C-n> :NERDTreeToggle<CR>
:nnoremap <C-f> :NERDTreeFind<CR>

" Grepper Pluggin
nnoremap <leader>g :Grepper -tool git<cr>
nnoremap <leader>G :Grepper -tool ack<cr>
" nmap gs <plug>(GrepperOperator)

