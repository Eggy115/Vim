" Tests for large files
" This is only executed manually: "make test_largefile".
" This is not run as part of "make test".

func Test_largefile()
  let fname = 'Xlarge.txt'

  call delete(fname)
  exe "e" fname
  " Make sure that a line break is 1 byte (LF).
  set ff=unix
  set undolevels=-1
  " Input 99 'A's. The line becomes 100 bytes including a line break.
  exe "normal 99iA\<Esc>"
  yank
  " Put 39,999,999 times. The file becomes 4,000,000,000 bytes.
  normal 39999999p
  " Moving around in the file randomly.
  normal G
  normal 10%
  normal 90%
  normal 50%
  normal gg
  w
  " Check if the file size is 4,000,000,000 bytes.
  let fsize=getfsize(fname)
  call assert_true(fsize == 4000000000)
  call delete(fname)
endfunc

" vim: shiftwidth=2 sts=2 expandtab
