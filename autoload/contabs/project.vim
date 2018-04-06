let s:actions = {
  \ 'ctrl-t': 'tabedit',
  \ 'ctrl-e': 'edit'
  \ }

function! s:hotkeys()
  return join(keys(s:actions), ',')
endfunction

function! s:subdirectories(directory, depth, git_only)
  let l:base_directory = expand(a:directory) . '/'

  if a:depth <= 0
    return { a:directory: l:base_directory }
  endif

  let l:glob = join(map(range(a:depth), { _ -> '*/' }), '')
  if a:git_only
    let l:glob = l:glob . '.git'
  endif

  let l:subdirs = {}
  for l:search_result in glob(l:base_directory . l:glob, 1, 1)
    let l:raw_directory = substitute(l:search_result, '/.git$\|/$', '', '')

    let l:pretty_entry = substitute(l:raw_directory, l:base_directory, '', '')
    let l:subdirs[l:pretty_entry] = l:raw_directory
  endfor

  return l:subdirs
endfunction

function! s:all_projects()
  let l:projects = {}
  for l:proj in g:contabs#project#locations
    let l:subdirs = s:subdirectories(l:proj.path, l:proj.depth, l:proj.git_only)
    call extend(l:projects, l:subdirs)
  endfor
  return l:projects
endfunction

function! s:open(key, directory)
  execute get(s:actions, a:key, 'edit') . ' ' .  a:directory
  execute "tcd" a:directory
endfunction


function! contabs#project#edit(directory)
  call s:open('ctrl-e', a:directory)
endfunction

function! contabs#project#tabedit(directory)
  call s:open('ctrl-t', a:directory)
endfunction

function! contabs#project#select()
  let l:projects = s:all_projects()

  return fzf#run(fzf#wrap('projects',{
   \ 'source':  sort(keys(l:projects)),
   \ 'sink*':   { args -> s:open(args[0], l:projects[args[1]]) },
   \ 'options': '+m --header-lines=0 --expect=' . s:hotkeys() . ' --tiebreak=index' },
   \ 0))
endfunction
