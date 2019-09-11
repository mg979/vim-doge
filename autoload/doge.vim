let s:save_cpo = &cpoptions
set cpoptions&vim

""
" @public
" Generates documentation based on available patterns in b:doge_patterns.
function! doge#generate() abort
  let l:success = 0
  if exists('b:doge_patterns')
    for l:pattern in get(b:, 'doge_patterns')
      if doge#generate#pattern(l:pattern) == v:false
        continue
      else
        let l:success = v:true
      endif
      if l:success == v:true
        call doge#activate()
      endif
      return l:success
    endfor
  endif
endfunction

""
" @public
" Activate doge buffer mappings, if option is set.
function! doge#activate() abort
  " Ensure hlsearch is disabled
  if &hlsearch == v:true
    set nohlsearch
    let s:doge_noh = 1
  endif

  if g:doge_comment_interactive == v:false || g:doge_buffer_mappings == v:false
    return
  endif

  let [l:f, l:b] = [
        \ g:doge_mapping_comment_jump_forward,
        \ g:doge_mapping_comment_jump_backward,
        \ ]
  for l:mode in ['n', 'i', 's']
    execute(printf('%smap <nowait> <silent> <buffer> %s <Plug>(doge-comment-jump-forward)', l:mode, l:f))
    execute(printf('%smap <nowait> <silent> <buffer> %s <Plug>(doge-comment-jump-backward)', l:mode, l:b))
  endfor
endfunction

""
" @public
" Deactivate doge mappings and unlet buffer variable.
" Restore hlsearch setting and search register.
function! doge#deactivate() abort
  unlet b:doge_interactive

  " Reenable hlsearch if it was previously disabled
  if exists('s:doge_noh')
    if &hlsearch == v:false
      set hlsearch
    endif
    unlet s:doge_noh
  endif

  if g:doge_comment_interactive == v:false || g:doge_buffer_mappings == v:false
    return
  endif

  let [l:f, l:b] = [
        \ g:doge_mapping_comment_jump_forward,
        \ g:doge_mapping_comment_jump_backward,
        \ ]
  for l:mode in ['n', 'i', 's']
    execute(printf('%sunmap <buffer> %s', l:mode, l:f))
    execute(printf('%sunmap <buffer> %s', l:mode, l:b))
  endfor
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
