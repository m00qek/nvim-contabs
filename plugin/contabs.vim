if ! exists('g:contabs#project#locations')
  let g:contabs#project#locations = []
endif

command! -nargs=1 -complete=dir EP call contabs#project#edit(<q-args>)
command! -nargs=1 -complete=dir TP call contabs#project#tabedit(<q-args>)

nnoremap <silent> <Leader>p :call contabs#project#select()<CR>
nnoremap <silent> <Leader>b :call contabs#buffer#select()<CR>
