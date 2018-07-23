function! contabs#path#to_directory(path)
  if match(a:path, '/$') > 0
    return a:path
  endif
  return a:path . '/'
endfunction

function! contabs#path#join(base_directory, ...)
  let l:final_path = a:base_directory
  for l:path in a:000
    let l:final_path = contabs#path#to_directory(l:final_path) . l:path
  endfor
  return l:final_path
endfunction

function! contabs#path#relative(base_directory, path)
  if a:base_directory == a:path
    return '.'
  endif
  return substitute(a:path, contabs#path#to_directory(a:base_directory), '', '')
endfunction
