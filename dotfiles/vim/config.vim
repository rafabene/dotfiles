"-------------------------------------------------------------------------------
" Auto Complete settings
"-------------------------------------------------------------------------------
set completefunc=syntaxcomplete#Complete

"-------------------------------------------------------------------------------
" Backup Settings
"-------------------------------------------------------------------------------
set nobackup
set nowritebackup
set noswapfile

"-------------------------------------------------------------------------------
"  Buffer and Edit Settings
"-------------------------------------------------------------------------------
set autoread " Automatically read a file that has changed on disk
set backspace=indent,eol,start " backspace working like other apps
set hidden " Allow unsaved buffers to be put in background
set clipboard=unnamed " copy default to clipboard
set completeopt-=preview
" set cursorline
set cpoptions+=$ " put $ at the end of the changed word
let loaded_matchparen = 1 " disable the match for parentheses


"-------------------------------------------------------------------------------
"  Enconding Settings
"-------------------------------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8

"-------------------------------------------------------------------------------
"  History and Undo Settings
"-------------------------------------------------------------------------------
set history=1000
set undolevels=1000

"-------------------------------------------------------------------------------
"  Ident and Tab Settings
"-------------------------------------------------------------------------------
set autoindent " Copy ident from current line when starting a new line
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

"-------------------------------------------------------------------------------
"  List Settings
"-------------------------------------------------------------------------------
set list
set listchars=tab:»\ ,trail:·

"-------------------------------------------------------------------------------
"  Mouse settings
"-------------------------------------------------------------------------------
set mousehide " hide the cursor while typing

"-------------------------------------------------------------------------------
"  Search Settings
"-------------------------------------------------------------------------------
set hlsearch " highlight all matches
set ignorecase " case of letters are ignore
set incsearch " while typing the pattern, show where it matches
set smartcase " override the ignorecase when search pattern has upper case
set scrolloff=5 " number of screen lines to keep above and below the cursor

"-------------------------------------------------------------------------------
"  Split Settings
"-------------------------------------------------------------------------------
set splitbelow
set splitright

"-------------------------------------------------------------------------------
"  Sound Settings
"-------------------------------------------------------------------------------
set noerrorbells
set visualbell
set vb t_vb= " this disable the sound and flash from noerrorbells and visualbell

"-------------------------------------------------------------------------------
"  Wildmenu Settings
"-------------------------------------------------------------------------------
set wildmode=list:longest,list:full
set wildmenu
set wildignore+=/tmp/*,*.swp

"-------------------------------------------------------------------------------
"  Window Settings
"-------------------------------------------------------------------------------
set title " Add the window title with the name of the file that is editing
set guioptions-=T " disable toolbar
set guioptions-=r " disable right-hand scrollbar
set guioptions-=L " disable left-hand scrollbar
set guifont=Source\ Code\ Pro\ for\ Powerline:h14 "make sure to escape the spaces in the name properly
set lazyredraw " don't update the display while executing macros
set number " show the current line number
set relativenumber " show the line number relative to the line with the cursor
set laststatus=2 " Always show the status line

"-------------------------------------------------------------------------------
"  Wrap Settings
"-------------------------------------------------------------------------------
set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=80
