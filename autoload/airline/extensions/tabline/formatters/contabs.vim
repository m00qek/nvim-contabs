function! s:contains(array, item)
  return index(a:array, a:item) >= 0
endfunction

function! airline#extensions#tabline#formatters#contabs#format(bufnr, buffers)
  let l:current_theme = g:contabs#integrations#airline_theme
  let l:all_tabs = range(1, tabpagenr('$'))
  let l:current_buffer = a:bufnr

  for l:current_tab in l:all_tabs
    let l:tab_buffers = tabpagebuflist(l:current_tab)

    if s:contains(l:tab_buffers, l:current_buffer)
      return contabs#integrations#tabline#label(l:current_tab, l:current_theme)
    endif
  endfor
endfunction
