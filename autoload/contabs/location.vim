function! contabs#location#path(location)
  return expand(a:location.path) . '/'
endfunction

function! contabs#location#relative(location, path)
  return substitute(a:path, contabs#location#path(a:location), '', '')
endfunction

function! contabs#location#formatter(location)
  if has_key(a:location, 'formatter')
    return a:location.formatter
  endif

  if a:location.depth <= 0
    return { -> a:location.path }
  endif

  return funcref('contabs#location#relative', [ a:location ])
endfunction

function! contabs#location#search_pattern(location)
  let l:pattern = join(map(range(a:location.depth), { _ -> '*/' }), '')
  let l:directory = contabs#location#path(a:location)

  if a:location.git_only
    return l:directory . l:pattern . '.git'
  endif

  return l:directory . l:pattern
endfunction

function! contabs#location#entrypoint(location, subdir)
  for l:entrypoint in get(a:location, 'entrypoint', [])
    let l:entry = expand(a:subdir . '/' . l:entrypoint)

    if filereadable(l:entry)
      return l:entry
    endif
  endfor

  return a:subdir
endfunction

function! contabs#location#find_by(subdir, locations)
  for l:location in a:locations
    let l:search_pattern = contabs#location#search_pattern(l:location)
    let l:search_pattern = substitute(l:search_pattern, '/\.git$', '', '')
    let l:search_pattern = glob2regpat(l:search_pattern)

    if match(a:subdir, l:search_pattern) == 0
      return l:location
    endif
  endfor

  return {}
endfunction
