vim9script

# Vim support file to switch off loading plugins for file types
#
# Maintainer:	Bram Moolenaar <Bram@vim.org>
# Last Change:	2022 Feb 09

if exists("g:did_load_ftplugin")
  unlet g:did_load_ftplugin
endif

# Remove all autocommands in the filetypeplugin group, if any exist.
if exists("#filetypeplugin")
  silent! au! filetypeplugin *
endif
