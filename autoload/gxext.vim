function! gxext#normal() abort
  call s:execute_handlers(s:get_handlers(), 'normal')
endfunction


function! gxext#visual() abort
  call s:execute_handlers(s:get_handlers(), 'visual')
endfunction


function! s:get_handlers() abort
  return get(g:gxext#custom_handlers, &filetype, [])
        \ + get(g:gxext#handlers, &filetype, [])
        \ + get(g:gxext#custom_handlers, 'global', [])
        \ + get(g:gxext#handlers, 'global', [])
endfunction


function! s:execute_handlers(handlers, mode) abort
  if a:mode ==# 'normal'
    let l:selection = expand('<cfile>')
  else
    let [l:linenr_start, l:colnr_start] = getpos("'<")[1:2]
    let [l:linenr_end, l:colnr_end] = getpos("'>")[1:2]
    let l:selection = getline(l:linenr_start)
    if l:linenr_start == l:linenr_end
      let l:selection = l:selection[l:colnr_start - 1:l:colnr_end - 1]
    endif
  endif

  for l:handler in a:handlers
    if g:gxext#debug
      echomsg 'Trying with ' . l:handler
    endif
    try
      if gxext#{l:handler}#open(l:selection, a:mode)
        if g:gxext#debug
          echomsg 'Open with ' . l:handler
        endif
        return
      endif
      continue
    catch /E117/
      echoerr 'Unavaliable to find ' . 'gxext#' . l:handler . '#open()'
    endtry
  endfor
endfunction


" Utility functions

" Returns the pos of the first match from pattern that is within column.
"
" string: String to search
" pattern: Regular expression
" column: The column number from where to get the closest match
"
" returns: [start, end]
" Start and end of the match, or [-1, -1] if there isn't a match.
function! gxext#match_around(string, pattern, column)
  let l:end = 0
  while l:end >= 0 && l:end <= a:column
    let [l:match, l:start, l:end] = matchstrpos(a:string, a:pattern, l:end)

    let l:end = l:end - 1
    if a:column >= l:start && a:column <= l:end
      return [l:start, l:end]
    endif
  endwhile
  return [-1, -1]
endfunction


" Same as 'gxext#match_around', but it returns the matched string
function! gxext#matchstr_around(string, pattern, column)
  let [l:start, l:end] = gxext#match_around(a:string, a:pattern, a:column)
  if l:start <= -1 || l:end <= -1
    return ''
  endif
  return a:string[l:start:l:end]
endfunction

" Wrapper around netrw#BrowseX to make it easy to test
function! gxext#browse(url)
  if g:gxext#dryrun
    echomsg 'Opening ' . a:url
  else
    call netrw#BrowseX(a:url, 0)
  endif
endfunction
