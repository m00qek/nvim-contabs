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

function! contabs#integrations#tabline#register(name, Formatter)
  let s:formatters[a:name] = a:Formatter
endfunction

function! contabs#integrations#tabline#formatter(name)
  let l:DefaultFormatter = get(s:formatters, 'basename')
  return get(s:formatters, a:name, l:DefaultFormatter)
endfunction

function! contabs#integrations#tabline#label(tabpagenr, formatter_name)
  let l:cwd = getcwd(1, a:tabpagenr)
  let l:location = contabs#location#find_by(l:cwd, g:contabs#project#locations)

  let l:Formatter = contabs#integrations#tabline#formatter(a:formatter_name)
  return l:Formatter(l:location, l:cwd)
endfunction
