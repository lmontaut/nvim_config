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
  au InsertEnter *.vim,*.lua,*.c,*.cpp,*.h,*.hpp,*.hxx,*.txx,*.py,*.txt,*.tex,*.md,*.rs match ExtraWhitespace /\s\+\%#\@<!$/
  au InsertLeave *.vim,*.lua,*.c,*.cpp,*.h,*.hpp,*.hxx,*.txx,*.py,*.txt,*.tex,*.md,*.rs match ExtraWhitespace /\s\+$/
]]
