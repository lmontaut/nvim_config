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

-- vim.cmd[[
--   highlight ExtraWhitespace ctermbg=red guibg=red
--   au InsertEnter *.vim,*.lua,*.c,*.cpp,*.h,*.hpp,*.hxx,*.txx,*.py,*.txt,*.tex,*.md,*.rs match ExtraWhitespace /\s\+\%#\@<!$/
--   au InsertLeave *.vim,*.lua,*.c,*.cpp,*.h,*.hpp,*.hxx,*.txx,*.py,*.txt,*.tex,*.md,*.rs match ExtraWhitespace /\s\+$/
-- ]]

-- vim undo dir
vim.cmd [[
  if has("persistent_undo")
     let target_path = expand('~/.undodir')

      " create the directory and any parent directories
      " if the location does not exist.
      if !isdirectory(target_path)
          call mkdir(target_path, "p", 0700)
      endif

      let &undodir=target_path
      set undofile
  endif
]]
