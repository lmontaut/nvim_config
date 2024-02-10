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

  -- Main plugins are tagged with **

  ------------------------------------------------------------------------------------------------------------
  ---------- NVIM TOOLS
  ------------------------------------------------------------------------------------------------------------
  -- Package manager -- **
  use { 'wbthomason/packer.nvim' }

  -- Plenary: lots of useful functions
  use { 'nvim-lua/plenary.nvim' }

  -- Highlight, edit, and navigate code -- **
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  -- Helper to know what each binding does -- **
  use { "folke/which-key.nvim" }

  -- Additional text objects via treesitter
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Multiple terminals in vim -- **
  use { "akinsho/toggleterm.nvim" }

  ------------------------------------------------------------------------------------------------------------
  ---------- LSP
  ------------------------------------------------------------------------------------------------------------
  -- LSP Configuration & Plugins -- **
  use {
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

  -- Autocompletion -- **
  use {
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' },
  }

  -- Cycle functions overloads -- **
  use { 'Issafalcon/lsp-overloads.nvim' }

  -- symbol outline
  -- use { "simrat39/symbols-outline.nvim" }
  use { "lmontaut/symbols-outline.nvim" }

  -- LSP saga: fancier lsp display, outline etc -- **
  use { 'nvimdev/lspsaga.nvim', }

  -- C# dev
  -- use { 'OmniSharp/omnisharp-vim' }
  -- use { "Decodetalkers/csharpls-extended-lsp.nvim" }

  -- Any jump -- **
  use { "pechorin/any-jump.vim" } -- For when LSP is unavailable

  ------------------------------------------------------------------------------------------------------------
  ---------- DEBUG
  ------------------------------------------------------------------------------------------------------------
  -- Debugger -- **
  use { "mfussenegger/nvim-dap",
    requires = { "nvim-telescope/telescope-dap.nvim" },
  }
  use { "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap", "rcarriga/cmp-dap" }
  }
  -- use { "theHamsta/nvim-dap-virtual-text" }

  ------------------------------------------------------------------------------------------------------------
  ---------- LOOKS
  ------------------------------------------------------------------------------------------------------------
  -- Better icons
  use { 'nvim-tree/nvim-web-devicons' }

  -- Color themes
  -- use { 'navarasu/onedark.nvim' } -- Theme inspired by Atom
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Status line -- **
  use { 'nvim-lualine/lualine.nvim' }
  -- use { 'lukas-reineke/indent-blankline.nvim' } -- Add indentation guides even on blank lines

  -- Just files syntax highlighting
  use {'NoahTheDuke/vim-just' }

  -- Replaces ui of cmdline, messages etc...
  use { "folke/noice.nvim",
    requires = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
    }
  }

  ------------------------------------------------------------------------------------------------------------
  ---------- NAVIGATION
  ------------------------------------------------------------------------------------------------------------
  -- Fuzzy Finder (files, lsp, etc) -- **
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- fzf
  use {'junegunn/fzf', run = function()
      vim.fn['fzf#install']()
  end
  }

  -- Project manager -- **
  use { "ahmedkhalf/project.nvim" }

  -- Better s/f navigation -- **
  use { "justinmk/vim-sneak" }

  -- tpope's unimpaired (bunch of usefull ]-... stuff)
  use { "tpope/vim-unimpaired" }

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

  -- Easy window switch -- **
  use { "yorickpeterse/nvim-window" }

  -- Move windows around -- **
  use { "sindrets/winshift.nvim" }

  -- More intuitive window resizing
  use { "mrjones2014/smart-splits.nvim" }

  ------------------------------------------------------------------------------------------------------------
  ---------- GIT
  ------------------------------------------------------------------------------------------------------------
  -- Neogit -- **
  use {
    "NeogitOrg/neogit",
    requires = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    }
  }

  -- Git related plugins -- **
  use { 'lewis6991/gitsigns.nvim' }
  -- use { 'tpope/vim-fugitive' } -- replaced by neogit
  -- use { 'tpope/vim-rhubarb' } -- open github urls

  -- Very very very good file navigator -- **
  use{ 'stevearc/oil.nvim' }
  -- use { 'tpope/vim-eunuch' } -- if oil.nvim is not available...
  -- use { 'tpope/vim-vinegar' }
  -- use { 'justinmk/vim-dirvish' }

  ------------------------------------------------------------------------------------------------------------
  ---------- CODE EDITION TOOLS
  ------------------------------------------------------------------------------------------------------------
  -- My Pap: best plugin -- **
  use { "~/software/misc/nvim/nvim-pap" }

  -- "gc" to comment visual regions/lines -- **
  use { 'numToStr/Comment.nvim' }

  -- Detect tabstop and shiftwidth automatically. Can potentially conflict with Treesitter!
  use { 'tpope/vim-sleuth' }

  -- undo tree
  use { "mbbill/undotree" }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Align stuff
  use { "godlygeek/tabular" }

  -- Multicursors
  use {
    "smoka7/multicursors.nvim",
    requires = {
      "smoka7/hydra.nvim"
    }
  }

  -- Find and replace (a wrapper around sad terminal utility) -- **
  use { "ray-x/sad.nvim",
    requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" }
  }

  -- Automatic bracket closing -- **
  use { "windwp/nvim-autopairs" }

  -- Copilot
  -- To set up:
  -- :Copilot setup
  -- :Copilot enable
  use { "github/copilot.vim" }
  -- use({ -- buggy and useless tbh
  --   "jackMort/ChatGPT.nvim",
  --   requires = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "folke/trouble.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   }
  -- })

  ------------------------------------------------------------------------------------------------------------
  ---------- NOTES
  ------------------------------------------------------------------------------------------------------------
  -- Neorg
  -- use { "nvim-neorg/neorg",
    -- run = ":Neorg sync-parsers",
    -- requires = "nvim-lua/plenary.nvim",
  -- }

  -- Obsidian
  -- use { "epwalsh/obsidian.nvim" }

  -- Mardown preview
  -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })


  ------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------
  ---------- END OF PLUGINS
  ------------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------------

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
