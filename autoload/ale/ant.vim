" Author: Andrew Lee <andrew.lambda@tuta.io>.
" Inspired by ale/gradle.vim by Michael Pardo <michael@michaelpardo.com>
" Description: Functions for working with Ant projects.

" Given a buffer number, find an Ant project root
function! ale#ant#FindProjectRoot(buffer) abort
    let l:build_xml_path = ale#path#FindNearestFile(a:buffer, 'build.xml')

    if !empty(l:build_xml_path)
        return fnamemodify(l:build_xml_path, ':h')
    endif

    return ''
endfunction

" Given a buffer number, find the path to the `ant` executable. Returns an empty
" string if cannot find the executable.
function! ale#ant#FindExecutable(buffer) abort
    if executable('ant')
        return 'ant'
    endif

    return ''
endfunction

" Given a buffer number, get a working directory and command to print the
" classpath of the root project.
"
" Returns an empty string for the command if Ant is not detected.
function! ale#ant#BuildClasspathCommand(buffer) abort
    let l:executable = ale#ant#FindExecutable(a:buffer)

    if !empty(l:executable)
        let l:project_root = ale#ant#FindProjectRoot(a:buffer)

        if !empty(l:project_root)
            return [
            \   l:project_root,
            \   ale#Escape(l:executable) .' classpath -S -q'
            \]
        endif
    endif

    return ['', '']
endfunction
