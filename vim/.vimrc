
"" aliases
noremap <A-k> gt
noremap <A-j> gT

"map! : ^
colorscheme grb256
set mouse=a
set nu
set mousehide
set showcmd
set showmatch
"set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ 0x%B\ %l,%c%V\ %P
set autoread
set t_Co=256
set confirm

"" highlight
syntax on

"" visible tabs
set list
set listchars=tab:→→,trail:·
hi SpecialKey ctermfg=8 guifg=gray

set backspace=indent,eol,start
set noswapfile
set clipboard=unnamed
set title
set history=128
set undolevels=2048
set whichwrap=b,<,>,[,],l,h
set laststatus=2
set visualbell
"set cursorline

set wrap
set linebreak

set hlsearch
set incsearch
set nowrapscan
set ignorecase

"" folding
"set foldenable
"set foldmethod=indent
"set foldcolumn=3
"set foldlevel=1
"set foldopen=all

set encoding=utf-8
set fileformat=unix

"" indents
set shiftwidth=2
set tabstop=2
set expandtab
set ai
set cin
set smartindent

"" keymap
set keymap=russian-jcukenwin
"set keymap=en-us
set iminsert=0

"" remove spaces at the end of lines
autocmd BufWritePre *.* :%s/\s\+$//e

execute pathogen#infect()
"syntax enable
filetype plugin indent on

" vim-airline
set noshowmode

let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_linecolumn_prefix = '¶ '
let g:airline_fugitive_prefix = '⎇ '
let g:airline_paste_symbol = 'ρ'

let g:airline_enable_fugitive = 1
let g:airline_enable_bufferline = 1

let g:airline#extensions#tabline#enabled = 1

