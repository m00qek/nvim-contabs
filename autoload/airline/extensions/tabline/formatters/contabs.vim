function! s:contains(array, item)
  return index(a:array, a:item) >= 0
endfunction

function! s:relative_to_project(cwd, Formatter)
  let l:location = contabs#location#find_by(a:cwd, g:contabs#project#locations)
  let l:relative_path = contabs#location#relative(l:location, a:cwd)

  if l:relative_path == '.'
    let l:Formatter = contabs#location#formatter(l:location)
    return l:Formatter(a:cwd)
  else
    return a:Formatter(l:relative_path)
  endif
endfunction

function! s:title(tabnumber)
  let l:theme = g:contabs#integrations#airline_theme
  let l:cwd = getcwd(1, a:tabnumber)

  if l:theme == 'path'
    return l:cwd
  elseif l:theme == 'pathshorten'
    return pathshorten(l:cwd)
  elseif l:theme == 'project/path'
    return s:relative_to_project(l:cwd, { x -> x })
  elseif l:theme == 'project/pathshorten'
    return s:relative_to_project(l:cwd, { dir -> pathshorten(dir) })
  endif

  return fnamemodify(l:cwd, ':t')
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

