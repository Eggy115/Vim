function! s:EncodeChar(char) abort
    let l:result = ''

    for l:index in range(strlen(a:char))
        let l:result .= printf('%%%02x', char2nr(a:char[l:index]))
    endfor

    return l:result
endfunction

function! ale#uri#Encode(value) abort
    return substitute(
    \   a:value,
    \   '\([^a-zA-Z0-9\\/$\-_.!*''(),]\)',
    \   '\=s:EncodeChar(submatch(1))',
    \   'g'
    \)
endfunction

function! ale#uri#Decode(value) abort
    return substitute(
    \   a:value,
    \   '%\(\x\x\)',
    \   '\=printf("%c", str2nr(submatch(1), 16))',
    \   'g'
    \)
endfunction

let s:uri_handlers = {
\   'jdt': {
\       'OpenURILink': function('ale#uri#jdt#OpenJDTLink'),
\   }
\}

function! ale#uri#GetURIHandler(uri) abort
    for l:scheme in keys(s:uri_handlers)
        if a:uri =~# '^'.l:scheme.'://'
            return s:uri_handlers[scheme]
        endif
    endfor

    return v:null
endfunction
