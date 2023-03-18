-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- How to use:
-- 1 - add plugin, source %, PackerInstall
-- 2 - comment plugin, source % PackerCompile to take effect , PackerClean to delete folder

require('packer').startup(function(use)
  -- Package manager
  use { 'wbthomason/packer.nvim' }

  -- Plenary: lots of useful functions
  use { 'nvim-lua/plenary.nvim' }

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use {'junegunn/fzf', run = function()
      vim.fn['fzf#install']()
  end
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-rhubarb' }
  use { 'lewis6991/gitsigns.nvim' }

  -- Dispatch build commands
  use {  'tpope/vim-dispatch' }

  use { 'navarasu/onedark.nvim' } -- Theme inspired by Atom
  use { 'nvim-lualine/lualine.nvim' } -- Fancier statusline
  use { 'lukas-reineke/indent-blankline.nvim' } -- Add indentation guides even on blank lines
  use { 'numToStr/Comment.nvim' } -- "gc" to comment visual regions/lines
  use { 'tpope/vim-sleuth' } -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Helper to know what each binding does
  use { "folke/which-key.nvim" }

  -- File browser
  use { "ms-jpq/chadtree" }

  -- Navigation
  use { "justinmk/vim-sneak" }

  -- Project manager
  use { "ahmedkhalf/project.nvim" }

  -- Buffer line
  use { "akinsho/bufferline.nvim" }

  -- symbol outline
  use { "simrat39/symbols-outline.nvim" }

  -- undo tree
  use { "mbbill/undotree" }

  -- My Pap
  use { "~/code/nvim/nvim-pap" }

  -- Debugger
  use { "mfussenegger/nvim-dap" }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end
