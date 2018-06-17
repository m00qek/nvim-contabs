function! s:hotkeys(action_map)
  return join(keys(a:action_map), ',')
endfunction

function! s:handle(action_map, items, handler, selection)
  let [ l:key, l:selected_text ] = a:selection

  let l:command = get(a:action_map, l:key, 'edit')

  call a:handler(l:command, a:items[l:selected_text])
endfunction

function! contabs#window#open(name, action_map, items, handler)
  let l:keys = s:hotkeys(a:action_map)

  return fzf#run(fzf#wrap(a:name,{
   \ 'options': '+m --header-lines=0 --expect=' . l:keys . ' --tiebreak=index'
   \ 'sink*':   funcref('s:handle', [ a:action_map, a:items, a:handler ]),
   \ 'source':  sort(keys(a:items)),
   \ }, 0))
endfunction
