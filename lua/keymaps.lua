-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- -- INSERT MODE -- --
-- Escape from INSERT mode
vim.keymap.set('i', "jk", "<ESC>", { noremap = true, silent = true, desc = "Escape INSERT mode" })
vim.keymap.set('i', "<S-TAB>", "<C-d>", { noremap = true, silent = true, desc = "Unindent INSERT mode" })

-- -- NORMAL MODE -- --
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +10<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize -10<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -10<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +10<CR>", opts)

-- Better tabbing
-- vim.keymap.set("n", ">" , ">>", opts)
-- vim.keymap.set("n", "<" , "<<", opts)

-- Quicklist navigation
-- Even if the quicklist is not open, you can navigate with :cn and :cp
vim.keymap.set("n", "<leader>qn", ":cn<CR>", { noremap = true, silent = true, desc = "Quicklist next" })
vim.keymap.set("n", "<leader>qp", ":cp<CR>", { noremap = true, silent = true, desc = "Quicklist prev" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { noremap = true, silent = true, desc = "Quicklist open" })
vim.keymap.set("n", "<leader>qO", ":Copen<CR>", { noremap = true, silent = true, desc = "Quicklist open (dispatched)" })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { noremap = true, silent = true, desc = "Quicklist close" })
vim.keymap.set("n", "<leader>qq", ":cc<CR>", { noremap = true, silent = true, desc = "Quicklist show current" })
vim.keymap.set("n", "<leader>qN", ":cfirst<CR>", { noremap = true, silent = true, desc = "Quicklist first" })
vim.keymap.set("n", "<leader>qP", ":clast<CR>", { noremap = true, silent = true, desc = "Quicklist last" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { noremap = true, silent = true, desc = "Quicklist open" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { noremap = true, silent = true, desc = "Quicklist open" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { noremap = true, silent = true, desc = "Quicklist open" })

-- Make
-- vim.keymap.set("n", "<leader>mm", function() return ":make<Space>" end, { noremap = true, silent = false, desc = "make", expr = true })
vim.keymap.set("n", "<leader>mm", ":Make<Space>", { noremap = true, silent = false, desc = "Make" })
vim.keymap.set("n", "<leader>mm", ":make<Space>", { noremap = true, silent = false, desc = "make" })
vim.keymap.set("n", "<leader>m<CR>", ":make<CR>", { noremap = true, silent = true, desc = "make<CR>" })
vim.keymap.set("n", "<leader>mM", ":Make<Space>", { noremap = true, silent = false, desc = "Make" })
vim.keymap.set("n", "<leader>m!", ":Make!<Space>", { noremap = true, silent = false, desc = "Make!" })
vim.keymap.set("n", "<leader>ms", ":setlocal<Space>makeprg=", { noremap = true, silent = false, desc = "Set makeprg localy" })
vim.keymap.set("n", "<leader>mS", ":setlocal<Space>makeprg=", { noremap = true, silent = false, desc = "Set makeprg globaly" })
-- Example: `:setlocal makeprg=python \%` or `:setlocal makeprg=make` or `:setlocal makeprg=clang++ \-Wall \-Wextra % -o %<`
vim.keymap.set("n", "<leader>ml", ":let<Space>&makeprg='", { noremap = true, silent = false, desc = "Let makeprg" })
vim.keymap.set("n", "<leader>mc", ":setlocal<Space>makeprg=clang++\\ -Wall\\ -Wextra\\ %\\ -o\\ %<", { noremap = true, silent = false, desc = "Set makeprg clang" })
vim.keymap.set("n", "<leader>mt", ":Make!<Space>test", { noremap = true, silent = false, desc = "Make! test" })

-- File exploration
vim.keymap.set("n", "<leader>2", ":Explore<CR>", { noremap = true, silent = true, desc = "Explore" })
vim.keymap.set("n", "<leader>3", ":Rexplore<CR>", { noremap = true, silent = true, desc = "Rexplore" })

-- Launch terminal command
vim.keymap.set("n", "<leader>t", ":split | terminal<Space>", { noremap = true, silent = false, desc = "Launch terminal horizontal" })
vim.keymap.set("n", "<leader>T", ":split | terminal<Space>", { noremap = true, silent = false, desc = "Launch terminal vertical" })

-- Last buffer
vim.keymap.set("n", "<leader>1", "<CMD>b#<CR>", { noremap = true, silent = true, desc = "Last buffer" })

-- Quit
vim.keymap.set("n", "<C-c>", "<CMD>q<CR>", { noremap = true, silent = true, desc = "Quit window" })

vim.keymap.set("n", "<C-w>o", "<CMD>only<CR>", { noremap = true, silent = true, desc = "Quit other windows" })

vim.keymap.set("n", "<C-f>", ":<C-f>", { noremap = true, silent = true, desc = "Command history" })

-- Buffer close
vim.keymap.set("n", "<leader>bc", "<CMD>bd!<CR>", { noremap = true, silent = true, desc = "Close buffer" })

-- Kill other window
vim.keymap.set("n", "<leader>o", ":only<CR>", { noremap = true, silent = true, desc = "Close other windows" })

-- -- VISUAL MODE -- --
-- -- Stay in indent mode
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("v", "<", "<gv", opts)

-- -- TERMINAL MODE -- --
local topts = { silent = true }
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", topts)
vim.keymap.set("t", "jk", "<C-\\><C-n>", topts)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", topts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", topts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", topts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", topts)
