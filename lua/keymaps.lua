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
vim.keymap.set("n", "<TAB>" , ">>_", opts)
vim.keymap.set("n", "<S-TAB>" , "<<_", opts)

-- Quicklist navigation
vim.keymap.set("n", "<leader>qn", ":cn<CR>", { noremap = true, silent = true, desc = "Quicklist next" })
vim.keymap.set("n", "<leader>qp", ":cp<CR>", { noremap = true, silent = true, desc = "Quicklist prev" })

-- Launch terminal command
vim.keymap.set("n", "<leader>r", ":split | terminal <C-DOWN>", { noremap = true, silent = true, desc = "Launch terminal command" })

-- Last buffer
vim.keymap.set("n", "<leader>1", "<CMD>b#<CR>", { noremap = true, silent = true, desc = "Last buffer" })

-- Quit
vim.keymap.set("n", "<C-c>", "<CMD>q<CR>", { noremap = true, silent = true, desc = "Quit window" })

vim.keymap.set("n", "<C-w>o", "<CMD>only<CR>", { noremap = true, silent = true, desc = "Quit other windows" })

vim.keymap.set("n", "<C-f>", ":<C-f>", { noremap = true, silent = true, desc = "Command history" })

-- Buffer close
vim.keymap.set("n", "<leader>bc", "<CMD>bd!<CR>", { noremap = true, silent = true, desc = "Close buffer" })

-- -- VISUAL MODE -- --
-- -- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- -- TERMINAL MODE -- --
local topts = { silent = true }
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", topts)
vim.keymap.set("t", "jk", "<C-\\><C-n>", topts)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", topts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", topts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", topts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", topts)
