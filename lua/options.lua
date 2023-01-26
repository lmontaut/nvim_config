-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- Don't wrap please
vim.o.wrap = false

-- Relative line numbers
vim.o.relativenumber = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Allow vim to access the system clipboard
vim.o.clipboard = "unnamedplus"
