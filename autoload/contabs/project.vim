let s:actions = {
  \ 'ctrl-t': 'tabedit',
  \ 'ctrl-e': 'edit'
  \ }

function! s:get_formatter(location, base_directory)
  if has_key(a:location, 'formatter')
    return a:location.formatter
  endif

  if a:location.depth <= 0
    return { -> a:location.path }
  endif

  return { directory -> substitute(directory, a:base_directory, '', '') }
endfunction

function! s:subdirectories(location)
  let l:base_directory = expand(a:location.path) . '/'
  let l:Format = s:get_formatter(a:location, l:base_directory)

  let l:glob = join(map(range(a:location.depth), { _ -> '*/' }), '')
  if a:location.git_only
    let l:glob = l:glob . '.git'
  endif

  let l:subdirs = {}
  for l:search_result in glob(l:base_directory . l:glob, 1, 1)
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

function! s:open(key, context)
  let [ l:config, l:directory ] = a:context

  let l:entrypoints = get(l:config, 'entrypoint', [])

  let l:welcome_path = l:directory
  for l:entrypoint in l:entrypoints
    if filereadable(l:directory . '/' . l:entrypoint)
      let l:welcome_path = l:directory . '/' . l:entrypoint
      break
    endif
  endfor

  execute get(s:actions, a:key, 'edit') . ' ' .  l:welcome_path
  execute "tcd" l:directory
endfunction


function! contabs#project#edit(directory)
  call s:open('ctrl-e', [{}, a:directory])
endfunction

function! contabs#project#tabedit(directory)
  call s:open('ctrl-t', [{}, a:directory])
endfunction

function! contabs#project#select()
  let l:hotkeys = contabs#window#hotkeys(s:actions)
  return contabs#window#open('projects', l:hotkeys, s:all_projects(),
  \                          funcref('s:open'))
endfunction
