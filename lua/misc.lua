-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.cmd[[
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
  au FileType vim match ExtraWhitespace /\s\+$/
  au FileType lua match ExtraWhitespace /\s\+$/
  au FileType c match ExtraWhitespace /\s\+$/
  au FileType cpp match ExtraWhitespace /\s\+$/
  au FileType h match ExtraWhitespace /\s\+$/
  au FileType hpp match ExtraWhitespace /\s\+$/
  au FileType hxx match ExtraWhitespace /\s\+$/
  au FileType python match ExtraWhitespace /\s\+$/
  au FileType cmake match ExtraWhitespace /\s\+$/
]]
-- au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
-- au InsertLeave * match ExtraWhitespace /\s\+$/
