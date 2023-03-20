" Vim compiler file
" Compiler:         Cargo Compiler
" Maintainer:       Damien Radtke <damienradtke@gmail.com>
" Latest Revision:  2014 Sep 24
" For bugs, patches and license go to https://github.com/rust-lang/rust.vim

if exists('current_compiler')
    finish
endif
runtime compiler/rust.vim
let current_compiler = "cargo"

" vint: -ProhibitAbbreviationOption
let s:save_cpo = &cpo
set cpo&vim
" vint: +ProhibitAbbreviationOption

if exists(':CompilerSet') != 2
    command -nargs=* CompilerSet setlocal <args>
endif

if exists('g:cargo_makeprg_params')
    execute 'CompilerSet makeprg=cargo\ '.escape(g:cargo_makeprg_params, ' \|"').'\ $*'
else
    CompilerSet makeprg=cargo\ $*
endif

augroup RustCargoQuickFixHooks
    autocmd!
    autocmd QuickFixCmdPre make call cargo#quickfix#CmdPre()
    autocmd QuickFixCmdPost make call cargo#quickfix#CmdPost()
augroup END

" Ignore general cargo progress messages
set errorformat=
            \%-G%\\s%#Downloading%.%#,
            \%-G%\\s%#Checking%.%#,
            \%-G%\\s%#Compiling%.%#,
            \%-G%\\s%#Finished%.%#,
            \%-G%\\s%#error:\ Could\ not\ compile\ %.%#,
            \%-G%\\s%#To\ learn\ more\\,%.%#,
            \%-G%\\s%#For\ more\ information\ about\ this\ error\\,%.%#,
            \%-Gnote:\ Run\ with\ \`RUST_BACKTRACE=%.%#,
            \%.%#panicked\ at\ \\'%m\\'\\,\ %f:%l:%c

silent CompilerSet makeprg
silent CompilerSet errorformat
