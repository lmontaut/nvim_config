-- Rebinds per buffertype
vim.cmd[[
  autocmd FileType fugitive nnoremap <buffer> q :close<CR>
  autocmd FileType fugitive nnoremap <buffer> + <nop>
  autocmd FileType qf nnoremap <buffer> q :close<CR>
  autocmd FileType git nnoremap <buffer> q :close<CR>
  " autocmd FileType vim nnoremap <buffer> q :close<CR>
  autocmd FileType vimcmake nnoremap <buffer> q :close<CR>
  autocmd FileType lspinfo nnoremap <buffer> q :close<CR>
  autocmd FileType help nnoremap <buffer> q :close<CR>
  autocmd FileType dap-float nnoremap <buffer> q :close<CR>
  autocmd FileType netrw nnoremap <buffer> q :Rexplore<CR>
]]

-- Stop from continuing comments when going to line with "o"
vim.cmd[[
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

-- vim.cmd [[
  -- augroup InitNetrw
  --     autocmd!
  --     autocmd VimEnter * if argc() == 0 | Explore! | endif
  -- augroup END
  -- let g:dirvish_relative_paths = 1
-- ]]

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
