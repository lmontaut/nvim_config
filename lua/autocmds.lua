-- Rebinds per buffertype
vim.cmd [[
  autocmd FileType fugitive nnoremap <buffer> q :close<CR>
  autocmd FileType fugitive nnoremap <buffer> + <nop>
  autocmd FileType fugitive setlocal colorcolumn=0
  autocmd FileType qf nnoremap <buffer> q :close<CR>
  autocmd FileType qf setlocal colorcolumn=0
  autocmd FileType git nnoremap <buffer> q :close<CR>
  autocmd FileType git setlocal colorcolumn=0
  " autocmd FileType vim nnoremap <buffer> q :close<CR>
  autocmd FileType vimcmake nnoremap <buffer> q :close<CR>
  autocmd FileType lspinfo nnoremap <buffer> q :close<CR>
  autocmd FileType lspinfo setlocal colorcolumn=0
  autocmd FileType help nnoremap <buffer> q :close<CR>
  autocmd FileType help setlocal colorcolumn=0
  autocmd FileType dap-float nnoremap <buffer> q :close<CR>
  autocmd FileType dap-float setlocal colorcolumn=0
  autocmd FileType netrw nnoremap <buffer> q :Rexplore<CR>
  autocmd FileType NeogitStatus setlocal wrap
]]

-- Stop from continuing comments when going to line with "o"
vim.cmd [[
  autocmd BufEnter * set formatoptions-=cro
]]

vim.cmd [[
  autocmd Filetype vim setlocal expandtab tabstop=2 shiftwidth=2
  autocmd Filetype c setlocal expandtab tabstop=2 shiftwidth=2
  autocmd Filetype cpp setlocal expandtab tabstop=2 shiftwidth=2
  autocmd Filetype h setlocal expandtab tabstop=2 shiftwidth=2
  autocmd Filetype hpp setlocal expandtab tabstop=2 shiftwidth=2
  autocmd Filetype hxx setlocal expandtab tabstop=2 shiftwidth=2
  autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
]]

vim.cmd [[
  let g:loaded_netrwPlugin = 1
]]

-- No smart indent in python please
vim.cmd [[
  au! BufEnter *.py setl nosmartindent
]]

-- Errorformats
vim.cmd [[
  augroup quickfix_group
    autocmd!
    autocmd filetype qf setlocal errorformat+=%f\|%l\ col\ %c\|%m
  augroup END

  " Not the best to impose the compiler -> one project may have multiple filetypes
  " However, if none of the compilers change 'makeprg', the user can set it as they want
  " autocmd VimEnter * compiler clang
  autocmd VimEnter * compiler clang " Default compiler
  autocmd BufEnter *.hpp compiler clang
  autocmd BufEnter *.cpp compiler clang
  autocmd BufEnter *.rs compiler rust
  autocmd BufEnter *.py compiler python
]]

-- Saving/Loading folds
vim.cmd [[
  autocmd BufWinEnter *.* silent! loadview
  autocmd BufWinLeave *.* silent! mkview
]]
