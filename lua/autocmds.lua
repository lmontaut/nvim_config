-- Rebinds per buffertype
vim.cmd[[
  autocmd FileType fugitive nnoremap <buffer> q :bd<CR>
  autocmd FileType qf nnoremap <buffer> q :bd<CR>
  autocmd FileType git nnoremap <buffer> q :bd<CR>
  autocmd FileType vim nnoremap <buffer> q :bd<CR>
  autocmd FileType vimcmake nnoremap <buffer> q :bd<CR>
  autocmd FileType lspinfo nnoremap <buffer> q :bd<CR>
  autocmd FileType help nnoremap <buffer> q :bd<CR>
  autocmd FileType dap-float nnoremap <buffer> q :bd<CR>
  autocmd FileType netrw nnoremap <buffer> q :Rexplore<CR>
  autocmd Filetype netrw nnoremap <buffer> <C-l> <C-W>l
  autocmd Filetype netrw nnoremap <buffer> <C-h> <C-W>h
  autocmd Filetype netrw nnoremap <buffer> <C-j> <C-W>j
  autocmd Filetype netrw nnoremap <buffer> <C-k> <C-W>k
]]

-- Stop from continuing comments when going to line with "o"
vim.cmd[[
  autocmd BufEnter * set formatoptions-=cro
  " Not the best to impose the compiler -> one project may have multiple filetypes
  " However, if none of the compilers change 'makeprg', the user can set it as they want
  autocmd BufEnter *.hpp compiler clang
  autocmd BufEnter *.cpp compiler clang
  autocmd BufEnter *.rs compiler rust
  autocmd BufEnter *.py compiler python
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
  augroup InitNetrw
    autocmd!
    autocmd VimEnter * :silent! Explore
  augroup END
]]

-- No smart indent in python please
vim.cmd [[
  au! BufEnter *.py setl nosmartindent
]]
