"-------------------------------------------------------------------------------
"  Mappings for F1-12
"-------------------------------------------------------------------------------
nmap <F8> :TagbarToggle<CR>

"-------------------------------------------------------------------------------
"  Vim-go
"-------------------------------------------------------------------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"-------------------------------------------------------------------------------
"  NERDTree Settings
"-------------------------------------------------------------------------------
map <F6> :NERDTreeToggle<cr>
nmap <F7> :NERDTreeFind<cr>
let NERDTreeShowHidden = 1 " show hidden files
let NERDTreeQuitOnOpen = 1 " close after opening a file
let NERDTreeIgnore=['\.class$']

"-------------------------------------------------------------------------------
"  vim-airline Settings
"-------------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

"-------------------------------------------------------------------------------
"  Tpope Utilities
"-------------------------------------------------------------------------------
Plugin 'tpope/vim-commentary'

"-------------------------------------------------------------------------------
"  Vimux
"-------------------------------------------------------------------------------
map <Leader>vp :VimuxPromptCommand<cr>|     " Prompt for a command to run
map <Leader>vl :VimuxRunLastCommand<cr>|    " Run last command executed
map <Leader>vi :VimuxInspectRunner<cr>|     " Inspect runner pane
map <Leader>vq :VimuxCloseRunner<cr>|       " Close vim tmux runner opened
map <Leader>vx :VimuxInterruptRunner<cr>|   " Interrupt any command running
map <Leader>vz :call VimuxZoomRunner()<cr>| " Zoom the runner pane