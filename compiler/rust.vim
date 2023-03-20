" Vim compiler file
" Compiler:         Rust Compiler

if exists("current_compiler") | finish | endif
let current_compiler = "rust"

if exists(":CompilerSet") != 2
	command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" New errorformat (after nightly 2016/08/10)
set errorformat=
            \%-G,
            \%-Gerror:\ aborting\ %.%#,
            \%-Gerror:\ Could\ not\ compile\ %.%#,
            \%Eerror:\ %m,
            \%Eerror[E%n]:\ %m,
            \%Wwarning:\ %m,
            \%Inote:\ %m,
            \%C\ %#-->\ %f:%l:%c,
            \%E\ \ left:%m,%C\ right:%m\ %f:%l:%c,%Z

" Old errorformat (before nightly 2016/08/10)
set errorformat+=
            \%f:%l:%c:\ %t%*[^:]:\ %m,
            \%f:%l:%c:\ %*\\d:%*\\d\ %t%*[^:]:\ %m,
            \%-G%f:%l\ %s,
            \%-G%*[\ ]^,
            \%-G%*[\ ]^%*[~],
            \%-G%*[\ ]...

silent CompilerSet makeprg
silent CompilerSet errorformat
