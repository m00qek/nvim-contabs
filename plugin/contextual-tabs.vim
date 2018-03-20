function! s:edit_project_buffer(line)
  let filepath = substitute(a:line[1], '\[[0-9]*\] ', basedir, '')
  execute 'edit' filepath
endfunction

function! s:project_buffers()
  let basedir = getcwd()
  let current_buf = bufnr('.')

  let StartsWith = { candidate, text -> stridx(text, candidate) == 0 }
  let RemoveParent = { path -> substitute(path, basedir.'/', '', '') }
  let FormatNumber = { number -> (number >= 10 ? '' : ' ').'['.number.']' }

  " colect
  let buffers = range(1, bufnr('$'))
  let buffers = filter(buffers, { _, i -> i != current_buf })
  let buffers = filter(buffers, { _, buf -> buflisted(buf) && getbufvar(buf, '&filetype') != 'qf' })
  let buffers = map(buffers, { _, i -> [i, expand('#'. i . ':p')] })
  let buffers = filter(buffers, { _, buf -> StartsWith(basedir, buf[1]) })

  "format
  let lines = map(buffers, { _, buf -> [ buf[0],  RemoveParent(buf[1]) ] })
  let lines = filter(lines, { _, buf -> buf[1] != '' })
  let lines = map(lines, { _, buf -> FormatNumber(buf[0]).' '.buf[1] })

  return fzf#run(fzf#wrap('project_buffers', {
   \ 'source':  lines,
   \ 'sink*':   { args-> s:edit_buffer(args[0]) },
   \ 'options': '+m --header-lines=0 --tiebreak=index'
   \ }, 0))
endfunction

function! s:go_to_proj(newtab, dirname)
  if a:newtab
    execute "tabedit" a:dirname
  else
    execute "edit" a:dirname
  endif

  execute "tcd" a:dirname
endfunction

function! s:select_proj()
  let projectDir = "/home/fholiveira/projects/"

  let list_projects = "find " . projectDir . " -maxdepth 3 -name '.git' -printf '%P\n' | xargs dirname "

  return fzf#run(fzf#wrap('projects',{
   \ 'source':  list_projects,
   \ 'dir':     projectDir,
   \ 'sink*':   { args -> s:go_to_proj(args[0] =~ 'ctrl-t', projectDir . args[1]) },
   \ 'options': '+m --header-lines=0 --expect=ctrl-e,ctrl-t --tiebreak=index'}, 0))
endfunction

command! -nargs=1 -complete=dir EP call s:go_to_proj(0, <q-args>)
command! -nargs=1 -complete=dir TP call s:go_to_proj(1, <q-args>)
command! SelectProject call s:select_proj()
command! ProjectBuffers call s:project_buffers()

nnoremap <silent> <Leader>p :SelectProject<CR>
nnoremap <silent> <Leader>b :ProjectBuffers<CR>
