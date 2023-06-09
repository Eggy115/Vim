"============================================================================
"File:        closurecompiler.vim
"Description: Javascript syntax checker - using Google Closure Compiler
"Maintainer:  Motohiro Takayama <mootoh at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"============================================================================
"
" To enable this plugin, edit the .vimrc like this:
"
"   let g:syntastic_javascript_checker = "closurecompiler"
"
" and set the path to the Google Closure Compiler:
"
"   let g:syntastic_javascript_closure_compiler_path = '/path/to/google-closure-compiler.jar'
"
" It takes additional options for Google Closure Compiler with the variable
" g:syntastic_javascript_closure_compiler_options.
"

if exists("g:loaded_syntastic_javascript_closurecompiler_checker")
    finish
endif
let g:loaded_syntastic_javascript_closurecompiler_checker=1

if !exists("g:syntastic_javascript_closure_compiler_options")
    let g:syntastic_javascript_closure_compiler_options = ""
endif

function! SyntaxCheckers_javascript_closurecompiler_IsAvailable()
    return exists("g:syntastic_javascript_closure_compiler_path")
endfunction

function! SyntaxCheckers_javascript_closurecompiler_GetLocList()
    if exists("g:syntastic_javascript_closure_compiler_file_list")
        let file_list = join(readfile(g:syntastic_javascript_closure_compiler_file_list), ' ')
    else
        let file_list = shellescape(expand('%'))
    endif

    let makeprg = syntastic#makeprg#build({
                \ 'exe': 'java -jar ' . g:syntastic_javascript_closure_compiler_path,
                \ 'args': g:syntastic_javascript_closure_compiler_options . ' --js' ,
                \ 'fname': file_list,
                \ 'subchecker': 'closurecompiler' })

    let errorformat =
        \ '%-GOK,'.
        \ '%E%f:%l: ERROR - %m,'.
        \ '%Z%p^,'.
        \ '%W%f:%l: WARNING - %m,'.
        \ '%Z%p^'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'javascript',
    \ 'name': 'closurecompiler'})

