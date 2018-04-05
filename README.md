Contextual tabs for neovim

---

this plugin adds some functions and [fzf](https://github.com/junegunn/fzf) commands to change the working
directory of current tab (using the `tcd` command from neovim).

### Installation

nvim-contabs depends on [fzf](https://github.com/junegunn/fzf) and, optionally, on [vim-airline](https://github.com/vim-airline/vim-airline). If you use vim-plug:

```
Plug 'm00qek/nvim-contabs'
```

### Configuration

add something like the following on your vimrc

```
let g:contabs#project#locations = [
  \ { 'path': '~/projects', 'depth': 2, 'git_only': 1 },
  \ { 'path': '~/.config/nvim', 'depth': 0, 'git_only': 0 },
  \ { 'path': '$GOPATH/src/github.com/libgit2', 'depth': 1, 'git_only': 1 }
  \]

command! -nargs=1 -complete=dir EP call contabs#project#edit(<q-args>)
command! -nargs=1 -complete=dir TP call contabs#project#tabedit(<q-args>)

nnoremap <silent> <Leader>p :call contabs#project#select()<CR>
nnoremap <silent> <Leader>b :call contabs#buffer#select()<CR>
```

### vim-airline

by default this plugin changes titles of tabs to the name of the working
directory. If you want to disable this feature add to your vimrc

```
let g:contabs#integrations#airline = 0
```
