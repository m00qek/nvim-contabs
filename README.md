Contextual tabs for neovim

---

Neovim has a neat feature: each tab can have a different working directory. This
plugin adds some functions and [fzf](https://github.com/junegunn/fzf) commands
to change the working directory of tabs.

![nvim-contabs in action](sample.gif)

### Installation

nvim-contabs depends on [fzf](https://github.com/junegunn/fzf) and, optionally,
on [vim-airline](https://github.com/vim-airline/vim-airline). If you use
vim-plug:

```viml
Plug 'm00qek/nvim-contabs'
```

### Configuration

add something like the following on your vimrc

```viml
"configure the locations of projects. In this example:
" - add directories satisfying '~/projects/*/*/.git'
" - add only '~/.config/nvim'
" - add directories satisfying '$GOPATH/src/github.com/libgit2/*'
" - add directories satisfying '~/haskell/*/.git' and show 'λ | ' before their paths
" - add directories satisfying '~/clojure/*/.git' and, on project selection, open one of the entrypoint files
let g:contabs#project#locations = [
  \ { 'path': '~/projects', 'depth': 2, 'git_only': 1 },
  \ { 'path': '~/.config/nvim', 'depth': 0, 'git_only': 0 },
  \ { 'path': '$GOPATH/src/github.com/libgit2', 'depth': 1, 'git_only': 0 }
  \ { 'path': '~/haskell', 'depth': 1, 'git_only': 1, 'formatter': { dirpath -> 'λ | ' . dirpath } }
  \ { 'path': '~/clojure', 'depth': 1, 'git_only': 1, 'entrypoint': ['project.clj', 'tasks/build.boot'] }
  \]

"command to change the current tab's workingdir
command! -nargs=1 -complete=dir EP call contabs#project#edit(<q-args>)

"command to open a new tab with some workingdir
command! -nargs=1 -complete=dir TP call contabs#project#tabedit(<q-args>)

"invoke fzf with the list of projects configured in g:contabs#project#locations
"the enabled hotkeys are { 'ctrl-t': 'tabedit', 'ctrl-e, <cr>': 'edit' }
nnoremap <silent> <Leader>p :call contabs#project#select()<CR>

"invoke fzf with the list of buffers of current tab's workingdir
"the enabled hotkeys are { 'ctrl-t': 'tabedit', 'ctrl-e, <cr>': 'edit', 'ctrl-v': 'vsp', 'ctrl-x': 'sp' }
nnoremap <silent> <Leader>b :call contabs#buffer#select()<CR>
```

### vim-airline

When using `contabs` and `vim-airline`, by defautl, your tab titles will be the
basename of it's current working directory. If you want to disable this feature
add to your config:

```viml
let g:contabs#integrations#airline = v:false
```

The titles are provided by `formatters`, which are functions operating over the
tab current directory and location config. You can choose one of the
[predefined](https://github.com/m00qek/nvim-contabs/blob/master/autoload/contabs/integrations/tabline.vim#L12)
formatters using:

```viml
" you can use 'basename', 'path', 'pathshorten', 'project/path' or
" 'project/pathshorten'
let g:contabs#integrations#airline_theme = 'project/path'
```

If you want to write you own `formatter`, use

```viml
let g:contabs#integrations#airline_theme = 'myformatter'
call contabs#integrations#tabline#register('myformatter',
\  { location, cwd ->  location.path . " | " . cwd })
```

where `location` is the related entry in `g:contabs#project#locations` and `cwd`
is the current tab working directory

### Contributing

To test you changes to the code you should use 

```bash
make prepare 
make nvim
``` 
