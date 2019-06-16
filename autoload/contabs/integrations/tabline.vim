function! s:relative_to(location, cwd, Formatter)
  let l:relative_path = contabs#location#relative(a:location, a:cwd)

  if l:relative_path == '.'
    let l:Formatter = contabs#location#formatter(a:location)
    return l:Formatter(a:cwd)
  endif

  return a:Formatter(l:relative_path)
endfunction

let s:formatters = {
\  'path'                : { _, cwd -> cwd },
\  'basename'            : { _, cwd -> fnamemodify(cwd, ':t') },
\  'pathshorten'         : { _, cwd -> pathshorten(cwd) },
\  'project/path'        : { location, cwd -> s:relative_to(location, cwd, { dir -> dir }) },
\  'project/pathshorten' : { location, cwd -> s:relative_to(location, cwd, { dir -> pathshorten(cwd)}) },
\}

function! contabs#integrations#tabline#register(theme, Formatter)
  let s:formatters[a:theme] = a:Formatter
endfunction

function! contabs#integrations#tabline#formatter(theme)
  let l:DefaultFormatter = get(s:formatters, 'basename')
  return get(s:formatters, a:theme, l:DefaultFormatter)
endfunction

function! contabs#integrations#tabline#raw_label(tabpagenr)
  let l:cwd = getcwd(1, a:tabpagenr)

  let l:location = contabs#location#find_by(l:cwd, g:contabs#project#locations)
  let l:theme = g:contabs#integrations#tabline#theme

  let l:Formatter = contabs#integrations#tabline#formatter(l:theme)
  return l:Formatter(l:location, l:cwd)
endfunction
