function! s:relative_to(location, cwd, Formatter)
  let l:relative_path = contabs#location#relative(a:location, a:cwd)

  if l:relative_path == '.'
    let l:Formatter = contabs#location#formatter(a:location)
    return l:Formatter(a:cwd)
  endif

  return a:Formatter(l:relative_path)
endfunction

function! s:wincount(tabnr)
  let l:windows_count = tabpagewinnr(a:tabnr, '$')
  if l:windows_count > 1
    return l:windows_count
  endif
  return ''
endfunction

function! s:modified(tabnr)
  let l:tab_buffers = tabpagebuflist(a:tabnr)
  for l:current_buffer in l:tab_buffers
    if getbufvar(l:current_buffer, "&modified")
      return '+'
    endif
  endfor
  return ''
endfunction

function! s:label(tabnr, is_current)
  let l:style = a:is_current ? '%#TabLineSel#' : '%#TabLine#'
  let l:label = '%{contabs#integrations#tabline#label('.a:tabnr.')}'
  let l:number = '%'.a:tabnr.'T'

  return l:style . l:number . ' ' . l:label . ' '
endfunction

let s:formatters = {
\  'path'                : { _, cwd -> cwd },
\  'basename'            : { _, cwd -> fnamemodify(cwd, ':t') },
\  'pathshorten'         : { _, cwd -> pathshorten(cwd) },
\  'project/path'        : { location, cwd -> s:relative_to(location, cwd, { dir -> dir }) },
\  'project/pathshorten' : { location, cwd -> s:relative_to(location, cwd, { dir -> pathshorten(dir)}) },
\  'location/formatter'  : { location, cwd -> contabs#location#formatter(location)(cwd) },
\}


function! contabs#integrations#tabline#register(theme, Formatter)
  let s:formatters[a:theme] = a:Formatter
endfunction

function! contabs#integrations#tabline#formatter(theme)
  let l:DefaultFormatter = get(s:formatters, 'basename')
  return get(s:formatters, a:theme, l:DefaultFormatter)
endfunction

function! contabs#integrations#tabline#raw_label(tab_number)
  let l:cwd = getcwd(1, a:tab_number)

  let l:location = contabs#location#find_by(l:cwd, g:contabs#project#locations)
  let l:theme = g:contabs#integrations#tabline#theme

  let l:Formatter = contabs#integrations#tabline#formatter(l:theme)
  return l:Formatter(l:location, l:cwd)
endfunction

function! contabs#integrations#tabline#label(tabnr)
  let l:raw_label = contabs#integrations#tabline#raw_label(a:tabnr)
  return trim(s:wincount(a:tabnr) . s:modified(a:tabnr) . ' ' . l:raw_label)
endfunction

function! contabs#integrations#tabline#create()
  let l:all_tabs = range(1, tabpagenr('$'))
  let l:selected_tab = tabpagenr()

  let l:labels = map(l:all_tabs, { _, tab -> s:label(tab, l:selected_tab == tab) })
  let l:close_button = len(l:all_tabs) > 1 ? '%=%#TabLine#%999XX' : ''

  return join(l:labels) . '%#TabLineFill#%T' . l:close_button
endfunction
