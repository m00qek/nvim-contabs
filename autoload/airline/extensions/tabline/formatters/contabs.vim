function! s:contains(array, item)
  return index(a:array, a:item) >= 0
endfunction

function! s:title(current_tab)
  let l:cwd = getcwd(1, a:current_tab)
  let l:current_theme = g:contabs#integrations#airline_theme
  let l:location = contabs#location#find_by(l:cwd, g:contabs#project#locations)

  let l:Formatter = contabs#integrations#tabline#formatter(l:current_theme)
  return l:Formatter(l:location, l:cwd)
endfunction

function! airline#extensions#tabline#formatters#contabs#format(bufnr, buffers)
  let l:all_tabs = range(1, tabpagenr('$'))
  let l:current_buffer = a:bufnr

  for l:current_tab in l:all_tabs
    let l:tab_buffers = tabpagebuflist(l:current_tab)

    if s:contains(l:tab_buffers, l:current_buffer)
      return s:title(l:current_tab)
    endif
  endfor
endfunction
