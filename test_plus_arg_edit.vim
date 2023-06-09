" Tests for complicated + argument to :edit command

function Test_edit()
  call writefile(["foo|bar"], "Xfile1", 'D')
  call writefile(["foo/bar"], "Xfile2", 'D')
  edit +1|s/|/PIPE/|w Xfile1| e Xfile2|1 | s/\//SLASH/|w
  call assert_equal(["fooPIPEbar"], readfile("Xfile1"))
  call assert_equal(["fooSLASHbar"], readfile("Xfile2"))
endfunction

func Test_edit_bad()
  " Test loading a utf8 file with bad utf8 sequences.
  call writefile(["[\xff][\xc0][\xe2\x89\xf0][\xc2\xc2]"], "Xbadfile", 'D')
  new

  " Without ++bad=..., the default behavior is like ++bad=?
  e! ++enc=utf8 Xbadfile
  call assert_equal('[?][?][???][??]', getline(1))

  e! ++encoding=utf8 ++bad=_ Xbadfile
  call assert_equal('[_][_][___][__]', getline(1))

  e! ++enc=utf8 ++bad=drop Xbadfile
  call assert_equal('[][][][]', getline(1))

  e! ++enc=utf8 ++bad=keep Xbadfile
  call assert_equal("[\xff][\xc0][\xe2\x89\xf0][\xc2\xc2]", getline(1))

  call assert_fails('e! ++enc=utf8 ++bad=foo Xbadfile', 'E474:')

  bw!
endfunc

" Test for ++bin and ++nobin arguments
func Test_binary_arg()
  new
  edit ++bin Xfile1
  call assert_equal(1, &binary)
  edit ++nobin Xfile2
  call assert_equal(0, &binary)
  call assert_fails('edit ++binabc Xfile3', 'E474:')
  close!
endfunc

" vim: shiftwidth=2 sts=2 expandtab
