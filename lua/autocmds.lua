vim.cmd[[
  autocmd FileType fugitive nnoremap <buffer> q :bd<CR>
  autocmd FileType qf nnoremap <buffer> q :bd<CR>
  autocmd FileType git nnoremap <buffer> q :bd<CR>
  autocmd FileType vim nnoremap <buffer> q :bd<CR>
  autocmd FileType vimcmake nnoremap <buffer> q :bd<CR>
  autocmd FileType lspinfo nnoremap <buffer> q :bd<CR>
  autocmd FileType help nnoremap <buffer> q :bd<CR>
  autocmd FileType dap-float nnoremap <buffer> q :bd<CR>
]]

-- Stop from continuing comments when going to line with "o"
vim.cmd[[
  autocmd BufEnter * set formatoptions-=cro
]]
