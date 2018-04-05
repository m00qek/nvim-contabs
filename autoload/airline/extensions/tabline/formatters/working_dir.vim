function! airline#extensions#tabline#formatters#working_dir#format(bufnr, buffers)
  for l:tab_number in range(tabpagenr('$'))
    let l:current_tab = l:tab_number + 1
    let l:buffers = tabpagebuflist(l:current_tab)

    if index(l:buffers, a:bufnr) >= 0
        return fnamemodify(getcwd(1, l:current_tab), ':t')
    endif
  endfor
endfunction
