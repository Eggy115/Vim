" Tests for using Ctrl-A/Ctrl-X using DBCS.

set encoding=cp932
scriptencoding cp932

func SetUp()
  new
  set nrformats&
endfunc

func TearDown()
  bwipe!
endfunc

func Test_increment_dbcs_1()
  set nrformats+=alpha
  call setline(1, ["�R1"])
  exec "norm! 0\<C-A>"
  call assert_equal(["�R2"], getline(1, '$'))
  call assert_equal([0, 1, 3, 0], getpos('.'))

  call setline(1, ["�`�a�b0xDE�e"])
  exec "norm! 0\<C-X>"
  call assert_equal(["�`�a�b0xDD�e"], getline(1, '$'))
  call assert_equal([0, 1, 10, 0], getpos('.'))
endfunc

" vim: shiftwidth=2 sts=2 expandtab
