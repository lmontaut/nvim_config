-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- How to use:
-- 1 - add plugin, :source %, :PackerInstall, :PackerCompile
-- 2 - comment plugin, :source %, :PackerCompile to take effect, :PackerClean to delete folder

require('packer').startup(function(use)
  -- Main plugins: Telescope, cmp, treesitter, lsp-config, neodev, fugitive, comment, which-key, DAP and Pap
  -- Optional: packer, plenary, sneak, project, lualine, indent-blankline

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

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' },
  }

  -- Cycle functions overloads
  use { 'Issafalcon/lsp-overloads.nvim' }

  -- Highlight, edit, and navigate code
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  -- fzf
  use {'junegunn/fzf', run = function()
      vim.fn['fzf#install']()
  end
  }

  -- Additional text objects via treesitter
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-rhubarb' }
  use { 'lewis6991/gitsigns.nvim' }

  -- Better netrw
  -- use { 'tpope/vim-vinegar' }
  use { 'tpope/vim-eunuch' }
  -- use { 'justinmk/vim-dirvish' }

  -- use { 'navarasu/onedark.nvim' } -- Theme inspired by Atom
  use { "catppuccin/nvim", as = "catppuccin" }
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

  -- File browser -- takes way too much ram wtf
  -- use { "ms-jpq/chadtree" }

  -- Navigation
  use { "justinmk/vim-sneak" }

  -- Project manager
  use { "ahmedkhalf/project.nvim" }

  -- Buffer line
  -- use { "akinsho/bufferline.nvim" }

  -- symbol outline
  -- use { "simrat39/symbols-outline.nvim" }
  use { "lmontaut/symbols-outline.nvim" }

  -- undo tree
  use { "mbbill/undotree" }

  -- My Pap
  use { "~/software/misc/nvim/nvim-pap" }

  -- Debugger
  use { "mfussenegger/nvim-dap",
    requires = { "nvim-telescope/telescope-dap.nvim" },
  }

  -- Align stuff
  use { "godlygeek/tabular" }

  -- Dap-ui
  use { "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap", "rcarriga/cmp-dap" }
  }

  -- Just files syntax highlighting
  use {'NoahTheDuke/vim-just' }

  -- Neorg
  -- use { "nvim-neorg/neorg",
    -- run = ":Neorg sync-parsers",
    -- requires = "nvim-lua/plenary.nvim",
  -- }

  -- Obsidian
  -- use { "epwalsh/obsidian.nvim" }

  -- Mardown preview
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  -- C# dev
  -- use { 'OmniSharp/omnisharp-vim' }
  -- use { "Decodetalkers/csharpls-extended-lsp.nvim" }

  -- Any jump
  use { "pechorin/any-jump.vim" }

  -- Dired
  use {
    "X3eRo0/dired.nvim",
    requires = "MunifTanjim/nui.nvim",
    config = function()
      require("dired").setup {
        path_separator = "/",
        show_banner = false,
        show_hidden = true,
        show_dot_dirs = true,
        show_colors = true,
      }
    end
  }

  -- Multicursors
  use {
    "smoka7/multicursors.nvim",
    requires = {
      "smoka7/hydra.nvim"
    }
  }

  -- tpope's unimpaired (bunch of usefull ]-... stuff)
  use { "tpope/vim-unimpaired" }

  -- Neogit
  use {
    "NeogitOrg/neogit",
    requires = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    }
  }

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
