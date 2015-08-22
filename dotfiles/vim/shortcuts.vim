"-------------------------------------------------------------------------------
"  Remap leader to <space>
"-------------------------------------------------------------------------------
let mapleader = " "

"-------------------------------------------------------------------------------
"  Double spaces remove highlight
"-------------------------------------------------------------------------------
map <silent> <leader><space> :noh<cr>

"-------------------------------------------------------------------------------
"  Disable F1 to not call help
"-------------------------------------------------------------------------------
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

"-------------------------------------------------------------------------------
"  Editing a file
"-------------------------------------------------------------------------------

" Treat long lines as break lines
map j gj
map k gk

" Move current line to the bottom.
nnoremap <silent> <M-j> :m .+1<cr>==
inoremap <silent> <M-j> <Esc>:m .+1<cr>==gi
vnoremap <silent> <M-j> :m '>+1<cr>gv=gv
" Mac mapping
nnoremap <silent> ∆ :m .+1<cr>==
inoremap <silent> ∆ <Esc>:m .+1<cr>==gi
vnoremap <silent> ∆ :m '>+1<cr>gv=gv

" Move current line to the top.
nnoremap <silent> <M-k> :m .-2<cr>==
inoremap <silent> <M-k> <Esc>:m .-2<cr>==gi
vnoremap <silent> <M-k> :m '<-2<cr>gv=gv
" Mac mapping
nnoremap <silent> ˚ :m .-2<cr>==
inoremap <silent> ˚ <Esc>:m .-2<cr>==gi
vnoremap <silent> ˚ :m '<-2<cr>gv=gv

" Save files with sudo
cmap w!! w !sudo tee % >/dev/null

" Quit all windows
map Q :qall<cr>

" Toggle paste
noremap <F2> :set invpaste paste?<cr>
set pastetoggle=<F2>

"-------------------------------------------------------------------------------
"  Buffer Mappings
"-------------------------------------------------------------------------------

" Creating a new buffer
map <leader>bn :vnew<cr>| " Open a new buffer in a new vertical window
map <leader>bN :new<cr>|  " Open a new buffer in a new horizontal window

" Deleting the buffer
map <leader>bd :bd<cr>|  " Delete the buffer
map <leader>bD :bd!<cr>| " Forces to delete the buffer

" Moving around the buffers
map <leader>bh :bp<cr>|   "Move to the previous buffer
map <leader>bl :bn<cr>|   " Move to the next buffer
map <leader>bs <c-^><cr>| " Switch between buffers

"-------------------------------------------------------------------------------
"  Windows Mappings
"-------------------------------------------------------------------------------

" Opening and closing a window
map <leader>wc <c-w>c|    " close the window
map <leader>wn :vnew<cr>| " new horizontally window
map <leader>wN :new<cr>|  " new vertically window

" splitting current window
map <leader>ws <c-w><c-s><cr>| " split curent window horizontally
map <leader>wv <c-w><c-v><cr>| " split current window vertically

" change cursor around windows
map [w <c-w>W|             " go to the previous window
map ]w <c-w><c-w>|         " go to the next window
map <leader>wj <c-w>j|     " change to bottom window
map <leader>wk <c-w>k|     " change to top window
map <leader>wh <c-w>h|     " change to left window
map <leader>wl <c-w>l|     " change to right window
map <leader>wp <c-w><c-p>| " go to the last accessed window
map <leader>wo <c-w>o|     " window only
map <leader>wr <c-w>r|     " window rotate
map <leader>wx <c-w>x|     " window eXchange

" move windows around the screen
map <leader>wmj <c-w>J| " move to bottom window
map <leader>wmk <c-w>K| " move to top window
map <leader>wmh <c-w>H| " move to left window
map <leader>wml <c-w>L| " move to right window
map <leader>wmt <c-w>T| " move current window to a tab

" resize windows
map <leader>wW <C-w>\||  " Expand the width of the Window
map <leader>w= <C-w>=|   " Make all windows equally high and wide
map <leader>w- <C-w>10-| " Decrease current window height
map <leader>w+ <C-w>10+| " Increase current window height
map <leader>w< <C-w>10<| " Decrease current window width
map <leader>w> <C-w>10>| " Increase current window width

"-------------------------------------------------------------------------------
"  Tabs Mappings
"-------------------------------------------------------------------------------

" Opening and closing a tab
map <leader>tc :tabclose<cr>| " close current tab
map <leader>tn :tabnew<cr>|   " create a new empty tab
map <leader>to :tabonly<cr>|  " close all others tab but this

" Moving betwen tabs
map <leader>th :tabp<cr>| " go to the previous tab
map <leader>tl :tabn<cr>| " go to the next tab
map <M-h> :tabp<cr>| " go to the previous tab. Map to Alt+h
map <M-l> :tabn<cr>| " go to the next tab. Map to Alt+l
map ˙ :tabp<cr>| " go to the previous tab. Map to Alt+h
map ¬ :tabn<cr>| " go to the next tab. Map to Alt+l

" Moving the tabs
map <leader>tmh :tabmove -1<cr>| " move tab to the left
map <leader>tml :tabmove +1<cr>| " move tab to the right

"-------------------------------------------------------------------------------
"  Vim Mappings
"-------------------------------------------------------------------------------
nmap <leader>vo :tabe $MYVIMRC<cr>| " Open the vim file in a new tab
nmap <leader>vs :so $MYVIMRC<cr>|   " Source/Load the vim file
