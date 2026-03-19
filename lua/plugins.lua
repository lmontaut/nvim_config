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
  { 'echasnovski/mini.icons',          version = '*' },

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

  -- Rust tools
  -- {
  --   'mrcjkb/rustaceanvim',
  --   version = '^5', -- Recommended
  --   lazy = false,   -- This plugin is already lazy
  -- },

  -- GLSL support
  -- { "tikhomirov/vim-glsl" },

  -- Agent
  {
    "ThePrimeagen/99",
    config = function()
      local _99 = require("99")

      -- For logging that is to a file if you wish to trace through requests
      -- for reporting bugs, i would not rely on this, but instead the provided
      -- logging mechanisms within 99.  This is for more debugging purposes
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)
      local Providers = require("99.providers")
      _99.setup({
        provider = Providers.ClaudeCodeProvider,
        model = "claude-opus-4-5",
        logger = {
          level = _99.DEBUG,
          -- path = "~/.local/tmp/" .. basename .. ".99.debug",
          path = "/tmp/" .. basename .. ".99.debug",
          print_on_error = true,
        },

        --- A new feature that is centered around tags
        completion = {
          --- Defaults to .cursor/rules
          -- I am going to disable these until i understand the
          -- problem better.  Inside of cursor rules there is also
          -- application rules, which means i need to apply these
          -- differently
          -- cursor_rules = "<custom path to cursor rules>"

          --- A list of folders where you have your own SKILL.md
          --- Expected format:
          --- /path/to/dir/<skill_name>/SKILL.md
          ---
          --- Example:
          --- Input Path:
          --- "scratch/custom_rules/"
          ---
          --- Output Rules:
          --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
          --- ... the other rules in that dir ...
          ---
          custom_rules = {
            "scratch/custom_rules/",
          },

          --- What autocomplete do you use.  We currently only
          --- support cmp right now
          source = "cmp",
        },

        --- WARNING: if you change cwd then this is likely broken
        --- ill likely fix this in a later change
        ---
        --- md_files is a list of files to look for and auto add based on the location
        --- of the originating request.  That means if you are at /foo/bar/baz.lua
        --- the system will automagically look for:
        --- /foo/bar/AGENT.md
        --- /foo/AGENT.md
        --- assuming that /foo is project root (based on cwd)
        md_files = {
          "AGENT.md",
          "AGENTS.md",
        },
      })

      -- Create your own short cuts for the different types of actions
      vim.keymap.set("n", "<leader>9f", function()
        _99.fill_in_function()
      end)
      -- take extra note that i have visual selection only in v mode
      -- technically whatever your last visual selection is, will be used
      -- so i have this set to visual mode so i dont screw up and use an
      -- old visual selection
      --
      -- likely ill add a mode check and assert on required visual mode
      -- so just prepare for it now
      vim.keymap.set("v", "<leader>9v", function()
        _99.visual()
      end)

      vim.keymap.set("v", "<leader>99", function()
        _99.visual_prompt()
      end)

      --- if you have a request you dont want to make any changes, just cancel it
      vim.keymap.set("v", "<leader>9s", function()
        _99.stop_all_requests()
      end)

      --- Example: Using rules + actions for custom behaviors
      --- Create a rule file like ~/.rules/debug.md that defines custom behavior.
      --- For instance, a "debug" rule could automatically add printf statements
      --- throughout a function to help debug its execution flow.
      vim.keymap.set("n", "<leader>9fd", function()
        _99.fill_in_function()
      end)
    end,
  },

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
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/cmp-dap", "nvim-neotest/nvim-nio" }
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

  {
    "ThePrimeagen/git-worktree.nvim"
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
