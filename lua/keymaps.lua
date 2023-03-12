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

-- Keep cursor middle screen when scrolling and jumping around
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "<C-o>", "<C-o>zz", opts)
vim.keymap.set("n", "<C-i>", "<C-i>zz", opts)
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "J", "mzJ`z", opts)
vim.keymap.set("n", "Q", "<nop>", opts)

-- -- INSERT MODE -- --
-- Escape from INSERT mode
vim.keymap.set('i', "jk", "<ESC>", { noremap = true, silent = true, desc = "Escape INSERT mode" })
vim.keymap.set('i', "<S-TAB>", "<C-d>", { noremap = true, silent = true, desc = "Unindent INSERT mode" })

-- -- NORMAL MODE -- --
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +10<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize -10<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -10<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +10<CR>", opts)

-- Quicklist navigation
-- Even if the quicklist is not open, you can navigate with :cn and :cp
vim.keymap.set("n", "<C-n>", ":cn<CR>zz", { noremap = true, silent = true, desc = "Quicklist next" })
vim.keymap.set("n", "<C-p>", ":cp<CR>zz", { noremap = true, silent = true, desc = "Quicklist prev" })
vim.keymap.set("n", "<leader>qn", ":cn<CR>zz", { noremap = true, silent = true, desc = "Quicklist next" })
vim.keymap.set("n", "<leader>qp", ":cp<CR>zz", { noremap = true, silent = true, desc = "Quicklist prev" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { noremap = true, silent = true, desc = "Quicklist open" })
vim.keymap.set("n", "<leader>qO", ":Copen<CR>", { noremap = true, silent = true, desc = "Quicklist open (dispatched)" })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { noremap = true, silent = true, desc = "Quicklist close" })
vim.keymap.set("n", "<leader>qq", ":cc<CR>zz", { noremap = true, silent = true, desc = "Quicklist show current" })
vim.keymap.set("n", "<leader>qN", ":cfirst<CR>", { noremap = true, silent = true, desc = "Quicklist first" })
vim.keymap.set("n", "<leader>qP", ":clast<CR>", { noremap = true, silent = true, desc = "Quicklist last" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { noremap = true, silent = true, desc = "Quicklist open" })

-- Make
-- vim.keymap.set("n", "<leader>mm", function() return ":make<Space>" end, { noremap = true, silent = false, desc = "make", expr = true })
vim.keymap.set("n", "<leader>mm", ":Make<Space>", { noremap = true, silent = false, desc = "Make" })
vim.keymap.set("n", "<leader>mm", ":make<Space>", { noremap = true, silent = false, desc = "make" })
vim.keymap.set("n", "<leader>m<CR>", ":make<CR>", { noremap = true, silent = true, desc = "make<CR>" })
vim.keymap.set("n", "<leader>mM", ":Make<Space>", { noremap = true, silent = false, desc = "Make" })
vim.keymap.set("n", "<leader>m!", ":Make!<Space>", { noremap = true, silent = false, desc = "Make!" })
vim.keymap.set("n", "<leader>ms", ":setlocal<Space>makeprg=", { noremap = true, silent = false, desc = "Set makeprg localy" })
vim.keymap.set("n", "<leader>mS", ":set<Space>makeprg=", { noremap = true, silent = false, desc = "Set makeprg globaly" })
vim.keymap.set("n", "<leader>mb", ":set<Space>makeprg=make\\ -C\\ build\\ -j10", { noremap = true, silent = false, desc = "Set makeprg to make -C build" })
-- Example: `:setlocal makeprg=python \%` or `:setlocal makeprg=make` or `:setlocal makeprg=clang++ \-Wall \-Wextra % -o %<`
vim.keymap.set("n", "<leader>ml", ":let<Space>&makeprg='", { noremap = true, silent = false, desc = "Let makeprg" })
vim.keymap.set("n", "<leader>mc", ":setlocal<Space>makeprg=clang++\\ -Wall\\ -Wextra\\ %\\ -o\\ %<", { noremap = true, silent = false, desc = "Set makeprg clang" })
vim.keymap.set("n", "<leader>mt", ":Make!<Space>test", { noremap = true, silent = false, desc = "Make! test" })

-- File exploration
vim.keymap.set("n", "<leader>2", ":Explore<CR>", { noremap = true, silent = true, desc = "Explore" })
vim.keymap.set("n", "<leader>3", ":Rexplore<CR>", { noremap = true, silent = true, desc = "Rexplore" })

-- Launch terminal command
vim.keymap.set("n", "<leader>t", ":below split | terminal<Space>", { noremap = true, silent = false, desc = "Launch terminal horizontal" })
vim.keymap.set("n", "<leader>T", ":rightbelow vsplit | terminal<Space>", { noremap = true, silent = false, desc = "Launch terminal vertical" })

-- help
vim.keymap.set("n", "<leader>h", ":vertical rightbelow help<Space>", { noremap = true, silent = false, desc = "Vim help" })

-- Last buffer
vim.keymap.set("n", "<leader>1", "<CMD>b#<CR>", { noremap = true, silent = true, desc = "Last buffer" })

-- Quit
vim.keymap.set("n", "<C-c>", "<CMD>q<CR>", { noremap = true, silent = true, desc = "Quit window" })

vim.keymap.set("n", "<C-w>o", "<CMD>only<CR>", { noremap = true, silent = true, desc = "Quit other windows" })

vim.keymap.set("n", "<C-f>", ":<C-f>", { noremap = true, silent = true, desc = "Command history" })

-- Buffer close
vim.keymap.set("n", "<leader>bc", "<CMD>bd!<CR>", { noremap = true, silent = true, desc = "Close buffer" })

-- Better indentation insert mode
vim.keymap.set("i", "<C-l>", "<C-t>", opts)
vim.keymap.set("i", "<C-h>", "<C-d>", opts)

-- Delete in front of cursor in insert mode
vim.keymap.set("i", "<C-u>", "<space><Esc>ce", opts)

-- Automatic bracket closing
vim.keymap.set("i", '"', '""<left>', opts)
vim.keymap.set("i", "'", "''<left>", opts)
vim.keymap.set("i", "(", "()<left>", opts)
vim.keymap.set("i", "[", "[]<left>", opts)
vim.keymap.set("i", "{", "{}<left>", opts)
vim.keymap.set("i", "{<CR>", "{<CR>}<Esc>O", opts)
vim.keymap.set("i", "{;<CR>", "{<CR>};<Esc>O", opts)

-- Replace under cursor
vim.keymap.set("n", "<leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { noremap = true, silent = false })

-- Move lines around - visual
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", "L", ">gv", opts)
vim.keymap.set("v", "H", "<gv", opts)
vim.keymap.set("v", "<C-l>", ">gv", opts)
vim.keymap.set("v", "<C-h>", "<gv", opts)
vim.keymap.set("v", "<C-k>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-j>", ":m '<-2<CR>gv=gv", opts)

-- Move lines around - normal
vim.keymap.set("n", "H", "<<", opts)
vim.keymap.set("n", "L", ">>", opts)
vim.keymap.set("n", "<C-h>", "<<", opts)
vim.keymap.set("n", "<C-l>", ">>", opts)
vim.keymap.set("n", "<C-k>", "ddkP==", opts)
vim.keymap.set("n", "<C-j>", "ddp==", opts)

-- Keep what is in register when pasting in visual mode
vim.keymap.set("v", "p", '"_dP', opts)

-- -- TERMINAL MODE -- --
local topts = { silent = true }
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", topts)
vim.keymap.set("t", "jk", "<C-\\><C-n>", topts)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", topts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", topts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", topts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", topts)
