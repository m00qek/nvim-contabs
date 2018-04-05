function! s:keyToAction(key)
  let actions = { 'ctrl-t': 'tabedit', 'ctrl-e': 'edit', 'ctrl-v': 'vsp', 'ctrl-x': 'sp' }
  return get(actions, a:key, 'edit')
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

let g:contabs#projects#locations = [
  \ { 'path': '~/projects', 'depth': 2, 'git_only': 1 },
  \ { 'path': '~/.config/nvim', 'depth': 0, 'git_only': 0 },
  \ { 'path': '$GOPATH/src/github.com/nubank', 'depth': 1, 'git_only': 1 }
  \]

command! -nargs=1 -complete=dir EP call contabs#project#edit(<q-args>)
command! -nargs=1 -complete=dir TP call contabs#project#tabedit(<q-args>)

command! SelectProject call contabs#project#select()
command! ProjectBuffers call s:project_buffers()

nnoremap <silent> <Leader>p :SelectProject<CR>
nnoremap <silent> <Leader>b :ProjectBuffers<CR>
