"-------------------------------------------------------------------------------
"  Auto complete features
"-------------------------------------------------------------------------------
let g:acp_behaviorUserDefinedMeets = 'acp#meetsForKeyword'
let g:acp_behaviorUserDefinedFunction = 'syntaxcomplete#Complete'

"-------------------------------------------------------------------------------
"  Auto close tag
"-------------------------------------------------------------------------------
let g:closetag_filenames = "*.html,*.xhtml,*.phtml"

"-------------------------------------------------------------------------------
"  Control P
"-------------------------------------------------------------------------------
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command =
    \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
else
  " Fall back to using git ls-files if Ag is not available
  let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif


"-------------------------------------------------------------------------------
"  Mappings for F1-12
"-------------------------------------------------------------------------------
nmap <F8> :TagbarToggle<CR>

"-------------------------------------------------------------------------------
"  Emmet Settings
"-------------------------------------------------------------------------------
let g:user_emmet_leader_key='<c-e>'
let g:user_emmet_expandabbr_key='<c-e>'

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
"  javascript-libraries-syntax.vim Settingss
"-------------------------------------------------------------------------------
let g:used_javascript_libs = 'jquery, angularjs, angularui, angularuirouter'

"-------------------------------------------------------------------------------
"  Vimux
"-------------------------------------------------------------------------------
map <Leader>vp :VimuxPromptCommand<cr>|     " Prompt for a command to run
map <Leader>vl :VimuxRunLastCommand<cr>|    " Run last command executed
map <Leader>vi :VimuxInspectRunner<cr>|     " Inspect runner pane
map <Leader>vq :VimuxCloseRunner<cr>|       " Close vim tmux runner opened
map <Leader>vx :VimuxInterruptRunner<cr>|   " Interrupt any command running
map <Leader>vz :call VimuxZoomRunner()<cr>| " Zoom the runner pane
