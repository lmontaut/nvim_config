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

  use { 'nvim-tree/nvim-web-devicons' }

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
  use { 'tpope/vim-eunuch' }
  -- use { 'tpope/vim-vinegar' }
  -- use { 'justinmk/vim-dirvish' }
  use{ 'stevearc/oil.nvim' } -- very very very good file navigator

  -- Color themes
  -- use { 'navarasu/onedark.nvim' } -- Theme inspired by Atom
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Visual enhancements
  use { 'nvim-lualine/lualine.nvim' } -- Fancier statusline
  -- use { 'lukas-reineke/indent-blankline.nvim' } -- Add indentation guides even on blank lines

  -- "gc" to comment visual regions/lines
  use { 'numToStr/Comment.nvim' }

  -- Detect tabstop and shiftwidth automatically. Can potentially conflict with Treesitter!
  use { 'tpope/vim-sleuth' }

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Helper to know what each binding does
  use { "folke/which-key.nvim" }

  -- Navigation
  use { "justinmk/vim-sneak" }

  -- Project manager
  use { "ahmedkhalf/project.nvim" }

  -- symbol outline
  -- use { "simrat39/symbols-outline.nvim" }
  use { "lmontaut/symbols-outline.nvim" }

  -- LSP saga
  use { 'nvimdev/lspsaga.nvim', }

  -- undo tree
  use { "mbbill/undotree" }

  -- My Pap -- best plugin
  use { "~/software/misc/nvim/nvim-pap" }

  -- Debugger
  use { "mfussenegger/nvim-dap",
    requires = { "nvim-telescope/telescope-dap.nvim" },
  }
  use { "theHamsta/nvim-dap-virtual-text" }
  use { "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap", "rcarriga/cmp-dap" }
  }

  -- Align stuff
  use { "godlygeek/tabular" }

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
  -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  -- C# dev
  -- use { 'OmniSharp/omnisharp-vim' }
  -- use { "Decodetalkers/csharpls-extended-lsp.nvim" }

  -- Any jump
  use { "pechorin/any-jump.vim" }

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

  -- Find and replace (a wrapper around sad terminal utility)
  use { "ray-x/sad.nvim",
    requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" }
  }

  -- Navigate important project files
  use {
    "cbochs/grapple.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }

  -- Navigate recent locations quickly
  use { "cbochs/portal.nvim",
    -- Optional dependencies
    requires = { "cbochs/grapple.nvim" },
  }

  -- Better marks setup
  use { "chentoast/marks.nvim" }

  -- Noice
  -- use { "folke/noice.nvim",
  --   requires = {
  --   -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --   "MunifTanjim/nui.nvim",
  --   -- OPTIONAL:
  --   --   `nvim-notify` is only needed, if you want to use the notification view.
  --   --   If not available, we use `mini` as the fallback
  --   -- "rcarriga/nvim-notify",
  --   }
  -- }

  -- Toggle term -- multiple terminals in vim
  use { "akinsho/toggleterm.nvim" }

  -- Automatic bracket closing
  use { "windwp/nvim-autopairs" }

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
