" Vim compiler file
" Compiler:         Clang Compiler

if exists("current_compiler") | finish | endif
let current_compiler = "clang"

if exists(":CompilerSet") != 2
	command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" Original errorformat, keeping if needed for later
set errorformat=
      \%*[^\"]\"%f\"%*\\D%l:%c:\ %m,
      \%*[^\"]\"%f\"%*\\D%l:\ %m,
      \\"%f\"%*\\D%l:%c:\ %m,
      \\"%f\"%*\\D%l:\ %m,
      \%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,
      \%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.),
      \%f:%l:%c:\ %trror:\ %m,
      \%f:%l:%c:\ %tarning:\ %m,
      \%f:\%l:\%m,
      \%f:%l:%c:\ %m,
      \%f:%l:%c:%m,
      \%f:%l:\ %trror:\ %m,
      \%f:%l:\ %tarning:\ %m,
      \%f:%l:\ %m,
      \%f:\\(%*[^\\)]\\):\ %m,
      \\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,
      \%D%*\\a[%*\\d]:\ Entering\ directory\ %*[`']%f',
      \%X%*\\a[%*\\d]:\ Leaving\ directory\ %*[`']%f',
      \%D%*\\a:\ Entering\ directory\ %*[`']%f',
      \%X%*\\a:\ Leaving\ directory\ %*[`']%f',
      \%DMaking\ %*\\a\ in\ %f,

" Reduced error format:
" set errorformat=
" 		\%-G,
" 		\%-G%f:%l:\ %trror:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,
" 		\%-G%f:%l:\ %trror:\ for\ each\ function\ it\ appears\ in.),
" 		\%f:%l:%c:\ %trror:\ %m,
" 		\%f:%l:%c:\ %tarning:\ %m,
" 		\%f:%l:%c:\ %m,
" 		\%f:%l:\ %trror:\ %m,
" 		\%f:%l:\ %tarning:\ %m,
" 		\%-G%.%#

set errorformat+=
		\%EAssertion\ failed:\ %m,%Z
		" \%EAssertion\ failed:\ %.%*file\ %m\ %.%*line\ %m\ %m,%Z
		" \%C\ %#file\ %f,
		" \%C\ %#line\ %l,
		" \%E\ \ left:%m,%C\ right:%m\ %f:%l,%Z
		" \%Eassertion:\ %m,
		" \%E\ \ left:%m,%C\ right:%m,%Z

silent CompilerSet makeprg
silent CompilerSet errorformat
