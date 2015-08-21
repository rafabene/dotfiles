"-------------------------------------------------------------------------------
"  NERDTree
"-------------------------------------------------------------------------------

" Open NERDTree and put the focus on the next window
function! g:OpenNerdTree()

  " if is a directory, open the NERDTree
  let path = expand("%")
  if path =~ "NERD_tree_1"
    NERDTree
  end

  " NERDtree is open? move to next window, deletes the buffer and goes back
  let path = expand("%")
  if path =~ "NERD_tree_2"
    wincmd p
    bd
    wincmd p
  else
    wincmd p
  end
endfunction

"-------------------------------------------------------------------------------
"  UltiSnips
"-------------------------------------------------------------------------------

" UltiSnips completion function that tries to expand a snippet. If there's no
" snippet for expanding, it checks for completion window and if it's
" shown, selects first element. If there's no completion window it tries to
" jump to next placeholder. If there's no placeholder it just returns TAB key
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction
