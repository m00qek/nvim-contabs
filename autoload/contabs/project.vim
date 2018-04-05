function! s:subdirectories(directory, depth, git_only)
  let l:basedir = expand(a:directory) . '/'

  if a:depth <= 0
    return {a:directory: l:basedir}
  endif

  let l:glob = join(map(range(a:depth), { _ -> '*/' }), '')
  if a:git_only
    let l:glob = l:glob . '.git'
  endif

  let l:subdirs = {}
  for l:dir in glob(l:basedir . l:glob, 1, 1)
    let l:formatted_dir = substitute(l:dir, '/.git$\|/$', '', '')

    let l:key = substitute(l:formatted_dir, l:basedir, '', '')

    let l:subdirs[l:key] = l:formatted_dir
  endfor

  return l:subdirs
endfunction

function! s:open(key, directory)
  let l:actions = { 'ctrl-t': 'tabedit', 'ctrl-v': 'vsp', 'ctrl-x': 'sp' }

  execute get(l:actions, a:key, 'edit') . ' ' .  a:directory
  execute "tcd" a:directory
endfunction


function! contabs#project#edit(directory)
  call s:open('ctrl-e', a:directory)
endfunction

function! contabs#project#tabedit(directory)
  call s:open('ctrl-t', a:directory)
endfunction

function! contabs#project#select()
  let l:projects = {}
  for l:proj in g:contabs#projects#locations
    let l:subdirs = s:subdirectories(l:proj.path, l:proj.depth, l:proj.git_only)
    call extend(l:projects, l:subdirs)
  endfor

  return fzf#run(fzf#wrap('projects',{
   \ 'source':  sort(keys(l:projects)),
   \ 'sink*':   { args -> s:open(args[0], l:projects[args[1]]) },
   \ 'options': '+m --header-lines=0 --expect=ctrl-e,ctrl-t --tiebreak=index'},
   \ 0))
endfunction
