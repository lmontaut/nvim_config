----------------------------
-- [[ Configure Packer ]] --
----------------------------
local has_packer, _ = pcall(require, 'packer')
if has_packer then
  vim.keymap.set("n", "<leader>Pc", "<CMD>PackerCompile<CR>", { desc = "Packer compile" })
  vim.keymap.set("n", "<leader>Pi", "<CMD>PackerInstall<CR>", { desc = "Packer install" })
  vim.keymap.set("n", "<leader>Pd", "<CMD>PackerClean<CR>", { desc = "Packer clean" })
  vim.keymap.set("n", "<leader>Ps", "<CMD>source %<CR>", { desc = "Source current file" })
end

----------------------------------
-- [[ Configure Comment.nvim ]] --
----------------------------------
local has_comment, comment = pcall(require, 'Comment')
if has_comment then
  comment.setup()
  vim.keymap.set("n", "\\", require('Comment.api').toggle.linewise.current, { desc = "Comment" })
  vim.keymap.set("v", "\\", "<ESC><CMD>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Comment" })
end

--------------------------------------
-- [[ Configure indent-blankline ]] --
--------------------------------------
-- See `:help indent_blankline.txt`
local has_indent_blankline, indent_blankline = pcall(require, 'indent_blankline')
if has_indent_blankline then
  indent_blankline.setup({
    char = '┊',
    show_trailing_blankline_indent = true,
    indent_blankline_use_treesitter = true,
    show_current_context = true,
  })
end

------------------------------
-- [[ Configure Gitsigns ]] --
------------------------------
-- See `:help gitsigns.txt`
local has_gitsigns, gitsigns = pcall(require, 'gitsigns')
if has_gitsigns then
  gitsigns.setup({})
end

-------------------------------
-- [[ Configure Telescope ]] --
-------------------------------
-- See `:help telescope` and `:help telescope.setup()`
local has_telescope, _ = pcall(require, "telescope")
if has_telescope then
  local actions = require "telescope.actions"
  local telescope = require("telescope")
  local telescopeConfig = require("telescope.config")

  -- Clone the default Telescope configuration
  local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
  -- I want to search in hidden/dot files.
  table.insert(vimgrep_arguments, "--files")
  table.insert(vimgrep_arguments, "--hidden")
  -- I don't want to search in the `.git` directory.
  table.insert(vimgrep_arguments, "--glob")
  table.insert(vimgrep_arguments, "!**/.git/*")
  local action_layout = require("telescope.actions.layout")
  telescope.setup({
    defaults = {
      layout_config = {
        vertical = {
          width = 0.9
        },
        horizontal = {
          width = 0.9
        },
      },
      theme = "dropdown",
      path_display = {
        "truncate"
      },
      dynamic_preview_title = true,
      layout_strategy = "vertical",
      mappings = {
        i = {
          ["jk"] = { "<cmd>startinsert<cr>j<cmd>startinsert<cr>k", type = "command" },
          ["kj"] = { "<cmd>stopinsert<cr>", type = "command" },

          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,

          ["<esc>"] = actions.close,

          ["<CR>"] = actions.select_default,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          -- Absolutely insane, you can refine your search
          ["<C-e>"] = actions.to_fuzzy_refine, -- in case C-space doesn't work
          -- ["<C-space>"] = actions.to_fuzzy_refine, -- already set to ctrl + space
          ["?"] = actions.which_key,

          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<C-c>"] = actions.edit_command_line,
          -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["<C-x>"] = actions.delete_buffer,
          ["<C-i>"] = action_layout.toggle_preview,

          -- Git related
          ["<C-H>"] = actions.cycle_previewers_prev,
          ["<C-L>"] = actions.cycle_previewers_next,
        },
        n = {
          ["<C-i>"] = action_layout.toggle_preview,
          ["<C-q>"] = actions.smart_send_to_loclist + actions.open_loclist,
        },
      },
    },
    vimgrep_arguments = vimgrep_arguments,
    pickers = {
      lsp_references = {
        fname_width = 150,
      },
      lsp_definitions = {
        fname_width = 150,
      },
      find_files = { -- Search ALL files, even if not tracked by git
        -- find_command = { "rg", "--files", "--hidden", },
        -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      },
    },
  })

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
  vim.keymap.set('n', '<leader>,', require('telescope.builtin').buffers, { desc = 'Find buffer' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').git_files, { desc = 'Find git file' })
  vim.keymap.set('n', '<leader>s:', require('telescope.builtin').command_history, { desc = 'Search command history' })
  vim.keymap.set('n', '<leader>sC', require('telescope.builtin').commands, { desc = 'Search all vim commands' })
  vim.keymap.set('n', '<leader>sq', require('telescope.builtin').quickfix, { desc = 'Search in quickfix' })
  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>r', "<CMD>Telescope resume<CR>", { desc = 'Telescope resume' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = 'Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = 'Search files' })
  vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = 'Search keymaps' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = 'Search current word' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = 'Grep in directory' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = 'Search diagnostics' })
  vim.keymap.set('n', '<leader>sc', require('telescope.builtin').git_commits, { desc = 'Search git commits' })
  vim.keymap.set('n', '<leader>sm', require('telescope.builtin').man_pages, { desc = 'Search man pages' })
  vim.keymap.set('n', '<leader>8', require('telescope.builtin').reloader, { desc = 'Reload vim modules' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').search_history, { desc = 'Search history' })
  vim.keymap.set('n', '<leader>sl', require('telescope.builtin').lsp_incoming_calls, { desc = 'Search LSP incoming calls' })
  vim.keymap.set('n', '<leader>sL', require('telescope.builtin').lsp_outgoing_calls, { desc = 'Search LSP outgoing calls' })
  -- Quickfix list interaction
  vim.keymap.set('n', '<leader>sQ', require('telescope.builtin').quickfixhistory, { desc = 'Search quickfix history' })
  vim.keymap.set('n', '<leader>qh', require('telescope.builtin').quickfixhistory, { desc = 'Quickfix history' })
  vim.keymap.set('n', '<leader>qt', require('telescope.builtin').quickfix, { desc = 'Telescope quickfix' })
end

------------------------------
-- [[ Configure Chadtree ]] --
------------------------------
local has_chadtree, _ = pcall(require, "chadtree")
if has_chadtree then
  vim.keymap.set('n', '<leader>e', '<CMD>CHADopen<CR>', { desc = 'File browser' })
end

--------------------------------
-- [[ Configure Treesitter ]] --
--------------------------------
-- See `:help nvim-treesitter`
local has_treesitter, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if has_treesitter then
  treesitter_configs.setup({
    -- Add languages to be installed here that you want installed for treesitter
    -- ensure_installed = { 'c', 'cpp', 'cmake', 'lua', 'python', 'rust', 'help', 'vim' },
    ensure_installed = { 'c', 'cpp', 'cmake', 'lua', 'python', 'rust', 'vim' },

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<leader>ee',
        node_incremental = '<leader>en',
        node_decremental = '<leader>ep',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      -- swap = {
      --   enable = false,
      --   swap_next = {
      --     ['<leader>a'] = '@parameter.inner',
      --   },
      --   swap_previous = {
      --     ['<leader>A'] = '@parameter.inner',
      --   },
      -- },
    },
  })

  -- needs treesitter to be installed
  -- vim.opt.foldmethod = "expr"
  -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end

-- [[ Configure nvim-cmp ]]
local has_cmp, cmp = pcall(require, 'cmp')
local has_luasnip, luasnip = pcall(require, 'luasnip')

-- cmp_is_on = false
if has_cmp then
  local ELLIPSIS_CHAR = '…'
  local MAX_LABEL_WIDTH = 30

  local get_ws = function (max, len)
    return (" "):rep(max - len)
  end

  local format = function(_, item)
    local content = item.abbr
    if #content > MAX_LABEL_WIDTH then
      item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
    else
      item.abbr = content .. get_ws(MAX_LABEL_WIDTH, #content)
    end

    return item
  end

  vim.cmd[[
    highlight GhostText gui=bold guifg=#282c34 guibg=#98c379
  ]]

  local cmp_mappings = {
    -- Scroll docs down
    ['<C-d>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.scroll_docs(4)
      end
        fallback()
      end, { 'i' }),
    -- Scroll docs up
    ['<C-u>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.scroll_docs(-4)
      end
        fallback()
      end, { 'i' }),
    -- Abort completion
    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.abort()
      end
        fallback()
      end, { 'i', 'c' }),
    -- Invoke completion
    ['<Tab>'] = cmp.mapping(function()
        cmp.complete()
      end, { 'i', 'c' }),
    -- Close completion window
    ['<S-Tab>'] = cmp.mapping(function()
      cmp.close()
      end, { 'i', 'c' }),
    -- Next completion item
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.select_next_item()
      end
        fallback()
      end, { 'i', 'c' }),
    -- Previous completion item
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.select_prev_item()
      end
        fallback()
      end, { 'i', 'c' }),
    -- Confirm completion
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        return cmp.confirm({ select = true })
      end
        fallback()
      end, { 'i', 'c' }),
  }

  cmp.setup({
    completion = {
      autocomplete = false -- autocomplete will only appear when I ask it to
    },
    snippet = {
      expand = function(args)
        if has_luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    mapping = cmp_mappings,
    formatting = {
      format = format,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
        { name = 'path' },
        { name = 'cmdline' },
      }),
    experimental = {
      ghost_text = { hl_group = 'GhostText' }
    }
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp_mappings,
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp_mappings,
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
        { name = 'cmdline' }
      })
  })

  cmp.setup.filetype('vim', {
    mapping = cmp_mappings,
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
        { name = 'cmdline' }
      })
  })
end

-------------------------
-- [[ Configure LSP ]] --
-------------------------
--  This function gets run when an LSP connects to a particular buffer.
local util = require("lspconfig.util")
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  if client.server_capabilities.signatureHelpProvider then
    local has_lspoverloads, lspoverloads = pcall(require, "lsp-overloads")
    if has_lspoverloads then
      lspoverloads.setup(client, {
        keymaps = {
          next_signature = "<C-j>",
          previous_signature = "<C-k>",
          next_parameter = "<C-l>",
          previous_parameter = "<C-h>",
          close_signature = "<C-s>"
        },
      })
    end
    vim.api.nvim_set_keymap("n", "<C-s>", ":LspOverloadsSignature<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>LspOverloadsSignature<CR>", { noremap = true, silent = true })
  end
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local imap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('i', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>lc', vim.lsp.buf.code_action, 'Code action')

  -- nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
  nmap('gd', require('telescope.builtin').lsp_definitions, 'Goto definition')
  nmap('gD', require('telescope.builtin').lsp_implementations, 'Goto implementation')
  nmap('gt', require('telescope.builtin').lsp_type_definitions, 'Goto type definitions')
  nmap('gh', "<CMD>ClangdSwitchSourceHeader<CR>", 'Switch from source to header')
  nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
  -- nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
  nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
  nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')
  nmap('<leader>ld', require('telescope.builtin').diagnostics, 'Diagnostics')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-x>', vim.lsp.buf.signature_help, 'Signature Documentation')
  imap('<C-x>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wl', function()
  -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local pythonpath = os.getenv("CONDA_PREFIX") .. "/bin/python"
local servers = {
  -- clangd = {
    -- arguments = {"--compile-commands-dir=./build"}
  -- },
  lua_ls = {},
  -- cmake = {},
  neocmake = {},
  rust_analyzer = {},
  -- gopls = {},
  pyright = {
    python = {
      pythonPath = pythonpath,
      analysis = {
        typeCheckingMode = "off",
      }
    }
  },
  -- tsserver = {},
}

-- Setup neovim lua configuration
local has_neodev, neodev = pcall(require, "neodev")
if has_neodev then
  neodev.setup({
    library = { plugins = { "nvim-dap-ui" }, types = true }, -- To have type checking in dap-ui
  })
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end
-- capabilities.textDocument.foldingRange = {
--   dynamicRegistration = false,
--   lineFoldingOnly = true
-- }

-- Looks of the LSP
local signs = {
  -- { name = "DiagnosticSignError", text = "" },
  -- { name = "DiagnosticSignWarn", text = "" },
  -- { name = "DiagnosticSignHint", text = "" },
  -- { name = "DiagnosticSignInfo", text = "" },
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn",  text = "" },
  { name = "DiagnosticSignHint",  text = "" },
  { name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = false,
  underline = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(config)
vim.lsp.diagnostics_config = config

---------------------------
-- [[ Configure Mason ]] --
---------------------------
-- Setup mason so it can manage external tooling
local has_mason, mason = pcall(require, "mason")
local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if has_mason then
  mason.setup()

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers({
    function(server_name)
      if has_lspconfig then
        lspconfig[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        })
      end
    end,
  })
end

if has_lspconfig and false then
  lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp" },
    cmd = { "/usr/bin/clangd --compile-commands-dir=./build" },
    -- cmd = { "/usr/bin/clangd" },
    root_dir = util.root_pattern('compile_commands.json', '.git', '.clangd'),
  })
end

if has_lspconfig and false then
  lspconfig.ccls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp" },
    root_dir = util.root_pattern('compile_commands.json', '.git', '.ccls'),
    init_options = {
      index = {
        threads = 0;
      };
      clang = {
        excludeArgs = { "-frounding-math" },
      },
    }
  })
end


if has_lspconfig then
  local pid = vim.fn.getpid()
  local omnisharp_bin = "/Users/louis/software/misc/omnisharp-osx/run"

  lspconfig.omnisharp.setup({
      cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
      on_attach = on_attach;
      capabilities = capabilities;

      -- Enables support for reading code style, naming convention and analyzer
      -- settings from .editorconfig.
      enable_editorconfig_support = true;

      -- If true, MSBuild project system will only load projects for files that
      -- were opened in the editor. This setting is useful for big C# codebases
      -- and allows for faster initialization of code navigation features only
      -- for projects that are relevant to code that is being edited. With this
      -- setting enabled OmniSharp may load fewer projects and may thus display
      -- incomplete reference lists for symbols.
      enable_ms_build_load_projects_on_demand = false;

      -- Enables support for roslyn analyzers, code fixes and rulesets.
      enable_roslyn_analyzers = false;

      -- Specifies whether 'using' directives should be grouped and sorted during
      -- document formatting.
      organize_imports_on_format = false;

      -- Enables support for showing unimported types and unimported extension
      -- methods in completion lists. When committed, the appropriate using
      -- directive will be added at the top of the current file. This option can
      -- have a negative impact on initial completion responsiveness,
      -- particularly for the first few completion sessions after opening a
      -- solution.
      enable_import_completion = false;

      -- Specifies whether to include preview versions of the .NET SDK when
      -- determining which version to use for project loading.
      sdk_include_prereleases = true;

      -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
      -- true
      analyze_open_documents_only = false;
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local function toSnakeCase(str)
        return string.gsub(str, "%s*[- ]%s*", "_")
      end

      if client.name == 'omnisharp' then
        local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
        for i, v in ipairs(tokenModifiers) do
          tokenModifiers[i] = toSnakeCase(v)
        end
        local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
        for i, v in ipairs(tokenTypes) do
          tokenTypes[i] = toSnakeCase(v)
        end
      end
    end,
  })
end

----------------------------
-- [[ Configure fidget ]] --
----------------------------
-- Turn on lsp status information
local has_fidget, _ = pcall(require, "fidget")
if has_fidget then
  require('fidget').setup()
end

-----------------------------
-- [[ Configure Project ]] --
-----------------------------
local has_project, project = pcall(require, "project_nvim")
if has_project then
  project.setup({
    -- Manual mode doesn't automatically change your root directory, so you have
    -- the option to manually do so using `:ProjectRoot` command.
    manual_mode = false,
    -- Methods of detecting the root directory. **"lsp"** uses the native neovim
    -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
    -- order matters: if one is not detected, the other is used as fallback. You
    -- can also delete or rearangne the detection methods.
    -- detection_methods = { "lsp", "pattern" },
    detection_methods = { "pattern" },
    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods
    -- patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
    patterns = { ".git", "package.json" },
    -- Table of lsp clients to ignore by name
    -- eg: { "efm", ... }
    -- ignore_lsp = {},
    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    -- exclude_dirs = {},
    -- Show hidden files in telescope
    show_hidden = true,
    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = false,
  })

  -- Telescope integration
  if has_telescope then
    require('telescope').load_extension('projects')
    vim.keymap.set('n', '<leader>sp', "<CMD>Telescope projects<CR>", { desc = 'Open project...' })
  end
end

--------------------------------
-- [[ Configure bufferline ]] --
--------------------------------
local has_bufferline, bufferline = pcall(require, "bufferline")
if has_bufferline then
  bufferline.setup()
  -- vim.keymap.set('n', '<C-]>', "<CMD>BufferLineCycleNext<CR>", { desc = 'Next buffer' })
  -- vim.keymap.set('n', '<C-[>', "<CMD>BufferLineCyclePrev<CR>", { desc = 'Previous buffer' })
end

-----------------------------
-- [[ Configure lualine ]] --
-----------------------------
local has_lualine, lualine = pcall(require, "lualine")
if has_lualine then
  local mode = {
    function()
      return " "
    end,
    padding = { left = 0, right = 0 },
    color = {},
    cond = nil,
  }

  local branch = {
    "branch",
    icon = "",
    color = { gui = "bold" },
    icons_enabled = true,
  }

  local filename = {
    'filename',
    file_status = true,      -- Displays file status (readonly status, modified status)
    path = 1,                -- 0: Just the filename
                             -- 1: Relative path
                             -- 2: Absolute path
                             -- 3: Absolute path, with tilde as the home directory

    shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                             -- for other components. (terrible name, any suggestions?)
    symbols = {
      modified = '[+]',      -- Text to show when the file is modified.
      readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
      unnamed = '[No Name]', -- Text to show for unnamed buffers.
    }
  }

  local window_width_limit = 70
  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > window_width_limit
    end,
    -- check_git_workspace = function()
    --   local filepath = vim.fn.expand "%:p:h"
    --   local gitdir = vim.fn.finddir(".git", filepath .. ";")
    --   return gitdir and #gitdir > 0 and #gitdir < #filepath
    -- end,
  }

  local green = "#98be65"

  local python_env = {
    function()
      local utils = require "utils"
      -- if vim.bo.filetype == "python" or vim.bo.filetype == "cpp" then
      local venv = os.getenv "CONDA_DEFAULT_ENV"
      if venv then
        return string.format("  (%s)", utils.env_cleanup(venv))
      end
      venv = os.getenv "VIRTUAL_ENV"
      if venv then
        return string.format("  (%s)", utils.env_cleanup(venv))
      end
      return ""
      -- end
      -- return ""
    end,
    color = {fg = green},
    cond = conditions.hide_in_width,
  }

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    color = {},
    cond = conditions.hide_in_width,
  }

  local diff = {
    "diff",
    colored = true,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = conditions.hide_in_width
  }

  local treesitter = {
    function()
      local b = vim.api.nvim_get_current_buf()
      if next(vim.treesitter.highlighter.active[b]) then
        return ""
      end
      return ""
    end,
    cond = conditions.hide_in_width,
  }

  local lsp = {
    function(msg)
      msg = msg or "LS Inactive"
      local buf_clients = vim.lsp.get_active_clients()
      if next(buf_clients) == nil then
        -- TODO: clean up this if statement
        if type(msg) == "boolean" or #msg == 0 then
          return "LS Inactive"
        end
        return msg
      end
      -- local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end

      -- TODO: add formatter
      -- local formatters = require "config.plugins_config.formatters"
      -- local supported_formatters = formatters.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_formatters)

      -- TODO: add linter
      -- local linters = require "config.plugins_config.linters"
      -- local supported_linters = linters.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_linters)

      return "[" .. table.concat(buf_client_names, ", ") .. "]"
    end,
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  }

  -- cool function for progress
  local progress = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "startify" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { mode },
      lualine_b = { branch, filename, diff },
      lualine_c = { python_env },
      lualine_x = { diagnostics, treesitter, lsp },
      lualine_y = { "fileformat", "filetype" },
      lualine_z = { progress },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {"quickfix", "fugitive", "nvim-dap-ui", "symbols-outline", "chadtree"},
  })
end

-------------------------------------
-- [[ Configure symbols outline ]] --
-------------------------------------
local has_symbols_outline, symbols_outline = pcall(require, "symbols-outline")
if has_symbols_outline then
  symbols_outline.setup({
    show_guides = true,
    auto_preview = false,
    position = 'right',
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    autofold_depth = 1,
    auto_unfold_hover = true,
    keymaps = {
      close = {"<Esc>", "q"},
      goto_location = "<Cr>",
      focus_location = "o",
      hover_symbol = "<C-space>",
      toggle_preview = "K",
      rename_symbol = "r",
      code_actions = "a",
      fold = "h",
      fold_all = "H",
      unfold = "l",
      unfold_all = "L",
      fold_reset = "R",
    },
    symbols = {
      File = { icon = "", hl = "@text.uri" },
      Module = { icon = "", hl = "@namespace" },
      Namespace = { icon = "", hl = "@namespace" },
      Package = { icon = "", hl = "@namespace" },
      Class = { icon = "𝓒", hl = "@type" },
      Method = { icon = "ƒ", hl = "@method" },
      Property = { icon = "", hl = "@method" },
      Field = { icon = "ғ", hl = "@field" },
      Constructor = { icon = "", hl = "@constructor" },
      Enum = { icon = "ℰ", hl = "@type" },
      Interface = { icon = "ﰮ", hl = "@type" },
      Function = { icon = "", hl = "@function" },
      Variable = { icon = "", hl = "@constant" },
      Constant = { icon = "", hl = "@constant" },
      String = { icon = "𝓐", hl = "@string" },
      Number = { icon = "#", hl = "@number" },
      Boolean = { icon = "⊨", hl = "@boolean" },
      Array = { icon = "", hl = "@constant" },
      Object = { icon = "⦿", hl = "@type" },
      Key = { icon = "🔐", hl = "@type" },
      Null = { icon = "NULL", hl = "@type" },
      EnumMember = { icon = "", hl = "@field" },
      Struct = { icon = "𝓢", hl = "@type" },
      Event = { icon = "є", hl = "@type" },
      Operator = { icon = "+", hl = "@operator" },
      TypeParameter = { icon = "𝙏", hl = "@parameter" },
      Component = { icon = "к", hl = "@function" },
      Fragment = { icon = "Ґ", hl = "@constant" },
    },
  })
  vim.keymap.set('n', '<leader>I', "<CMD>SymbolsOutline<CR>", { desc = 'Symbols outline' })
end

-------------------------------
-- [[ Configure vim-ccls ]] --
-------------------------------
-- vim.keymap.set('n', "<leader>ed", ":CclsDerivedHierarchy -float<CR>", { desc = "Derived hierarchy" })
-- vim.keymap.set('n', "<leader>eb", ":CclsBaseHierarchy -float<CR>", { desc = "Base hierarchy" })
-- vim.keymap.set('n', "<leader>ec", ":CclsCallHierarchy -float<CR>", { desc = "Functions calling the item under cursor" })
-- vim.keymap.set('n', "<leader>eC", ":CclsCalleeHierarchy -float<CR>", { desc = "Functions called by item under cursor" })
-- vim.keymap.set('n', "<leader>ef", ":CclsMemberFunctions<CR>", { desc = "Functions members of item under cursor" })

------------------------------
-- [[ Configure fugitive ]] --
------------------------------
vim.keymap.set('n', '<leader>gG', '<CMD>vertical rightbelow Git<CR>', { desc = 'Git status fugitive' })
-- vim.keymap.set('n', '<leader>gG', '<CMD>vertical rightbelow Git<CR>:vertical resize 80<CR>', { desc = 'Git status (half screen)' })
vim.keymap.set('n', '<leader>gC', '<CMD>vertical rightbelow Git log --oneline<CR>', { desc = 'Git short log' })
vim.keymap.set('n', '<leader>gL', '<CMD>rightbelow vsplit | Gclog<CR>', { desc = 'Git log (fugitive)' })
vim.keymap.set('n', '<leader>gj', '<CMD>Gitsigns next_hunk<CR>', { desc = 'Next hunk' })
vim.keymap.set('n', '<leader>gk', '<CMD>Gitsigns prev_hunk<CR>', { desc = 'Previous hunk' })
vim.keymap.set('n', '<leader>gc', '<CMD>Git commit -v -q<CR>', { desc = 'Git commit' })
vim.keymap.set('n', '<leader>gf', ':Git fetch<Space>', { desc = 'Git fetch', silent = false })
vim.keymap.set('n', '<leader>gp', ':Git pull<Space>', { desc = 'Git pull', silent = false })
vim.keymap.set('n', '<leader>gP', ':Git push<Space>', { desc = 'Git push', silent = false })
vim.keymap.set('n', '<leader>ga', ':Git add %<Space>', { desc = 'Git stage file', silent = false })
vim.keymap.set('n', '<leader>gS', ':Git reset %<Space>', { desc = 'Git unstage file', silent = false })
vim.keymap.set({ 'n', 'v' }, '<leader>gs', '<CMD>Gitsigns stage_hunk<CR>', { desc = 'Git stage hunk' })
vim.keymap.set({ 'n', 'v' }, '<leader>gS', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = 'Git unstage hunk' })
vim.keymap.set('n', '<leader>gd', '<CMD>Gdiffsplit<CR>', { desc = 'Git file diff' })
vim.keymap.set('n', '<leader>gm', '<CMD>Gdiffsplit!<CR>', { desc = 'Git solve conflicts' })
vim.keymap.set('n', '<leader>g[', '<CMD>diffget //2<CR>', { desc = 'Git conflict select target (left/up)' })
vim.keymap.set('n', '<leader>g]', '<CMD>diffget //3<CR>', { desc = 'Git conflict select source (right/down)' })
vim.keymap.set({ 'n', 'v' }, '<leader>gr', '<CMD>Gitsigns reset_hunk<CR>', { desc = 'Git reset hunk' })
vim.keymap.set('n', '<leader>gR', '<CMD>Gitsigns reset_buffer<CR>', { desc = 'Git reset buffer' })
vim.keymap.set('n', '<leader>gt', '<CMD>Gitsigns toggle_current_line_blame<CR>', { desc = 'Git toggle blame line' })
vim.keymap.set('n', '<leader>gu', require('telescope.builtin').git_stash, { desc = 'Git stashes' })
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gl', require('telescope.builtin').git_commits, { desc = 'Git log' })
vim.keymap.set('n', '<leader>gB', '<CMD>GBrowse<CR>', { desc = 'Git open remote' })

-------------------------------
-- [[ Configure vim-sneak ]] --
-------------------------------
vim.cmd [[
  nmap f <Plug>Sneak_f
  nmap F <Plug>Sneak_F
  let g:sneak#use_ic_scs = 1
]]

------------------------------
-- [[ Configure undotree ]] --
------------------------------
vim.keymap.set('n', "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo history" })

-------------------------
-- [[ Configure Pap ]] --
-------------------------
local has_pap, pap = pcall(require, "pap")
if has_pap then
  vim.cmd("autocmd Filetype pap-output nnoremap <silent> <buffer> <CR> :cg<Space>".. pap.dumpfile .. "<CR>'B")
  -- vim.cmd("autocmd Filetype pap-output nnoremap <silent> <buffer> q :cg<Space>".. pap.dumpfile .. "<CR>'B")
  vim.cmd("autocmd Filetype pap-output nnoremap <silent> <buffer> <leader>qq :cg<Space>" .. pap.dumpfile .. "<CR>:cc<CR>")

  vim.api.nvim_create_user_command('Papcmd', function(command) pap.set_cmd(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Pap', function(command) pap.run_cmd(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Paphsize', function(command) pap.set_window_hsize(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Papvsize', function(command) pap.set_window_vsize(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('PapSetHorizontal', function() pap.set_horizontal_window() end, {})
  vim.api.nvim_create_user_command('PapSetVertical', function() pap.set_vertical_window() end, {})
  vim.api.nvim_create_user_command('Paprun', function(command) pap.run_custom_cmd(command.args, false) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Par', function(command) pap.run_custom_cmd(command.args, false) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Paprerun', function() pap.run_custom_cmd("_last", false) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Papa', function(command) pap.run_custom_cmd(command.args, false) end, { nargs = "*" })
  vim.keymap.set("n", "<leader>qe", ":cg<Space>~/.cache/nvim/pap_output.txt<CR>:cc<CR>", { noremap = true, silent = true, desc = "Load error file into quickfix" })
  vim.keymap.set("n", "<leader>psh", ":Paphsize<CR>", { noremap = true, silent = true, desc = "Set pap horizontal window size" })
  vim.keymap.set("n", "<leader>psv", ":Papvsize<CR>", { noremap = true, silent = true, desc = "Set pap vertical window size" })
  vim.keymap.set("n", "<leader>pr", ":Paprun<CR>",  { noremap = true, silent = true, desc = "Paprun (any cmd)" })
  vim.keymap.set("n", "<leader>pR", ":Paprerun<CR>",  { noremap = true, silent = true, desc = "Pap rerun last cmd" })
  vim.keymap.set("n", "<leader>pc", ":Papcmd<CR>",  { noremap = true, silent = true, desc = "Set pap default cmd" })
  vim.keymap.set("n", "<leader>pp", ":Pap<space>",  { noremap = true, silent = false, desc = "Pap (prefix default cmd)" })
  vim.keymap.set("n", "<leader>pl", ":!just --list<CR>", { noremap = true, silent = false, desc = "List Just recipes" })
  vim.keymap.set("n", "<leader>pv", ":PapSetVertical<CR>",  { noremap = true, silent = false, desc = "Pap set vertical mode" })
  vim.keymap.set("n", "<leader>ph", ":PapSetHorizontal<CR>",  { noremap = true, silent = false, desc = "Pap set horizontal mode" })

  --
  -- CMake related
  --
  -- Cmake cache
  -- vim.keymap.set("n", "<leader>cmr", ":rightbelow 180 vsplit | terminal ccmake builds/build-release-$(echo $CONDA_DEFAULT_ENV)/*", { noremap = true, silent = false, desc = "Change release CMakeCache" })
  -- vim.keymap.set("n", "<leader>cmd", ":rightbelow 180 vsplit | terminal ccmake builds/build-debug-$(echo $CONDA_DEFAULT_ENV)/*", { noremap = true, silent = false, desc = "Change debug CMakeCache" })
  -- -- Create build folders
  -- vim.keymap.set("n", "<leader>cBr", ":Paprun mkdir builds/build-release-$(echo $CONDA_DEFAULT_ENV)", { noremap = true, silent = false, desc = "Create release build folder" })
  -- vim.keymap.set("n", "<leader>cBd", ":Paprun mkdir builds/build-debug-$(echo $CONDA_DEFAULT_ENV)", { noremap = true, silent = false, desc = "Create debug build folder" })
  -- -- Deleting build folders
  -- vim.keymap.set("n", "<leader>crr", ":Paprun rm -rf builds/build-release-$(echo $CONDA_DEFAULT_ENV)/*", { noremap = true, silent = false, desc = "Delete release build folder" })
  -- vim.keymap.set("n", "<leader>crd", ":Paprun rm -rf builds/build-debug-$(echo $CONDA_DEFAULT_ENV)/*", { noremap = true, silent = false, desc = "Delete debug build folder" })
  -- -- Build cmake files
  -- vim.keymap.set("n", "<leader>cbr", ":Paprun cmake -S . -C ~/.config/cmake/release_config.cmake -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX -DCMAKE_SYSTEM_PREFIX_PATH=$CONDA_PREFIX -B builds/build-release-$(echo $CONDA_DEFAULT_ENV)", { noremap = true, silent = false, desc = "Build release" })
  -- vim.keymap.set("n", "<leader>cbd", ":Paprun cmake -S . -C ~/.config/cmake/debug_config.cmake -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX -DCMAKE_SYSTEM_PREFIX_PATH=$CONDA_PREFIX -B builds/build-debug-$(echo $CONDA_DEFAULT_ENV)", { noremap = true, silent = false, desc = "Build debug" })
  -- -- List cmake targets
  -- vim.keymap.set("n", "<leader>clr", ":Paprun cmake --build builds/build-release-$(echo $CONDA_DEFAULT_ENV) --target help", { noremap = true, silent = false, desc = "List targets release" })
  -- vim.keymap.set("n", "<leader>cld", ":Paprun cmake --build builds/build-debug-$(echo $CONDA_DEFAULT_ENV) --target help", { noremap = true, silent = false, desc = "List targets debug" })
  -- -- Compile target
  -- vim.keymap.set("n", "<leader>ccr", ":Paprun cmake --build builds/build-release-$(echo $CONDA_DEFAULT_ENV) --target  -j10<left><left><left><left><left>", { noremap = true, silent = false, desc = "Compile release target" })
  -- vim.keymap.set("n", "<leader>ccd", ":Paprun cmake --build builds/build-debug-$(echo $CONDA_DEFAULT_ENV) --target  -j10<left><left><left><left><left>", { noremap = true, silent = false, desc = "Compile debug target" })
  -- -- Compile all
  -- vim.keymap.set("n", "<leader>car", ":Paprun cmake --build builds/build-release-$(echo $CONDA_DEFAULT_ENV) --target all -j10", { noremap = true, silent = false, desc = "Compile all (release)" })
  -- vim.keymap.set("n", "<leader>cad", ":Paprun cmake --build builds/build-debug-$(echo $CONDA_DEFAULT_ENV) --target all -j10", { noremap = true, silent = false, desc = "Compile all (debug)" })
  -- -- Install
  -- vim.keymap.set("n", "<leader>cir", ":Paprun cmake --build builds/build-release-$(echo $CONDA_DEFAULT_ENV) --target install -j10", { noremap = true, silent = false, desc = "Install (release)" })
  -- vim.keymap.set("n", "<leader>cid", ":Paprun cmake --build builds/build-debug-$(echo $CONDA_DEFAULT_ENV) --target install -j10", { noremap = true, silent = false, desc = "Install (debug)" })
  -- -- Link compile commands
  -- vim.keymap.set("n", "<leader>cLr", ":Paprun ln -sf builds/build-release-$(echo $CONDA_DEFAULT_ENV)/compile_commands.json ./", { noremap = true, silent = false, desc = "Link release compile_commands.json" })
  -- vim.keymap.set("n", "<leader>cLd", ":Paprun ln -sf builds/build-debug-$(echo $CONDA_DEFAULT_ENV)/compile_commands.json ./", { noremap = true, silent = false, desc = "Link debug compile_commands.json" })
  -- -- Ctest
  -- vim.keymap.set("n", "<leader>ctr", ":Paprun ctest --output-on-failure -j10 --test-dir builds/build-release-$(echo $CONDA_DEFAULT_ENV)", { noremap = true, silent = false, desc = "Run release tests" })
  -- vim.keymap.set("n", "<leader>ctd", ":Paprun ctest --output-on-failure -j10 --test-dir builds/build-debug-$(echo $CONDA_DEFAULT_ENV)", { noremap = true, silent = false, desc = "Run debug tests" })
  -- -- Ctest rerun failed
  -- vim.keymap.set("n", "<leader>cTr", ":Paprun ctest --output-on-failure -j10 --test-dir builds/build-release-$(echo $CONDA_DEFAULT_ENV) --rerun-failed", { noremap = true, silent = false, desc = "Rerun failed release tests" })
  -- vim.keymap.set("n", "<leader>cTd", ":Paprun ctest --output-on-failure -j10 --test-dir builds/build-debug-$(echo $CONDA_DEFAULT_ENV) --rerun-failed", { noremap = true, silent = false, desc = "Rerun failed release tests" })
end

-------------------------
-- [[ Configure DAP ]] --
-------------------------
-- Helper to setup stuff:
-- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook
local has_dap, dap = pcall(require, 'dap')
local dapopts = { silent = true, noremap = true }
if has_dap then
  local dap_breakpoint = {
    breakpoint = {
      -- text = "🛑",
      text = "",
      texthl = "DapUIModifiedValue",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "",
      texthl = "DapUIModifiedValue",
      linehl = "DiffText",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "ALEErrorSign",
      linehl = "SpellBad",
      numhl = "",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
  vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

  dap.adapters.lldb = {
    type = "executable",
    command = "/opt/homebrew/Cellar/llvm/16.0.6/bin/lldb-vscode", -- Adjust depdending on llvm version
    name = "lldb"
  }

  dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = 13000
  }

  -- C/C++/Rust config
  dap.configurations.cpp = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input({
          prompt = "[Path to executable] > ",
          default = vim.fn.getcwd() .. '/',
          completion = "file",
          cancelreturn = ""
        })
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      reverseDebugging = true, -- Not available on bare metal
      runInTerminal=true -- So that the program's output is displayed in console
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

  -- Python config
  dap.adapters.python = {
    type = 'executable';
    command = os.getenv("CONDA_PREFIX") .. "/bin/python", -- adjust as needed
    args = { '-m', 'debugpy.adapter' };
  }

  dap.configurations.python = {
    {
      -- The first three options are required by nvim-dap
      type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = 'launch';
      name = "Launch file";

      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

      program = "${file}"; -- This configuration will launch the current file if used.
      pythonPath = os.getenv("CONDA_PREFIX") .. "/bin/python",
      console="integratedTerminal", -- So that the program's output is displayed in console
      redirectOutput=true -- So that the program's output is displayed in console
    },
  }

  dap.defaults.fallback.external_terminal = {
    command = '/Applications/Alacritty.app/Contents/MacOS/alacritty';
    args = {'-e'};
  }

  -- keymaps
  -- TODO: attach to running debugger
  --
  -- vim.keymap.set('n', "<F5>", function() dap.continue() end, { desc = "Launch/continue", dapopts.args })
  vim.keymap.set('n', "<leader>dl", function() dap.continue() end, { desc = "Launch/continue", dapopts.args })
  vim.keymap.set('n', "<leader>dL", function() dap.reverse_continue() end, { desc = "Reverse continue", dapopts.args })
  --
  vim.keymap.set('n', "<leader>dq", function()
    dap.disconnect()
    vim.cmd("stopinsert")
  end, { desc = "Disconnect/quit", dapopts.args })
  --
  vim.keymap.set('n', "<leader>dR", function() dap.restart() end, { desc = "Restart", dapopts.args })
  --
  -- vim.keymap.set('n', "<leader>dL", function() dap.run_last() end, { desc = "Run last", dapopts.args }) -- possibly needed if using .json configs
  --
  -- vim.keymap.set('n', "<F9>", function() dap.step_over() end, { desc = "Step over", dapopts.args })
  -- vim.keymap.set('n', 'L', function() dap.step_over() end, { desc = "Step over (or L)", nowait = true, dapopts.args })
  vim.keymap.set('n', "<leader>dsj", function() dap.step_over() end, { desc = "Step over", dapopts.args })
  --
  -- vim.keymap.set('n', "<F7>", function() dap.step_back() end, { desc = "Step back", dapopts.args })
  -- vim.keymap.set('n', 'H', function() dap.step_back() end, { desc = "Step back (or H)", nowait = true, dapopts.args })
  vim.keymap.set('n', "<leader>dsk", function() dap.step_back() end, { desc = "Step back", dapopts.args })
  --
  -- vim.keymap.set('n', "<F8>", function() dap.step_into() end, { desc = "Step into", dapopts.args })
  -- vim.keymap.set('n', '}', function() dap.step_into() end, { desc = "Step into", dapopts.args })
  vim.keymap.set('n', "<leader>dsi", function() dap.step_into() end, { desc = "Step into (or '}')", dapopts.args })
  --
  -- vim.keymap.set('n', "<F10>", function() dap.step_out() end, { desc = "Step out", dapopts.args })
  -- vim.keymap.set('n', '{', function() dap.step_out() end, { desc = "Step out", dapopts.args })
  vim.keymap.set('n', "<leader>dso", function() dap.step_out() end, { desc = "Step out (or '{')", dapopts.args })
  --
  vim.keymap.set('n', "<leader>dn", function() dap.run_to_cursor() end, { desc = "Debug until cursor", dapopts.args })
  --
  -- vim.keymap.set('n', ')', function() dap.down() end, { desc = "Down stacktrace", dapopts.args })
  --
  -- vim.keymap.set('n', '(', function() dap.up() end, { desc = "Up stacktrace", dapopts.args })
  --
  vim.keymap.set('n', "<Leader>dp", function() dap.pause() end, { desc = "Pause", dapopts.args })
  --
  vim.keymap.set('n', "<Leader>dk", function() dap.toggle_breakpoint() end, { desc = "Breakpoint", dapopts.args })
  vim.keymap.set('n', "<Leader>dK", function()
    dap.set_breakpoint(vim.fn.input({
        prompt = "[Condition] > ",
        default = "",
        cancelreturn = ""
      })
    ) end, { desc = "Breakpoint set condition", dapopts.args })
  vim.keymap.set('n', "<Leader>dD", function() dap.clear_breakpoints() end, { desc = "Clear breakpoints", dapopts.args })
  --
  vim.keymap.set('n', "<Leader>dr", function() dap.repl.toggle() end, { desc = "REPL toggle", dapopts.args })
  --
  -- vim.keymap.set({'n', 'v'}, "|", "<CMD>lua require('dapui').eval()<CR>", { desc = "DAP variable value", dapopts.args })
  --
  vim.keymap.set('n', "<Leader>dsf", function()
    local widgets = require("dap.ui.widgets")
    local sidebar = widgets.sidebar(widgets.frames)
    sidebar.open()
  end, { desc = "Show frames", dapopts.args })
  --
  vim.keymap.set('n', "<Leader>dss", function()
    local widgets = require("dap.ui.widgets")
    local sidebar = widgets.sidebar(widgets.scopes)
    sidebar.open()
  end, { desc = "Show scopes", dapopts.args })

  -- Integration with Telescope
  require('telescope').load_extension("dap")
  vim.keymap.set('n', '<leader>dtc', ':Telescope dap commands<CR>', { desc = "Telescope dap commands", dapopts.args })
  vim.keymap.set('n', '<leader>dtC', ':Telescope dap configurations<CR>', { desc = "Telescope dap configurations", dapopts.args })
  vim.keymap.set('n', '<leader>dtv', ':Telescope dap variables<CR>', { desc = "Telescope dap variables", dapopts.args })
  vim.keymap.set('n', '<leader>dtf', ':Telescope dap frames<CR>', { desc = "Telescope dap frames", dapopts.args })
  vim.keymap.set('n', '<leader>dtb', ':Telescope dap list_breakpoints<CR>', { desc = "Telescope dap list_breakpoints", dapopts.args })
  vim.keymap.set('n', '<leader>db',  ':Telescope dap list_breakpoints<CR>', { desc = "Telescope dap list_breakpoints", dapopts.args })
end

----------------------------
-- [[ Configure DAP UI ]] --
----------------------------
local has_dapui, dapui = pcall(require, "dapui")
if has_dapui and has_dap then
  dapui.setup({
    controls = {
      element = "repl",
      enabled = true,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_over = "",
        step_into = "",
        step_out = "",
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = false,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed = "",
      current_frame = "",
      expanded = ""
    },
    layouts = {
      { elements = {
        { id = "scopes", size = 0.8 }, -- Variables of the program
        { id = "console", size = 0.2 },
        -- { id = "stacks", size = 0.4 },
        -- { id = "breakpoints", size = 0.25 },
      },
        position = "right",
        size = 60
      },
      { elements = {
        -- { id = "console", size = 0.5 },
        { id = "stacks", size = 0.4 },
        { id = "watches", size = 0.6 }, -- Keep track of expressions
        -- { id = "repl", size = 0.35 }
      },
        position = "bottom",
        size = 15
      }
    },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  })

  -- Automatically open/close ui when debugger starts/stops
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    vim.cmd("stopinsert")
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    vim.cmd("stopinsert")
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    vim.cmd("stopinsert")
  end

  vim.keymap.set("n", "<leader>do", function()
    dapui.open()
    vim.cmd("stopinsert")
  end, { desc = "Open DAP UI (no start)", dapopts.args })
  vim.keymap.set("n", "<leader>dc", function()
    dapui.close()
    vim.cmd("stopinsert")
  end, { desc = "Close DAP UI (no quit)", dapopts.args })
  vim.keymap.set("n", "<leader>d<CR>", function()
    dapui.toggle()
    vim.cmd("stopinsert")
  end, { desc = "Toggle DAP UI", dapopts.args })

  -- Completion (if debugger supports it)
  if has_cmp then
    cmp.setup({
      enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
          or require("cmp_dap").is_dap_buffer()
      end
    })

    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
      },
    })
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        vim.api.nvim_buf_set_keymap(0, 'i', "<C-w>", "<cmd>norm ciw<cr>", { silent = true, noremap = true })
      end
    end,
  })
end

---------------------------
-- [[ Configure netrw ]] --
---------------------------
-- Navigation help:
-- u -> Goes back previously
-- U -> Goes forward previously
-- % -> Create file
-- d -> Create directory
-- D -> Delete
vim.cmd[[
  let g:netrw_liststyle = 1
  let g:netrw_keepdir = 0
  let g:netrw_localcopydircmd = 'cp -r'
  let g:netrw_dynamic_maxfilenamelen = 1
]]

---------------------------
-- [[ Configure neorg ]] --
---------------------------
local has_neorg, neorg = pcall(require, "neorg")
if has_neorg then
  neorg.setup({
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {
        config = {
          folds = false,
          icon_preset = "diamond",
          icons = {
            todo = {
              undone = { icon = "◌" },
              pending = { icon = "◔" },
              done = { icon = "✓" },
              on_hold = { icon = "◫" },
              urgent = { icon = "" },
              cancelled = { icon = "✕" },
            },
          },
          dim_code_blocks = {
            conceal = false,
          }
        }
      }, -- Adds pretty icons to your documents
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            research = "~/notes",
          },
        },
      },
    },
  })
  vim.keymap.set("n", "<leader>nw", ":Neorg workspace<space>", { noremap = true, silent = false, desc = "Set neorg workspace" })
  vim.keymap.set("n", "<leader>ni", ":Neorg index<CR>", { noremap = true, silent = true, desc = "Go to workspace index" })
  vim.keymap.set("n", "<leader>nr", ":Neorg return<CR>", { noremap = true, silent = true, desc = "Return to code" })
  vim.keymap.set("n", "<leader>nj", ":Neorg journal today<CR>", { noremap = true, silent = true, desc = "Journal today" })
  vim.keymap.set("n", "<leader>nJj", ":Neorg journal today<CR>", { noremap = true, silent = true, desc = "Journal today" })
  vim.keymap.set("n", "<leader>nJt", ":Neorg journal tomorrow<CR>", { noremap = true, silent = true, desc = "Journal tomorrow" })
  vim.keymap.set("n", "<leader>nJy", ":Neorg journal yesterday<CR>", { noremap = true, silent = true, desc = "Journal yesterday" })
end

-----------------------------------
-- [[ Configure obsidian.nvim ]] --
-----------------------------------
local has_obsidian, _ = pcall(require, "obsidian")
if has_obsidian then
  require("obsidian").setup({
    dir = "~/notes",
  })
end

-----------------------------------
-- [[ Configure fold-cycle ]] --
-----------------------------------
local has_foldcycle, _ = pcall(require, "fold-cycle")
if has_foldcycle then
  vim.keymap.set('n', '<tab>',
    function() return require('fold-cycle').open() end,
    {silent = true, desc = 'Fold-cycle: open folds'})
  vim.keymap.set('n', '<s-tab>',
    function() return require('fold-cycle').close() end,
    {silent = true, desc = 'Fold-cycle: close folds'})
  vim.keymap.set('n', 'zC',
    function() return require('fold-cycle').close_all() end,
    {remap = true, silent = true, desc = 'Fold-cycle: close all folds'})
end

---------------------------------
-- [[ Configure colorscheme ]] --
---------------------------------
local catppuccin_name = "catppuccin"
local has_catppuccin, catppuccin = pcall(require, catppuccin_name)
if has_catppuccin then
  local latte_clrs = {
    base     = "#f7f1ed",
    -- mantle   = "#f9ebaf",
    mantle   = "#ebddce",
    crust    = "#e0d39d",
    pink     = "#bd5fa3",
    mauve    = "#7a33d7",
    green    = "#338022",
    teal     = "#148389",
    yellow   = "#a06514",
    peach    = "#e45a09",
    text     = "#2d2018",
    subtext1 = "#4b3628",
    subtext0 = "#5d4a3d",
    overlay2 = "#6e5e52",
    overlay1 = "#817268",
    overlay0 = "#93867e",
    surface2 = "#a59a93",
    surface1 = "#b7aea9",
    surface0 = "#c9c2be",
  }
  catppuccin.setup({
    color_overrides = {
      latte = latte_clrs,
      frappe = {
        base = "#292e36"
      }
    },
    highlight_overrides = {
      latte = function(latte)
        return {
          Comment = { fg = latte.green, style = { "italic" } }
        }
      end,
      frappe = function() --frappe)
        return {
          Comment = { fg = "#3b9c7b", style = { "bold" } }
        }
      end,
    },
  })
else
  print("Could not find module " .. catppuccin_name)
end
-- Dark theme
vim.cmd.colorscheme "catppuccin-frappe"
-- Light theme
-- vim.cmd.colorscheme "catppuccin-latte"

----------------------------
-- [[ Configure Neogit ]] --
----------------------------
local has_neogit, neogit = pcall(require, "neogit")
if has_neogit then
  neogit.setup({})
  vim.keymap.set('n', '<leader>gg', '<CMD>Neogit<CR>', { desc = 'Neogit' })
end

---------------------------
-- [[ Configure Dired ]] --
---------------------------
local has_dired, dired = pcall(require, "dired")
if has_dired then
  dired.setup ({
    path_separator = "/",
    show_banner = false,
    show_hidden = true
  })
end

---------------------------------
-- [[ Configure Multicursor ]] --
---------------------------------
local has_mc, mc = pcall(require, "multicursors")
if has_mc then
  mc.setup ({})
  vim.keymap.set('n', '<leader>cw', '<CMD>MCstart<CR>', { desc = "Multicursors start word" })
  vim.keymap.set('n', '<leader>cc', '<CMD>MCunderCursor<CR>', { desc = "Multicursors start cursor" })
end

------------------------------
-- [[ Configure oil.nvim ]] --
------------------------------
-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
local has_oil, oil = pcall(require, "oil")
if has_oil then
  oil.setup({
    view_options = {
      show_hidden = true,
    }
  })
  vim.keymap.set('n', '-', "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

-------------------------
-- [[ Configure sad ]] --
-------------------------
local has_sad, sad = pcall(require, "sad")
if has_sad then
  sad.setup({})
  vim.keymap.set('n', "<leader>sr", ":Sad<space>", { desc = "Search and replace", silent = false })
end

----------------------------------
-- [[ Configure grapple.nvim ]] --
----------------------------------
local has_grapple, grapple = pcall(require, "grapple")
if has_grapple then
  grapple.setup({})
  vim.keymap.set('n', "<leader>mt", "<CMD>GrappleToggle<CR>", { desc = "Toggle grapple on file" })
  vim.keymap.set('n', "<leader>mp", "<CMD>GrapplePopup tags<CR>", { desc = "Grapple popup files" })
end

---------------------------------
-- [[ Configure portal.nvim ]] --
---------------------------------
local has_portal, portal = pcall(require, "portal")
if has_portal then
  portal.setup({})
  vim.keymap.set('n', "<leader>o", "<CMD>Portal jumplist backward<CR>", { desc = "Prev portal" })
  vim.keymap.set('n', "<leader>i", "<CMD>Portal jumplist forward<CR>", { desc = "Next portal" })
  if has_grapple then
    vim.keymap.set('n', "<leader>mo", "<CMD>Portal grapple backward<CR>", { desc = "Prev grapple" })
    vim.keymap.set('n', "<leader>mi", "<CMD>Portal grapple forward<CR>", { desc = "Next grapple" })
  end
end

--------------------------------
-- [[ Configure marks.nvim ]] --
--------------------------------
local has_marks, marks = pcall(require, "marks")
if has_marks then
  marks.setup({})
  vim.keymap.set('n', "<leader>ml", "<CMD>MarksListBuf<CR>", { desc = "List buffer marks" })
  vim.keymap.set('n', "<leader>mL", "<CMD>MarksListAll<CR>", { desc = "List all marks" })
end

-------------------------------
-- [[ Configure Which-key ]] --
-------------------------------
local has_wk, wk = pcall(require, "which-key")
if has_wk then
  wk.setup({
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for keymaps that start with a native binding
      i = { 'j', 'k', 'g', 'gjk' },
      v = { 'j', 'k' },
    }
  })

  wk.register({
    a = { name = "AnyJump" },
    b = { name = "Buffers" },
    c = { name = "Multicursor" },
    d = {
      name = "Debbuger",
      t = { name = "Search with Telescope" },
      s = { name = "Step/show" }
    },
    e = {
      name = "Treesitter select",
      e = { name = "Start selection" },
      n = { name = "Increment node" },
      p = { name = "Decrement node" },
    },
    --
    l = { name = "LSP/Loclist" },
    --
    m = { name = "Grapple/marks" },
    n = {
      name = "Neorg",
      j = { name = "Journal" }
    },
    --
    g = { name = "Git" },
    --
    P = { name = "Packer" },
    --
    p = { name = "Pap" },
    --
    q = { name = "Quicklist" },
    --
    s = { name = "Search" },
    v = { name = "Vim" },
    w = {
      name = "Window",
      q = {name = "Kill a window"},
    }
  }, { prefix = "<leader>" })
end
