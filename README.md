Contextual tabs for neovim

---

Neovim (and [just recently](https://github.com/vim/vim/releases/tag/v8.1.1218)
vim!) has a neat feature: each tab can have a different working directory. This
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

You can use `contabs` in two ways. The first is by calling functions to change
the tab working directory - which is great if you don't want to use FZF. Add to
your config

```viml
" Change the working directory of current tab
command! -nargs=1 -complete=dir EP call contabs#project#edit(<q-args>)

" Open a new tab setting the working directory
command! -nargs=1 -complete=dir TP call contabs#project#tabedit(<q-args>)
```

Now you can run `:EP ~/dev/myproject` or `:TP ~/dev/myproject`.

The other way `contabs` work is by listing you projects in a FZF buffer. To use
that you need to inform where to find your projects by setting
`g:contabs#project#locations` in your config


```viml
let g:contabs#project#locations = [
  \ { 'path': '~/dev/aproject' },
  \ { 'path': '~/dev/anotherproject' },
  \]
```

Each item in the array is a `location`. You can add more options to the map:

|   option   |                    effect                     |  default   |
| ---------- | --------------------------------------------- | ---------- |
| depth      | the level of subdirectories                   | 0          |
| git_only   | list only git repos                           | v:false    |
| entrypoint | file to show when opening project             | []         |
| formatter  | function to format project name on FZF buffer | { x -> x } |

Some examples of `locations`:

```viml
" directories using git satisfying '~/projects/*/*'
echo { 'path': '~/projects', 'depth': 2, 'git_only': v:true }

" point to '~/.config/nvim' and change its display on FZF buffer
echo { 'path': '~/.config/nvim', 'formatter': { _ -> 'Neovim Config' } }

" directories satisfying '$GOPATH/src/github.com/libgit2/*'
echo { 'path': '$GOPATH/src/github.com/libgit2', 'depth': 1 }

" directories using git satisfying '~/haskell/*' and show 'λ | ' before their paths
echo { 'path': '~/haskell', 'depth': 1, 'git_only': v:true, 'formatter': { dirpath -> 'λ | ' . dirpath } }

" directories using git satisfying '~/clojure/*' and, on project selection, open one of the entrypoint files
echo { 'path': '~/clojure', 'depth': 1, 'git_only': v:true, 'entrypoint': ['project.clj', 'tasks/build.boot'] }
```

The following nmaps open the FZF buffer:

```viml
"invoke fzf with the list of projects configured in g:contabs#project#locations
"the enabled hotkeys are { 'ctrl-t': 'tabedit', 'ctrl-e, <cr>': 'edit' }
nnoremap <silent> <Leader>p :call contabs#project#select()<CR>

"invoke fzf with the list of buffers of current tab working directory
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

If you want to write you own `formatter` use

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
make vim
```
