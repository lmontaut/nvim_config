-- [[ Setting options ]]
-- See `:help vim.o`
vim.o.encoding = "utf-8"

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- The cursor always has room above and below
vim.o.scrolloff = 8

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- We're big boys and big girls now
vim.o.showmode = false
vim.o.cursorline = true

-- Decrease update time
vim.o.updatetime = 500
vim.o.timeoutlen = 500
vim.o.smartindent = true
vim.wo.signcolumn = 'yes'
vim.o.showbreak = ">>"

-- Modify jumplist behavior -> much better
vim.cmd [[
  autocmd InsertLeave * normal! m'
  autocmd TextYankPost * normal! m'
  autocmd BufWrite * normal! m'
]]
vim.o.jumpoptions=""

-- Where to split -> I want the cursor to remain in the top left window
-- Then ctrl w + o to close other windows
vim.o.splitbelow = false
vim.o.splitright = false

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- Don't wrap please
vim.o.wrap = false

-- Relative line numbers
vim.o.relativenumber = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- Allow vim to access the system clipboard
vim.o.clipboard = "unnamedplus"

-- Maximum height of the completion window
vim.o.pumheight = 15

vim.o.conceallevel = 2

-- Indent default
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
