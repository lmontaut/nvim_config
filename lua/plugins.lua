-- Claude's float belongs to the tab it was opened in, and claudecode.nvim focuses it
-- there (switching tabs). Close it in other tabs first so it reopens in this one.
-- The terminal buffer (and the Claude session) stays alive.
local function claude_here()
  local ok, term = pcall(require, "claudecode.terminal")
  local buf = ok and term.get_active_terminal_bufnr()
  if not buf then return end
  local tab = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if vim.api.nvim_win_get_tabpage(win) ~= tab then
      vim.api.nvim_win_hide(win)
    end
  end
end

local function claude_cmd(cmd)
  return function()
    claude_here()
    vim.cmd(cmd)
  end
end

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
  -- snacks: Claude's floating terminal + notification popups (replaces vim.notify)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = { notifier = { enabled = true } },
  },
  -- Claude Code IDE integration (same protocol as the VS Code extension)
  {
    "coder/claudecode.nvim",
    cmd = {
      "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSelectModel", "ClaudeCodeAdd",
      "ClaudeCodeSend", "ClaudeCodeTreeAdd", "ClaudeCodeStatus", "ClaudeCodeStart",
      "ClaudeCodeStop", "ClaudeCodeOpen", "ClaudeCodeClose", "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny", "ClaudeCodeCloseAllDiffs",
    },
    dependencies = { "folke/snacks.nvim" }, -- needed for the floating window
    opts = {
      -- Extra settings only for this Claude: hooks that notify back into Neovim (claude/notify.sh)
      terminal_cmd = "claude --settings " .. vim.fn.stdpath("config") .. "/claude/settings.json",
      terminal = {
        -- Start Claude in Neovim's global cwd (where it was launched), not the window's: Octo tabs
        -- `:lcd` into a submodule (see octo_in_repo in after/plugin/plugins_config.lua).
        cwd_provider = function() return vim.fn.getcwd(-1, -1) end,
        provider = "snacks",
        snacks_win_opts = {
          position = "float",
          width = 0.85,
          height = 0.85,
          border = "rounded",
          -- Snacks' default <Esc> handling (double-Esc -> normal mode) would eat
          -- Claude's own double-Esc (rewind). Plain pass-through is set below.
          keys = { term_normal = false },
        },
      },
    },
    init = function()
      -- Global terminal <Esc> drops to normal mode; Claude needs <Esc> (interrupt/cancel).
      -- Pass it through in Claude's terminal only. `jk` still leaves terminal mode.
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*claude*",
        callback = function(ev)
          vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = ev.buf, nowait = true, desc = "Claude: send Esc" })
        end,
      })

      -- Called over RPC by claude/notify.sh (Claude Code Stop/Notification hooks).
      -- Silent while you are in Claude's window: you already see it.
      _G.ClaudeNotify = function(event, msg)
        vim.schedule(function()
          local ok, term = pcall(require, "claudecode.terminal")
          if ok and term.get_active_terminal_bufnr() == vim.api.nvim_get_current_buf() then
            return
          end
          if event == "Stop" then
            vim.notify("Finished — <M-l> to view", vim.log.levels.INFO, { title = "Claude Code" })
          else
            vim.notify(msg ~= "" and msg or "Needs your input", vim.log.levels.WARN, { title = "Claude Code" })
          end
        end)
        return ""
      end
    end,
    keys = {
      { "<M-l>",      claude_cmd("ClaudeCodeFocus"), mode = { "n", "t", "v" }, desc = "Claude: focus/toggle" },
      { "<leader>ac", claude_cmd("ClaudeCode"),      desc = "Claude: toggle" },
      { "<leader>af", claude_cmd("ClaudeCodeFocus"), desc = "Claude: focus" },
      -- One Claude terminal per Neovim: `--resume` only applies when none is running,
      -- so if one is, switch conversation in place with Claude's /resume picker.
      {
        "<leader>ar",
        function()
          local term = require("claudecode.terminal")
          if term.get_active_terminal_bufnr() then
            claude_here()
            term.ensure_visible()
            term.send_to_terminal("/resume", { focus = true })
          else
            vim.cmd("ClaudeCode --resume")
          end
        end,
        desc = "Claude: switch/resume session"
      },
      {
        "<leader>an",
        function()
          local term = require("claudecode.terminal")
          if term.get_active_terminal_bufnr() then
            claude_here()
            term.ensure_visible()
            term.send_to_terminal("/clear", { focus = true })
          else
            vim.cmd("ClaudeCode")
          end
        end,
        desc = "Claude: new session"
      },
      { "<leader>aq", "<cmd>ClaudeCodeClose<cr>",         desc = "Claude: quit" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>",   desc = "Claude: continue last session" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>",   desc = "Claude: select model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",         desc = "Claude: add buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",          mode = "v",                            desc = "Claude: send selection" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",    desc = "Claude: accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",      desc = "Claude: deny diff" },
      { "<leader>aD", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Claude: close all diffs" },
      { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>",        desc = "Claude: status" },
    },
  },

  {
    "ThePrimeagen/99",
    enabled = false, -- unused; its <leader>9* mappings would conflict with <leader>9 (open all folds)
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
        model = "claude-sonnet-4-6",
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

      -- Rewrite visual selection (prompts for instructions)
      -- take extra note that i have visual selection only in v mode
      -- technically whatever your last visual selection is, will be used
      -- so i have this set to visual mode so i dont screw up and use an
      -- old visual selection
      vim.keymap.set("v", "<leader>9v", function()
        _99.visual()
      end)

      -- Agentic session: ask a question / give a task, results go to quickfix
      vim.keymap.set("n", "<leader>9b", function()
        _99.vibe()
      end)

      -- Search across project with a prompt, results go to quickfix
      vim.keymap.set("n", "<leader>9s", function()
        _99.search()
      end)

      --- Stop all in-flight requests
      vim.keymap.set("n", "<leader>9x", function()
        _99.stop_all_requests()
      end)

      -- Select model interactively
      vim.keymap.set("n", "<leader>9m", function()
        local Providers = require("99.providers")
        Providers.ClaudeCodeProvider.fetch_models(function(models, err)
          if err or not models then
            vim.notify("99: failed to fetch models: " .. (err or "unknown error"), vim.log.levels.ERROR)
            return
          end
          local current = _99.get_model()
          vim.ui.select(models, {
            prompt = "99 model (current: " .. current .. "):",
          }, function(choice)
            if choice then
              _99.set_model(choice)
              vim.notify("99: model set to " .. choice)
            end
          end)
        end)
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
    -- Shell install script: fzf#install isn't loaded yet when lazy runs the build
    build = "./install --bin",
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

  -- Octo: GitHub issues/PRs/reviews inside nvim (needs `gh` CLI authenticated)
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
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
  -- {
  --   "smoka7/multicursors.nvim",
  --   dependencies = {
  --     "smoka7/hydra.nvim"
  --   }
  -- },

  -- Latex
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_quickfix_mode = 0
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
  { "github/copilot.vim" },
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
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- use latest release, remove to use latest commit
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in 4.0.0
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
      },
      ui = {
        ignore_conceal_warn = true,
      }
    },
  },

  -- Mardown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  }
}
