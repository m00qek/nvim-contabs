function! s:hotkeys(action_map)
  let [ _, l:actions ] = a:action_map

  return join(keys(l:actions), ',')
endfunction

function! s:handle(items, handler, action_map, selection)
  let [ l:key, l:selected_text ] = a:selection
  let [ l:default_action, l:actions ] = a:action_map

  let l:command = get(l:actions, l:key, l:default_action)

  call a:handler(l:command, a:items[l:selected_text])
endfunction

function! contabs#window#open(name, items, handler, action_map)
  return fzf#run(fzf#wrap(a:name,{
   \ 'source':  sort(keys(a:items)),
   \ 'sink*':   funcref('s:handle', [ a:items, a:handler, a:action_map ]),
   \ 'options': ['+m', '--extended', '--tiebreak=index', '--header-lines=0',
   \             '--ansi', '--tabstop=1', '--prompt', a:name . '> ',
   \             '--expect', s:hotkeys(a:action_map)],
   \ }, 0))
endfunction

