function! contabs#location#path(location)
  return expand(a:location.path)
endfunction

function! contabs#location#relative(location, path)
  return contabs#path#relative(contabs#location#path(a:location), a:path)
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
  let l:glob = join(map(range(a:location.depth), { _ -> '*' }), '/')
  let l:base_directory = contabs#location#path(a:location)

  if a:location.git_only
    return contabs#path#join(l:base_directory, l:glob, '.git')
  endif

  return contabs#path#join(l:base_directory, l:glob)
endfunction

function! contabs#location#entrypoint(location, subdir)
  for l:entrypoint in get(a:location, 'entrypoint', [])
    let l:entry = expand(contabs#path#join(a:subdir, l:entrypoint))

    if filereadable(l:entry)
      return l:entry
    endif
  endfor

  return a:subdir
endfunction

function! contabs#location#default(subdir)
  return { 'path': a:subdir, 'depth': 0, 'git_only': 0 }
endfunction

function! contabs#location#find_by(subdir, locations)
  for l:location in a:locations
    let l:search_pattern = contabs#location#search_pattern(l:location)
    let l:search_pattern = substitute(l:search_pattern, '/\.git$', '', '')
    let l:search_pattern = glob2regpat(l:search_pattern)

    if match(contabs#path#to_directory(a:subdir), l:search_pattern) == 0
      return l:location
    endif
  endfor

  return contabs#location#default(a:subdir)
endfunction
