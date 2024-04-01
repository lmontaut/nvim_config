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
vim.o.showbreak = "  ↪ "
vim.o.linebreak = true -- so that wrapping does not occur in middle of word
-- vim.o.breakat = " ^I!@*-+;:,./?" -- default
vim.o.breakat = "=(!@;,? "
-- Check when files are changed on disk
vim.cmd [[
  set autoread
  " autocmd CursorHold * checktime
]]
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  pattern = { "*.c", ".cpp", "*.h", "*.hpp", "*.cc", "*.hh", "*.c++", "*.txx",
    "*.h++", "*.cxx", "*.hxx", "*.go", "*.rs", "*.py", "*.lua", "*.sh", "*.zsh", "*.bash",
    "*.fish", "*.js", "*.ts", "*.html", "*.css", "*.yaml", "*.yml", "*.json", "*.toml", "*.xml",
    "*.rb", "*.r", "*.cs", ".txt", ".cmake" },
  callback = function()
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    if filetype ~= "vim" and filetype ~= "oil" then
      vim.cmd [[checktime]]
    end
  end,
})
vim.cmd [[
 " cino = how vim should indent
  set cino+=(0
]]

-- Modify jumplist behavior -> much better
vim.cmd [[
  autocmd InsertLeave * normal! m'
  autocmd TextYankPost * normal! m'
  autocmd BufWrite * normal! m'
]]
vim.o.jumpoptions = ""

-- Where to split -> I want the cursor to remain in the top left window
-- Then ctrl w + o to close other windows
vim.o.splitbelow = false
vim.o.splitright = false

-- Set colorscheme (actually it's in plugin_config.lua)
vim.o.termguicolors = true
-- vim.o.colorcolumn = "0"
vim.keymap.set("n", "<leader>vc", ":set colorcolumn=100",
  { noremap = true, silent = false, desc = "Set colorcolumn" })

-- Do wrap please
vim.o.wrap = true

-- Relative line numbers
vim.o.relativenumber = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

-- Allow vim to access the system clipboard
vim.o.clipboard = "unnamedplus"

-- Maximum height of the completion window
vim.o.pumheight = 15

-- vim.o.conceallevel = 1

-- Indent default
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.opt.foldmethod = "manual"
