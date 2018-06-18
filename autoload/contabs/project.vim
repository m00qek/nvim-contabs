function! s:get_formatter(location, base_directory)
  if has_key(a:location, 'formatter')
    return a:location.formatter
  endif

  if a:location.depth <= 0
    return { -> a:location.path }
  endif

  return { directory -> substitute(directory, a:base_directory, '', '') }
endfunction

function! s:get_entrypoint(location, directory)
  for l:entrypoint in get(a:location, 'entrypoint', [])
    if filereadable(a:directory . '/' . l:entrypoint)
      return a:directory . '/' . l:entrypoint
    endif
  endfor

  return a:directory
endfunction

function! s:get_search_pattern(location, base_directory)
  let l:pattern = join(map(range(a:location.depth), { _ -> '*/' }), '')

  if a:location.git_only
    return a:base_directory . l:pattern . '.git'
  endif

  return a:base_directory . l:pattern
endfunction

function! s:location_for_path(directory)
  let l:absulote_directory = expand(a:directory) . '/'

  for l:location in g:contabs#project#locations
    let l:base_directory = expand(l:location.path) . '/'

    let l:search_pattern = s:get_search_pattern(l:location, l:base_directory)
    let l:search_pattern = substitute(l:search_pattern, '/\.git$', '', '')
    let l:search_pattern = glob2regpat(l:search_pattern)

    if match(l:absulote_directory, l:search_pattern) == 0
      return [l:location, l:absulote_directory]
    endif
  endfor
  return [{}, l:absulote_directory]
endfunction

function! s:subdirectories(location)
  let l:base_directory = expand(a:location.path) . '/'
  let l:search_pattern = s:get_search_pattern(a:location, l:base_directory)
  let l:Format = s:get_formatter(a:location, l:base_directory)

  let l:subdirs = {}
  for l:search_result in glob(l:search_pattern, 1, 1)
    let l:raw_directory = substitute(l:search_result, '/.git$\|/$', '', '')
    let l:subdirs[l:Format(l:raw_directory)] = [ a:location, l:raw_directory ]
  endfor

  return l:subdirs
endfunction

function! s:all_projects()
  let l:projects = {}

  for l:location in g:contabs#project#locations
    call extend(l:projects, s:subdirectories(location))
  endfor

  return l:projects
endfunction

function! s:open(command, context)
  let [ l:location, l:directory ] = a:context
  execute a:command . ' ' .  s:get_entrypoint(l:location, l:directory)
  execute "tcd" l:directory
endfunction


function! contabs#project#edit(directory)
  let l:location = s:location_for_path(a:directory)
  call s:open('edit', l:location)
endfunction

function! contabs#project#tabedit(directory)
  let l:location = s:location_for_path(a:directory)
  call s:open('tabedit', l:location)
endfunction

function! contabs#project#select()
  let l:actions = { 'ctrl-t': 'tabedit', 'ctrl-e': 'edit' }

  return contabs#window#open(
  \ 'projects', s:all_projects(), funcref('s:open'), [ 'edit', l:actions ])
endfunction
