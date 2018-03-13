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
syntax on
set nowrap
set autoread
au CursorHold * checktime "auto read on file change

let g:mustache_abbreviations = 1

let mapleader = ","
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.o,*.so,*.swp,*.zip,*/node_modules/*,*/bower_components/*

set iskeyword=@,48-57,_,192-255

" insert mode maps
:inoremap jk <Esc>
:inoremap zz byebug
:inoremap qq # TODO - @johnromani90 - 
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
" edit and source vimrc
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>
:nnoremap <leader>d YP

" surround quotes
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
" go to front and last part of line
nnoremap H ^
nnoremap L $


vnoremap H ^
vnoremap L $

" ctrl b to then <number> <cr> for buffer sitch
:nnoremap <C-b> :buffers<CR>:buffer<Space>
" go back to previous buffer
:nnoremap <C-h> <C-^>

:nnoremap { :vertical resize +5<CR>
:nnoremap } :vertical resize -5<CR>

" Ruby auto group/ abrev and cmds
augroup filetype_rb
  autocmd!
  autocmd FileType ruby :iabbrev <buffer> def def<enter>end jkkA
augroup END

"copy file name
nnoremap <leader>cs :let @*=expand("%")<CR>
" copy file name and full path
" :nmap <leader>cl :let @*=expand("%:p")<CR>

" NerdTree
:nnoremap <C-n> :NERDTreeToggle<CR>
:nnoremap <C-f> :NERDTreeFind<CR>
