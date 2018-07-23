function! s:project_for_path(directory)
  let l:locations = contabs#project#locations
  return [contabs#location#find_by(a:directory, l:locations), l:directory]
endfunction

function! s:projects(location)
  let l:search_pattern = contabs#location#search_pattern(a:location)
  let l:Format = contabs#location#formatter(a:location)

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
    call extend(l:projects, s:projects(location))
  endfor

  return l:projects
endfunction

function! s:open(cmd, context)
  let [ l:location, l:directory ] = a:context
  execute a:cmd . ' ' . contabs#location#entrypoint(l:location, l:directory)
  execute "tcd" l:directory
endfunction


function! contabs#project#edit(directory)
  let l:project = s:project_for_path(expand(a:directory) . '/')
  call s:open('edit', l:project)
endfunction

function! contabs#project#tabedit(directory)
  let l:project = s:project_for_path(expand(a:directory) . '/')
  call s:open('tabedit', l:project)
endfunction

function! contabs#project#select()
  let l:actions = { 'ctrl-t': 'tabedit', 'ctrl-e': 'edit' }

  return contabs#window#open(
  \ 'projects', s:all_projects(), funcref('s:open'), [ 'edit', l:actions ])
endfunction
