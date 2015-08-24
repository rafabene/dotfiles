"-------------------------------------------------------------------------------
"  Mappings for F1-12
"-------------------------------------------------------------------------------
nmap <F8> :TagbarToggle<CR>

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
