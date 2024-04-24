runtime core.vim

lua << EOF
  require("init")
EOF

silent! colorscheme tundra

" bubble lines / visual selections up and down
" depends on `tpope/vim-unimpaired`
nmap <m-k> [e==
nmap <m-j> ]e==
vmap <m-k> [egv=gv
vmap <m-j> ]egv=gv

" makes it easy to run a macro over multiple lines
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
