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

-----------------------
-- -- NORMAL MODE -- --
-----------------------
-- List of default keymaps:  https://blog.codepen.io/2014/02/21/vim-key-bindings/
-- Available keymaps: | ) ( ] [ "
vim.keymap.set("n", "<leader>4", ":e %<CR>", { desc = "Vim reload current file", opts.args })

-- Diagnostic keymaps
vim.keymap.set('n', "<leader>lk", vim.diagnostic.goto_prev, { desc = 'LSP: Previous diagnostic' })
vim.keymap.set('n', "<leader>lj", vim.diagnostic.goto_next, { desc = 'LSP: Next diagnostic' })
vim.keymap.set('n', "gl", vim.diagnostic.open_float, { desc = 'LSP: Open diagnostic under cursor' })
-- vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist)

-- Keep cursor middle screen when scrolling and jumping around
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down", opts.args })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up", opts.args })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Previous mark", opts.args })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Next mark", opts.args })
-- vim.keymap.set("n", "n", "nzzzv", { desc = "Next search", opts.args })
-- vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search", opts.args })
-- vim.keymap.set("n", "J", "mzJ`z", { desc = "Concatenate prev line", opts.args })
vim.keymap.set("n", "Q", "<nop>")

-- When opening a window, cursor on it
vim.keymap.set("n", "<C-w>V", "<CMD>rightbelow vsplit<CR>", { desc = "Vsplit and focus", opts.args })
vim.keymap.set("n", "<C-w>S", "<CMD>rightbelow split<CR>", { desc = "Split and focus", opts.args })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +10<CR>", { desc = "Resize up", opts.args })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -10<CR>", { desc = "Resize down", opts.args })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -10<CR>", { desc = "Resize left", opts.args })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +10<CR>", { desc = "Resize right", opts.args })

-- Kill window above, below, left, right
vim.keymap.set("n", "<C-w>qk", "<C-w>k:close<CR>", { desc = "Kill window up", opts.args })
vim.keymap.set("n", "<C-w>qj", "<C-w>j:close<CR>", { desc = "Kill window down", opts.args })
vim.keymap.set("n", "<C-w>ql", "<C-w>l:close<CR>", { desc = "Kill window right", opts.args })
vim.keymap.set("n", "<C-w>qh", "<C-w>h:close<CR>", { desc = "Kill window left", opts.args })

-- Window navigation with leader key
vim.keymap.set("n", "<leader>ww", "<C-w>w", { desc = "Cycle windows", opts.args })
vim.keymap.set("n", "<leader>wp", "<C-w>p", { desc = "Previous window", opts.args })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Nav window right", opts.args })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Nav window left", opts.args })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Nav window up", opts.args })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Nav window down", opts.args })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Window vertical split", opts.args })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Window split", opts.args })
vim.keymap.set("n", "<leader>wo", ":only<CR>", { desc = "Quit all other windows", opts.args })
vim.keymap.set("n", "<leader>w_", "<C-w>_", { desc = "Window max out height", opts.args })
vim.keymap.set("n", "<leader>w|", "<C-w>|", { desc = "Window max out width", opts.args })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Windows equal height and width", opts.args })
vim.keymap.set("n", "<leader>wt", "mz:tabnew %<CR>`z", { desc = "Tab new", opts.args })
vim.keymap.set("n", "<leader>wx", "<C-w>x", { desc = "Swap current with next", opts.args })
vim.keymap.set("n", "<leader>wL", "<C-w>L", { desc = "Send window far right", opts.args })
vim.keymap.set("n", "<leader>wH", "<C-w>H", { desc = "Send window far left", opts.args })
vim.keymap.set("n", "<leader>wJ", "<C-w>J", { desc = "Send window far down", opts.args })
vim.keymap.set("n", "<leader>wK", "<C-w>K", { desc = "Send window far up", opts.args })
vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "Close window", opts.args })

-- Quicklist navigation
-- Even if the quicklist is not open, you can navigate with :cn and :cp
vim.keymap.set("n", "<C-n>", ":cn<CR>zz", { desc = "Quicklist next", opts.args })
vim.keymap.set("n", "<C-p>", ":cp<CR>zz", { desc = "Quicklist prev", opts.args })
vim.keymap.set("n", "<leader>qn", ":cn<CR>zz", { desc = "Quicklist next", opts.args })
vim.keymap.set("n", "<leader>qp", ":cp<CR>zz", { desc = "Quicklist prev", opts.args })
vim.keymap.set("n", "<leader>qo", ":copen 15<CR>", { desc = "Quicklist open", opts.args })
vim.keymap.set("n", "<leader>qO", ":Copen<CR>", { desc = "Quicklist open (dispatched)", opts.args })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Quicklist close", opts.args })
vim.keymap.set("n", "<leader>qi", ":cclose<CR>", { desc = "Quicklist close", opts.args })
vim.keymap.set("n", "<leader>qq", ":cc<CR>zz", { desc = "Quicklist show current", opts.args })
vim.keymap.set("n", "<leader>qN", ":cfirst<CR>", { desc = "Quicklist first", opts.args })
vim.keymap.set("n", "<leader>qP", ":clast<CR>", { desc = "Quicklist last", opts.args })

-- Loclist navigation
vim.keymap.set("n", "<leader>ln", ":lnext<CR>zz", { desc = "Location list next", opts.args })
vim.keymap.set("n", "<leader>lp", ":lprev<CR>zz", { desc = "Location list prev", opts.args })
vim.keymap.set("n", "<leader>lo", ":lopen<CR>", { desc = "Location list open", opts.args })
vim.keymap.set("n", "<leader>lq", ":lclose<CR>", { desc = "Location list close", opts.args })

-- Make
-- vim.keymap.set("n", "<leader>mm", function() return ":make<Space>" end, { noremap = true, silent = false, desc = "make", expr = true })
-- vim.keymap.set("n", "<leader>mm", ":make!<Space>", { noremap = true, silent = false, desc = "make! (+enter command)" })
-- vim.keymap.set("n", "<leader>m<CR>", ":make<CR>", { desc = "make<CR>", opts.args })
-- vim.keymap.set("n", "<leader>m!<CR>", ":make!<CR>", { desc = "make!<CR>", opts.args })
-- vim.keymap.set("n", "<leader>mM", ":Make<Space>", { noremap = true, silent = false, desc = "Make (+enter command)" })
-- vim.keymap.set("n", "<leader>M<CR>", ":Make<CR>", { noremap = true, silent = false, desc = "Make<CR>" })
-- vim.keymap.set("n", "<leader>M!", ":Make!<CR>", { noremap = true, silent = false, desc = "Make!<CR>" })
-- vim.keymap.set("n", "<leader>ms", ":setlocal<Space>makeprg=", { noremap = true, silent = false, desc = "Set makeprg localy" })
-- vim.keymap.set("n", "<leader>mS", ":set<Space>makeprg=", { noremap = true, silent = false, desc = "Set makeprg globaly" })
-- vim.keymap.set("n", "<leader>mb", ":set<Space>makeprg=make\\ -C\\ build\\ -j10", { noremap = true, silent = false, desc = "Set makeprg to make -C build" })
-- Example: `:setlocal makeprg=python \%` or `:setlocal makeprg=make` or `:setlocal makeprg=clang++ \-Wall \-Wextra % -o %<`
-- vim.keymap.set("n", "<leader>ml", ":let<Space>&makeprg='", { noremap = true, silent = false, desc = "Let makeprg" })
-- vim.keymap.set("n", "<leader>mc", ":setlocal<Space>makeprg=clang++\\ -Wall\\ -Wextra\\ %\\ -o\\ %<", { noremap = true, silent = false, desc = "Set makeprg clang" })
-- vim.keymap.set("n", "<leader>mt", ":Make!<Space>test", { noremap = true, silent = false, desc = "Make! test" })

-- File exploration
-- vim.keymap.set("n", "<leader>2", ":Explore<CR>", { desc = "Explore", opts.args })
-- vim.keymap.set("n", "<leader>2", ":Fern . -reveal=%<CR>", { desc = "Rexplore", opts.args })
-- vim.keymap.set("n", "<leader>3", ":Rexplore<CR>", { desc = "Rexplore", opts.args })
-- vim.keymap.set("n", "<leader>3", "gq", { desc = "Rexplore", noremap = false, silent = true })


-- Wrap/unwrap
vim.keymap.set("n", "<leader>vw", ":setlocal wrap<CR>", { desc = "Wrap text", opts.args })
vim.keymap.set("n", "<leader>vW", ":setlocal nowrap<CR>", { desc = "Unwrap text", opts.args })

-- hl/nohl search
vim.keymap.set("n", "<leader>vh", ":setlocal hlsearch<CR>", { desc = "Highligth search", opts.args })
vim.keymap.set("n", "<leader>vH", ":setlocal nohlsearch<CR>", { desc = "No highligth search", opts.args })

-- Launch terminal command
vim.keymap.set("n", "<leader>t", ":below split | terminal<Space>", { noremap = true, silent = false, desc = "Launch terminal horizontal" })
vim.keymap.set("n", "<leader>T", ":rightbelow vsplit | terminal<Space>", { noremap = true, silent = false, desc = "Launch terminal vertical" })

-- help
vim.keymap.set("n", "<leader>h", ":vertical rightbelow help<Space>", { noremap = true, silent = false, desc = "Vim help" })

-- Last buffer
vim.keymap.set("n", "<leader>1", "<CMD>b#<CR>", { desc = "Last buffer", opts.args })

-- Quit window, except if it is the last one (ie does not quit vim)!
vim.keymap.set("n", "<C-c>", ":close<CR>", { desc = "Quit window", opts.args })
vim.keymap.set("n", "<C-w>o", "<CMD>only<CR>", { desc = "Quit other windows", opts.args })

-- Command history
vim.keymap.set("n", "<C-f>", ":<C-f>", { desc = "Command history", opts.args })

-- Buffer close
vim.keymap.set("n", "<leader>bc", "<CMD>bd!<CR>", { desc = "Close buffer", opts.args })
vim.keymap.set("n", "<leader>bd", ":bd<Space>", { noremap = true, silent = false, desc = "Select which buffer to delete" })

-- Replace under cursor
vim.keymap.set("n", "<leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { noremap = true, silent = false, desc = "Search and replace word" })

-- Move lines around - normal
-- vim.keymap.set("n", "H", "<<", { desc = "", opts.args })
-- vim.keymap.set("n", "L", ">>", { desc = "", opts.args })
vim.keymap.set("n", "<C-h>", "<<", { desc = "Indent", opts.args })
vim.keymap.set("n", "<C-l>", ">>", { desc = "Unindent", opts.args })
vim.keymap.set('n', "<C-K>", "<Esc>mzO<Esc>`z", { desc = "Insert line above", noremap = true, silent = true })
vim.keymap.set('n', "<C-J>", "<Esc>mzo<Esc>`z", { desc = "Insert line below", noremap = true, silent = true })
-- Deprectated because same can be done by simply selecting the line and doing C-j/C-k
-- vim.keymap.set("n", "<C-k>", "ddkP==", { desc = "Move line up", opts.args })
-- vim.keymap.set("n", "<C-j>", "ddp==", { desc = "Move line down", opts.args })

-- Vimgrep in current buffers
vim.cmd [[
  function ClearQuickfixList()
    call setqflist([])
  endfunction
  command! ClearQuickfixList call ClearQuickfixList()
]]
vim.keymap.set("n", "<leader>sb", "<CMD>ClearQuickfixList<CR>:bufdo vimgrepadd <C-r><C-w> %<Left><Left>", { noremap = true, silent = false, desc = "Grep in buffers" })

-- Tab navigation
vim.keymap.set("n", "<C-t>", "mz:tabnew %<CR>`z", { desc = "Tab new", opts.args })
vim.keymap.set("n", "<leader>]", ":tabnext<CR>", { desc = "Tab next", opts.args })
vim.keymap.set("n", "<leader>[", ":tabprevious<CR>", { desc = "Tab previous", opts.args })

-- Location list navigation
vim.keymap.set("n", "<leader>qj", ":lnext<CR>", { desc = "Location next", opts.args })
vim.keymap.set("n", "<leader>qk", ":lprevious<CR>", { desc = "Location previous", opts.args })

-- Center window around cursor
vim.keymap.set("n", "L", "zz", { desc = "Center window around cursor", opts.args })

-----------------------
-- -- INSERT MODE -- --
-----------------------

-- Escape from INSERT mode
vim.keymap.set('i', "jk", "<ESC>", { desc = "Escape INSERT mode", noremap = true, silent = true })
-- vim.keymap.set('i', "<S-TAB>", "<C-d>", { desc = "Unindent INSERT mode", noremap = true, silent = true })

-- Insert line above in insert mode
-- WARNING: only works if tpope/unimpaired is installed
vim.keymap.set('i', "<C-k>", "<Esc>mzO<Esc>`za", { desc = "Insert line above", noremap = true, silent = true })
vim.keymap.set('i', "<C-j>", "<Esc>mzo<Esc>`za", { desc = "Insert line below", noremap = true, silent = true })

-- Better indentation insert mode
vim.keymap.set("i", "<C-l>", "<C-t>", { desc = "Indent", opts.args })
vim.keymap.set("i", "<C-h>", "<C-d>", { desc = "Unindent", opts.args })

-- Delete in front of cursor in insert mode
vim.keymap.set("i", "<C-d>", "<space><Esc>ce", { desc = "Delete after cursor", opts.args })

-- Automatic bracket closing
-- vim.keymap.set("i", '"', '""<left>', opts)
-- vim.keymap.set("i", '""', '""', opts)
-- vim.keymap.set("i", "'", "''<left>", opts)
-- vim.keymap.set("i", "''", "''", opts)
-- vim.keymap.set("i", "(", "()<left>", opts)
-- vim.keymap.set("i", "(<CR>", "(<CR>)<Esc>O", opts)
-- vim.keymap.set("i", "()", "()", opts)
-- vim.keymap.set("i", "[", "[]<left>", opts)
-- vim.keymap.set("i", "[<CR>", "[<CR>]<Esc>O", opts)
-- vim.keymap.set("i", "[]", "[]", opts)
vim.keymap.set("i", "{", "{}<left>", { opts.args })
vim.keymap.set("i", "{}", "{}", { opts.args })
vim.keymap.set("i", "{<CR>", "{<CR>}<Esc>O", { opts.args })
vim.keymap.set("i", "{;<CR>", "{<CR>};<Esc>O", { opts.args })

-- Make it so gjk does not remove you from insert mode - for my sanity
-- vim.keymap.set("i", "gjk", "gjk")

-----------------------
-- -- VISUAL MODE -- --
-----------------------
-- Move lines around - visual
vim.keymap.set("v", ">", ">gv", { desc = "Indent", opts.args })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent", opts.args })
-- vim.keymap.set("v", "L", ">gv", { desc = "", opts.args })
-- vim.keymap.set("v", "H", "<gv", { desc = "", opts.args })
vim.keymap.set("v", "<C-l>", ">gv", { desc = "Indent", opts.args })
vim.keymap.set("v", "<C-h>", "<gv", { desc = "Unindent", opts.args })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines up", opts.args })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines down", opts.args })

-- Keep what is in register when pasting in visual mode
vim.keymap.set("v", "p", '"_dP', { desc = "Paste", opts.args })

-------------------------
-- -- TERMINAL MODE -- --
-------------------------
local topts = { silent = true }
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Escape", topts.args })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Escape", topts.args })

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    command = 'startinsert',
})

-- vim.cmd[[
--   autocmd TermOpen * nnoremap <silent> <buffer> q :close<CR>
-- ]]
