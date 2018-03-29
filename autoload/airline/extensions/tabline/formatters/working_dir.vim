function! airline#extensions#tabline#formatters#working_dir#format(bufnr, buffers)
    for i in range(tabpagenr('$'))
        let currenttab = i + 1
        let tabbuffers = tabpagebuflist(currenttab)

        if index(tabbuffers, a:bufnr) >= 0
            return fnamemodify(getcwd(1, currenttab), ':t')
        endif
    endfor
endfunction
