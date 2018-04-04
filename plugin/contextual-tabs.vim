function! s:keyToAction(key)
  let actions = { 'ctrl-t': 'tabedit', 'ctrl-e': 'edit', 'ctrl-v': 'vsp', 'ctrl-x': 'sp' }
  return get(actions, a:key, 'edit')
endfunction

function! s:go_to_proj(key, dirname)
  execute s:keyToAction(a:key) . ' ' .  a:dirname
  execute "tcd" a:dirname
endfunction

function! s:go_to_buffer(key, basedir, line)
  let filepath = substitute(a:line, '\[[0-9]*\] ', a:basedir.'/', '')
  execute s:keyToAction(a:key) . ' ' .  filepath
endfunction

function! s:project_buffers()
  let basedir = getcwd()

  let StartsWith = { candidate, text -> stridx(text, candidate) == 0 }
  let RemoveParent = { path -> substitute(path, basedir.'/', '', '') }
  let FormatNumber = { number -> (number >= 10 ? '' : ' ').'['.number.']' }

  let buffers = []
  for i in range(1, bufnr('$'))
    let type = getbufvar(i, '&filetype')
    if ! buflisted(i) || type == 'qf' || type == ''
      continue
    endif

    let fullpath = expand('#'. i . ':p')
    if ! StartsWith(basedir, fullpath)
      continue
    endif

    call add(buffers, FormatNumber(i).' '.RemoveParent(fullpath))

  endfor

  return fzf#run(fzf#wrap('project_buffers', {
   \ 'source':  buffers,
   \ 'sink*':   { args-> s:go_to_buffer(args[0], basedir, args[1]) },
   \ 'options': '+m --header-lines=0 --expect=ctrl-e,ctrl-t,ctrl-x,ctrl-v --tiebreak=index'
   \ }, 0))
endfunction

function! s:subdirectories(directory, depth, git_only)
  if a:depth <= 0
    return a:directory
  endif

  let l:glob = join(map(range(a:depth), { _ -> '*/' }), '')
  if a:git_only
    let l:glob = l:glob . '.git'
  endif

  let l:basedir = expand(a:directory) . '/'

  let l:subdirs = {}
  for dir in glob(l:basedir . l:glob, 1, 1)
    let l:formatted_dir = substitute(dir, '/.git$\|/$', '', '')

    let l:key = substitute(l:formatted_dir, l:basedir, '', '')

    let l:subdirs[l:key] = l:formatted_dir
  endfor

  return l:subdirs
endfunction

function! s:select_proj()
  let l:projects = s:subdirectories('~/projects', 2, 1)

  return fzf#run(fzf#wrap('projects',{
   \ 'source':  sort(keys(l:projects)),
   \ 'sink*':   { args -> s:go_to_proj(args[0], l:projects[args[1]]) },
   \ 'options': '+m --header-lines=0 --expect=ctrl-e,ctrl-t --tiebreak=index'}, 0))
endfunction

command! -nargs=1 -complete=dir EP call s:go_to_proj('ctrl-e', <q-args>)
command! -nargs=1 -complete=dir TP call s:go_to_proj('ctrl-t', <q-args>)
command! SelectProject call s:select_proj()
command! ProjectBuffers call s:project_buffers()

nnoremap <silent> <Leader>p :SelectProject<CR>
nnoremap <silent> <Leader>b :ProjectBuffers<CR>
