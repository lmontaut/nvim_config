return {
  -- Main plugins: Telescope, cmp, treesitter, lsp-config, neodev, fugitive, comment, which-key, DAP and Pap
  -- Optional: packer, plenary, sneak, project, lualine, indent-blankline

  -- Main plugins are tagged with **

  -- "folke/which-key.nvim",
  -- { "folke/neoconf.nvim", cmd = "Neoconf" },
  -- "folke/neodev.nvim",

  ------------------------------------------------------------------------------------------------------------
  ---------- NVIM TOOLS
  ------------------------------------------------------------------------------------------------------------
  -- Plenary: lots of useful functions
  { "nvim-lua/plenary.nvim" },

  -- Highlight, edit, and navigate code -- **
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Helper to know what each binding does -- **
  { "folke/which-key.nvim" },

  -- Additional text objects via treesitter
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter',
  },

  -- Multiple terminals in vim -- **
  { "akinsho/toggleterm.nvim" },

  ------------------------------------------------------------------------------------------------------------
  ---------- LSP
  ------------------------------------------------------------------------------------------------------------
  -- LSP Configuration & Plugins -- **
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion -- **
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' },
  },

  -- Cycle functions overloads -- **
  { 'Issafalcon/lsp-overloads.nvim' },

  -- symbol outline
  -- use { "simrat39/symbols-outline.nvim" }
  { "lmontaut/symbols-outline.nvim" },

  -- LSP saga: fancier lsp display, outline etc -- **
  { 'nvimdev/lspsaga.nvim' },

  -- File outline
  { "hedyhli/outline.nvim" },

  -- C# dev
  -- { 'OmniSharp/omnisharp-vim' },
  -- { "Decodetalkers/csharpls-extended-lsp.nvim" },

  -- Any jump -- **
  {
    "pechorin/any-jump.vim",
    config = function()
      vim.cmd([[let g:any_jump_disable_default_keybindings = 1]])
      vim.keymap.set("n", "<leader>Ab", ":AnyJumpBack<CR>", { desc = "AnyJumpBack" })
      vim.keymap.set("n", "<leader>Al", ":AnyJumpLastResults<CR>", { desc = "AnyJumpLastResults" })
    end,
  }, -- For when LSP is unavailable

  ------------------------------------------------------------------------------------------------------------
  ---------- DEBUG
  ------------------------------------------------------------------------------------------------------------
  -- Debugger -- **
  {
    "mfussenegger/nvim-dap",
    dependencies = { "nvim-telescope/telescope-dap.nvim" }
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/cmp-dap" }
  },
  -- { "theHamsta/nvim-dap-virtual-text" },

  ------------------------------------------------------------------------------------------------------------
  ---------- LOOKS
  ------------------------------------------------------------------------------------------------------------
  -- Better icons
  { 'nvim-tree/nvim-web-devicons' },

  -- Color themes
  -- use { 'navarasu/onedark.nvim' } -- Theme inspired by Atom
  { "catppuccin/nvim",            name = "catppuccin" },

  -- Status line -- **
  { 'nvim-lualine/lualine.nvim' },
  -- use { 'lukas-reineke/indent-blankline.nvim' } -- Add indentation guides even on blank lines

  -- Just files syntax highlighting
  { 'NoahTheDuke/vim-just' },

  -- Replaces ui of cmdline, messages etc...
  -- { "folke/noice.nvim",
  --   dependencies = {
  --   -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --   "MunifTanjim/nui.nvim",
  --   -- OPTIONAL:
  --   --   `nvim-notify` is only needed, if you want to use the notification view.
  --   --   If not available, we use `mini` as the fallback
  --   -- "rcarriga/nvim-notify",
  --   }
  -- },

  ------------------------------------------------------------------------------------------------------------
  ---------- NAVIGATION
  ------------------------------------------------------------------------------------------------------------
  -- Fuzzy Finder (files, lsp, etc) -- **
  -- TODO: tag 0.1.5
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    tag = '0.1.5',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim', version = "^1.0.0" },
    },
  },

  -- harpoon: go to project files quickly
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- fzf
  {
    'junegunn/fzf',
    build = function()
      vim.fn['fzf#install']()
    end
  },

  -- Project manager -- **
  { "ahmedkhalf/project.nvim" },

  -- Better s/f navigation -- **
  { "justinmk/vim-sneak" },

  -- tpope's unimpaired (bunch of usefull ]-... stuff)
  { "tpope/vim-unimpaired" },

  -- Navigate important project files
  {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Navigate recent locations quickly
  {
    "cbochs/portal.nvim",
    -- Optional dependencies
    dependencies = { "cbochs/grapple.nvim" },
  },

  -- Better marks setup
  { "chentoast/marks.nvim" },

  -- Easy window switch -- **
  { "yorickpeterse/nvim-window" },

  -- Move windows around -- **
  { "sindrets/winshift.nvim" },

  -- More intuitive window resizing
  { "mrjones2014/smart-splits.nvim" },

  ------------------------------------------------------------------------------------------------------------
  ---------- GIT
  ------------------------------------------------------------------------------------------------------------
  -- Neogit -- **
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    }
  },

  -- Git related plugins -- **
  { 'lewis6991/gitsigns.nvim' },
  -- { 'tpope/vim-fugitive' }, -- replaced by neogit
  -- { 'tpope/vim-rhubarb' }, -- open github urls

  -- Very very very good file navigator -- **
  { 'stevearc/oil.nvim' },
  -- { 'tpope/vim-eunuch' }, -- if oil.nvim is not available...
  -- { 'tpope/vim-vinegar' },
  -- { 'justinmk/vim-dirvish' },

  ------------------------------------------------------------------------------------------------------------
  ---------- CODE EDITION TOOLS
  ------------------------------------------------------------------------------------------------------------
  -- My Pap: best plugin -- **
  { "lmontaut/nvim-pap",      dev = true, lazy = false },

  -- "gc" to comment visual regions/lines -- **
  {
    'numToStr/Comment.nvim',
    opts = {}, -- arguments to be passed to setup function
  },

  -- Detect tabstop and shiftwidth automatically. Can potentially conflict with Treesitter!
  { 'tpope/vim-sleuth' },

  -- undo tree
  { "mbbill/undotree" },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },

  -- Align stuff -- **
  { "godlygeek/tabular" },

  -- Multicursors
  {
    "smoka7/multicursors.nvim",
    dependencies = {
      "smoka7/hydra.nvim"
    }
  },

  -- Latex
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_view_skim_sync = 1     -- Value 1 allows forward search after every successful compilation
      vim.g.vimtex_view_skim_activate = 1 -- Value 1 allows change focus to skim after command `:VimtexView` is given
      vim.g.vimtex_compiler_silent = 1    -- makes the compiler silent, prevents buffer to popup
    end
  },

  -- Find and replace (a wrapper around sad terminal utility) -- **
  {
    "ray-x/sad.nvim",
    dependencies = { "ray-x/guihua.lua", build = "cd lua/fzy && make" }
  },

  -- Automatic bracket closing -- **
  { "windwp/nvim-autopairs" },

  -- Copilot
  -- To set up:
  -- :Copilot setup
  -- :Copilot enable
  -- { "github/copilot.vim" },
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
  -- { "nvim-neorg/neorg",
  -- build = ":Neorg sync-parsers",
  -- requires = "nvim-lua/plenary.nvim",
  -- },

  -- Obsidian
  -- { "epwalsh/obsidian.nvim" },

  -- Mardown preview
  -- { "iamcco/markdown-preview.nvim", build = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, }
}
