set nocompatible

let mapleader = "\<Space>"

let g:contabs#project#locations = [
\ { 'path': '$CONTABS', 'entrypoint': ['README.md'], 'formatter': { _ -> 'contabs' }},
\ { 'path': '$CONTABS/tools', 'entrypoint': ['init.vim'], 'formatter': { _ -> 'Neovim Configuration' }},
\ { 'path': '$CONTABS/tools/projects', 'depth': 2, 'git_only': v:true, 'entrypoint': ['project.clj']},
\ { 'path': '$CONTABS/tools/projects', 'depth': 1, 'git_only': v:true},
\]

" Change the working directory of current tab
command! -nargs=1 -complete=dir EP call contabs#project#edit(<q-args>)

" Open a new tab setting the working directory
command! -nargs=1 -complete=dir TP call contabs#project#tabedit(<q-args>)

"invoke fzf with the list of projects configured in g:contabs#project#locations
"the enabled hotkeys are { 'ctrl-t': 'tabedit', 'ctrl-e, <cr>': 'edit' }
nnoremap <silent> <Leader>p :call contabs#project#select()<CR>

"invoke fzf with the list of buffers of current tab working directory
"the enabled hotkeys are { 'ctrl-t': 'tabedit', 'ctrl-e, <cr>': 'edit', 'ctrl-v': 'vsp', 'ctrl-x': 'sp' }
nnoremap <silent> <Leader>b :call contabs#buffer#select()<CR>

" Hotkey for default FZF action
nnoremap <silent> <Leader>f :<C-u>Files<CR><C-u>

let g:contabs#integrations#tabline#theme = 'project/path'
set guitablabel=%{contabs#integrations#tabline#label(tabpagenr())}
set tabline=%!contabs#integrations#tabline#create()
