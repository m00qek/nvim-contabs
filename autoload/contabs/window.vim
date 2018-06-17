function! contabs#window#hotkeys(action_map)
  return join(keys(a:action_map), ',')
endfunction

function! contabs#window#open(name, actions, items, handler)
  return fzf#run(fzf#wrap(a:name,{
   \ 'source':  sort(keys(a:items)),
   \ 'sink*':   { args -> a:handler(args[0], a:items[args[1]]) },
   \ 'options':
   \   '+m --header-lines=0 --expect=' . a:actions . ' --tiebreak=index' },
   \ 0))
endfunction
