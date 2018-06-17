function! s:contains(array, item)
  return index(a:array, a:item) >= 0
endfunction

function! s:dirname(tabnumber)
  return fnamemodify(getcwd(1, a:tabnumber), ':t')
endfunction

function! airline#extensions#tabline#formatters#working_dir#format(bufnr, buffers)
  let l:all_tabs = range(1, tabpagenr('$'))
  let l:current_buffer = a:bufnr

  for l:current_tab in l:all_tabs
    let l:tab_buffers = tabpagebuflist(l:current_tab)

    if s:contains(l:tab_buffers, l:current_buffer)
      return s:dirname(l:current_tab)
    endif
  endfor
endfunction
