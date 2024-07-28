filetype plugin indent on          " filetype detection and settings
silent! runtime macros/matchit.vim " matchit comes with Vim
set nocompatible                   " not strictly necessary but useful in some scenarii
set backspace=indent,eol,start     " let the backspace key work "normally"
set hidden                         " hide unsaved buffers
set incsearch                      " incremental search rules
set laststatus=2                   " not strictly necessary but good for consistency
set ruler                          " shows line number in the status line
set switchbuf=useopen,usetab       " better behavior for the quickfix window and :sb
set tags=./tags;/,tags;/           " search tags files efficiently
set wildmenu                       " better command line completion, shows a list of matches
set noerrorbells                   " no beeps
set showcmd                        " show me what I'm typing
set nohlsearch
set mouse=a
" set backupcopy=yes
set noswapfile
set scrolloff=5                    " the minimum number of lines to keep above and below the cursor

" show line numbers
set number
" set relativenumber

" indentation
set expandtab
set tabstop=2
set shiftwidth=2

" set up the leader key to Space
let mapleader = "\<space>"

" use system clipboard by default
if has("mac")
  set clipboard+=unnamed
else
  set clipboard=unnamedplus
endif

" change path var, affects gf, :find etc.
" ** is added to search recursively
set path=.,$HOME/.vim,**

" exclude node_module from search
set wildignore+=**/node_modules/**

" set suffixesadd to follow js imports with gf
set suffixesadd=.js,.jsx,.ts,.tsx

" ignore case when searching the file
" uppercase symbols make the search case sensitive
set ignorecase
set smartcase

" global substitution by default
set gdefault

" config for netrw filebrowser
let g:netrw_banner=0
let g:netrw_altv=1

" automatically reload buffer if the file has changed
" and the buffer has no changes unsaved
set autoread
augroup checktime
  au CursorHold * checktime
augroup END

" split windows config
set splitright
set splitbelow

" Keep search matches in the middle of the window.
" nnoremap n nzzzv
" nnoremap N Nzzzv

" set %% as an alias for the directory of the current file
cabbr <expr> %% expand('%:p:h')

" visual reselect of just pasted
nnoremap gp `[v`]

" search for default register content
nnoremap g" /\v<<C-r>"><CR>

" map tab to % in normal and visual mode
" TODO this breaks C-i somehow
" nnoremap <tab> %
" vnoremap <tab> %

" tabs shortcuts
nnoremap <m-h> gT
nnoremap <m-l> gt
nnoremap <m-w> :tabc<cr>
nnoremap <m-t> :tabnew<cr>
