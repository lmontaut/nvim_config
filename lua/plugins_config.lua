-------------------------
-- [[ Configure Packer ]]
-------------------------
vim.keymap.set("n", "<leader>Pc", "<CMD>PackerCompile<CR>", { desc = "Packer compile" })
vim.keymap.set("n", "<leader>Pi", "<CMD>PackerInstall<CR>", { desc = "Packer install" })
vim.keymap.set("n", "<leader>Pd", "<CMD>PackerClean<CR>", { desc = "Packer clean" })
vim.keymap.set("n", "<leader>Ps", "<CMD>source %<CR>", { desc = "Source current file" })

-------------------------------
-- [[ Configure Comment.nvim ]]
-------------------------------
require('Comment').setup()
vim.keymap.set("n", "\\", require('Comment.api').toggle.linewise.current, { desc = "Comment" })
vim.keymap.set("v", "\\", "<ESC><CMD>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Comment" })

-- [[ Configure `lukas-reineke/indent-blankline.nvim` ]]
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = true,
  indent_blankline_use_treesitter = true,
}

---------------------------
-- [[ Configure Gitsigns ]]
---------------------------
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

----------------------------
-- [[ Configure Telescope ]]
----------------------------
-- See `:help telescope` and `:help telescope.setup()`
local actions = require "telescope.actions"
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<esc>"] = actions.close,

        ["<CR>"] = actions.select_default,
        ["<C-a>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-c>"] = actions.edit_command_line,
        -- ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    buffers = {
      theme = "ivy",
    },
    command_history = {
      theme = "ivy",
    },
    live_grep = {
      theme = "ivy",
    },
    grep_string = {
      theme = "ivy",
    },
    quickfix = {
      theme = "ivy",
    },
    lsp_references = {
      theme = "ivy",
    },
    lsp_document_symbols = {
      theme = "ivy",
    },
    lsp_workspace_symbols = {
      theme = "ivy",
    },
    diagnostics = {
      theme = "ivy",
    },
    find_files = {
      -- find_command = { "rg", "--files", "--hidden", },
      theme = "ivy",
    },
    git_files = {
      -- find_command = { "rg", "--files", "--hidden", },
      theme = "ivy",
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader>,', require('telescope.builtin').buffers, { desc = 'Find buffer' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').git_files, { desc = 'Find git file' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').command_history, { desc = 'Command history' })
vim.keymap.set('n', '<leader>sq', require('telescope.builtin').quickfix, { desc = 'Quickfix list' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = 'Find files' })
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
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').grep_string, { desc = 'Search string' })

---------------------------
-- [[ Configure Chadtree ]]
---------------------------
vim.keymap.set('n', '<leader>e', '<CMD>CHADopen<CR>', { desc = 'File browser' })

-------------------------------
-- [[ Configure Treesitter ]]
-------------------------------
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'cmake', 'lua', 'python', 'rust', 'help', 'vim' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      scope_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
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
}

-- Diagnostic keymaps
vim.keymap.set('n', "<leader>lk", vim.diagnostic.goto_prev, { desc = 'LSP: Previous diagnostic' })
vim.keymap.set('n', "<leader>lj", vim.diagnostic.goto_next, { desc = 'LSP: Next diagnostic' })
vim.keymap.set('n', "gl", vim.diagnostic.open_float, { desc = 'LSP: Open diagnostic under cursor' })
-- vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist)

----------------------
-- [[ Configure LSP ]]
----------------------
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
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

  nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
  nmap('gh', "<CMD>ClangdSwitchSourceHeader<CR>", 'Switch from source to header')
  nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
  nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
  -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
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
  clangd = {},
  cmake = {},
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

  sumneko_lua = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Looks of the LSP
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
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

-------------------------------
-- [[ Configure Mason ]]
-------------------------------
-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-------------------------
-- [[ Configure fidget ]]
-------------------------
-- Turn on lsp status information
require('fidget').setup()

-- [[ Configure nvim-cmp ]]
local cmp = require 'cmp'
local luasnip = require 'luasnip'

local cmp_toggle = function()
  if cmp.visible() then
    cmp.close()
    cmp.setup({ enabled = false })
  else
    cmp.setup({ enabled = true })
    cmp.complete()
  end
end

local cmp_abort = function(fallback)
  if cmp.visible() then
    cmp.abort()
    cmp.setup({ enabled = false })
  else
    fallback()
  end
end

local cmp_confirm = function(fallback)
  if cmp.visible() then
    cmp.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      })
    cmp.setup({ enabled = false })
  else
    fallback()
  end
end

-- local cmp_confirm_command = function(fallback)
--     if cmp.visible() then
--       cmp.confirm({
--           behavior = cmp.ConfirmBehavior.Replace,
--           select = true,
--         })
--       cmp.complete()
--   else
--     cmp.setup({ enabled = false })
--     fallback()
--   end
-- end

local cmp_tab = function()
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    cmp_toggle()
  end
end

local cmp_scroll = function(fallback)
  if cmp.visible() then
    cmp.scroll_docs(4)
  else
    fallback()
  end
end

local cmp_scroll_back = function(fallback)
  if cmp.visible() then
    cmp.scroll_docs(-4)
  else
    fallback()
  end
end

-- local cmp_tab_command = function()
--   if cmp.visible() then
--     cmp.select_next_item()
--   elseif luasnip.expand_or_jumpable() then
--     luasnip.expand_or_jump()
--   else
--     cmp_toggle()
--     cmp.select_next_item()
--   end
-- end

local cmp_s_tab = function()
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    cmp_toggle()
  end
end

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

cmp.setup({
  completion = {
    autocomplete = false -- autocomplete will only appear when I ask it to
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping({ i = cmp_scroll }),
    ['<C-u>'] = cmp.mapping({ i = cmp_scroll_back }),
    ['<C-e>'] = cmp.mapping(cmp_abort, { 'i', 's', 'c' }),
    ['<Esc>'] = cmp.mapping(cmp_abort, { 'i', 's' }),
    ['<C-Space>'] = cmp.mapping(cmp_toggle, { 'i', 's', 'c' }),
    ['<CR>'] = cmp.mapping({ i=cmp_confirm, s=cmp_confirm, c=cmp_confirm }),
    ['<Tab>'] = cmp.mapping({ i=cmp_tab, s=cmp_tab, c=cmp_tab }),
    ['<S-Tab>'] = cmp.mapping(cmp_s_tab, { 'i', 's', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp_tab, { 'i', 's', 'c' }),
    ['<C-p>'] = cmp.mapping(cmp_s_tab, { 'i', 's', 'c' }),
  },
  formatting = {
    format = format,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    -- { name = 'file' },
  },
  -- window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  -- },
  experimental = {
    ghost_text = { hl_group = 'GhostText' }
  }
})

cmp.setup.cmdline({ '/', '?' }, {
  -- mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  -- mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' }
  })
})

--------------------------
-- [[ Configure Project ]]
--------------------------
require("project_nvim").setup {
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
  patterns = { ".git" },
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
  silent_chdir = true,
}

-- Telescope integration
require('telescope').load_extension('projects')
vim.keymap.set('n', '<leader>p', "<CMD>Telescope projects<CR>", { desc = 'Open project...' })
vim.keymap.set('n', '<leader>r', "<CMD>Telescope resume<CR>", { desc = 'Telescope resume' })

-----------------------------
-- [[ Configure bufferline ]]
-----------------------------
-- require('bufferline').setup()
-- vim.keymap.set('n', '<C-]>', "<CMD>BufferLineCycleNext<CR>", { desc = 'Next buffer' })
-- vim.keymap.set('n', '<C-[>', "<CMD>BufferLineCyclePrev<CR>", { desc = 'Previous buffer' })

--------------------------
-- [[ Configure lualine ]]
--------------------------
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
  symbols = { error = " ", warn = " ", info = " ", hint = " " },
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

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
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

----------------------------------
-- [[ Configure symbols outline ]]
----------------------------------
require("symbols-outline").setup()
vim.keymap.set('n', '<leader>i', "<CMD>SymbolsOutline<CR>", { desc = 'Symbols outline' })

---------------------------
-- [[ Configure fugitive ]]
---------------------------
vim.keymap.set('n', '<leader>gg', '<CMD>vertical rightbelow Git<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>gl', '<CMD>vertical rightbelow Git log --oneline<CR>', { desc = 'Git short log' })
vim.keymap.set('n', '<leader>gL', '<CMD>rightbelow vsplit | Gclog<CR>', { desc = 'Git log' })
vim.keymap.set('n', '<leader>gt', '<CMD>tabnew<CR><cmd>0G<CR><cmd>norm gUk>gsk>gg<CR>', { desc = 'Git status tab' })
vim.keymap.set('n', '<leader>gl', '<CMD>vertical rightbelow Git log --oneline<CR>', { desc = 'Git short log' })
vim.keymap.set('n', '<leader>gh', '<CMD>rightbelow vsplit | Gclog -g stash<CR>', { desc = 'Git list stashes' })
vim.keymap.set('n', '<leader>gj', '<CMD>Gitsigns next_hunk<CR>', { desc = 'Next hunk' })
vim.keymap.set('n', '<leader>gk', '<CMD>Gitsigns prev_hunk<CR>', { desc = 'Previous hunk' })
vim.keymap.set('n', '<leader>gc', '<CMD>Git commit -v -q<CR>', { desc = 'Git commit' })
vim.keymap.set('n', '<leader>gf', '<CMD>Git fetch<CR>', { desc = 'Git fetch' })
vim.keymap.set('n', '<leader>gp', '<CMD>Git pull<CR>', { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gP', '<CMD>Git push<CR>', { desc = 'Git push' })
vim.keymap.set('n', '<leader>gsf', '<CMD>Git add %<CR>', { desc = 'Git stage file' })
vim.keymap.set('n', '<leader>gsh', '<CMD>Gitsigns stage_hunk<CR>', { desc = 'Git stage hunk' })
vim.keymap.set('n', '<leader>guf', '<CMD>Git reset %<CR>', { desc = 'Git unstage file' })
vim.keymap.set('n', '<leader>guh', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = 'Git unstage hunk' })
vim.keymap.set('n', '<leader>gd', '<CMD>Gitsigns preview_hunk_inline<CR>', { desc = 'Git hunk diff' })
vim.keymap.set('n', '<leader>gD', '<CMD>Gdiffsplit<CR>', { desc = 'Git file diff' })
vim.keymap.set('n', '<leader>gr', '<CMD>Gitsigns reset_hunk<CR>', { desc = 'Git reset hunk' })
vim.keymap.set('n', '<leader>gb', '<CMD>Gitsigns toggle_current_line_blame<CR>', { desc = 'Git toggle blame line' })
vim.keymap.set('n', '<leader>gB', '<CMD>GBrowse<CR>', { desc = 'Git open remote' })

----------------------------
-- [[ Configure vim-sneak ]]
----------------------------
vim.cmd [[
  nmap f <Plug>Sneak_f
  nmap F <Plug>Sneak_F
  let g:sneak#use_ic_scs = 1
]]

------------------------
-- [[ Configure netrw ]]
------------------------
vim.cmd[[
  let g:netrw_keepdir = 0
  let g:netrw_localcopydircmd = 'cp -r'
]]

---------------------------
-- [[ Configure undotree ]]
---------------------------
vim.keymap.set('n', "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo history" })

----------------------
-- [[ Configure Pap ]]
----------------------
local pap = require("pap")
vim.api.nvim_create_user_command('Papcmd', function(command) pap.set_cmd(command.args) end, { nargs = "*" })
vim.api.nvim_create_user_command('Pap', function(command) pap.run_cmd(command.args, false) end, { nargs = "*" })
vim.api.nvim_create_user_command('Paprun', function(command) pap.run_cmd_base(command.args, false) end, { nargs = "*" })
vim.api.nvim_create_user_command('Par', function(command) pap.run_cmd_base(command.args, false) end, { nargs = "*" })
vim.api.nvim_create_user_command('Papa', function(command) pap.run_cmd_base(command.args, false) end, { nargs = "*" })
vim.keymap.set("n", "<leader>qe", ":cg<Space>~/.cache/nvim/out.txt<CR>:cc<CR>", { noremap = true, silent = true, desc = "Load error file into quickfix" })


-----------------------------
-- [[ Configure Which-key ]]
-----------------------------
require('which-key').setup({
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for keymaps that start with a native binding
    i = { 'j', 'k', 'g' },
    v = { 'j', 'k' },
  }
})

---------------------------
-- [[ Configure DAP ]]
---------------------------
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

local dap = require('dap')
dap.adapters.lldb = {
  type = "executable",
  command = "/opt/homebrew/Cellar/llvm/15.0.7_1/bin/lldb-vscode", -- Adjust depdending on llvm version
  name = "lldb"
}

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
    -- program = function()
    --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    -- end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Unmap all keymaps starting with ]
-- vim.keymap.set('n', ']]', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', ']%', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '])', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '][', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', ']}', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', ']<', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', ']m', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', ']M', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', ']s', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[]', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[%', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[)', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[[', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[}', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[<', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[m', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[M', "<nop>", { silent = true, noremap = true })
-- vim.keymap.set('n', '[s', "<nop>", { silent = true, noremap = true })
-- vim.cmd[[
--   nnoremap <silent><nowait> \[ \[\[
--   nnoremap <silent><nowait> \] \]\]
--   function! MakeBracketMaps()
--       nnoremap <silent><nowait><buffer> \[ :<c-u>exe 'normal '.v:count.'\[\['<cr>
--       nnoremap <silent><nowait><buffer> \] :<c-u>exe 'normal '.v:count.'\]\]'<cr>
--   endfunction
--
--   augroup bracketmaps
--       autocmd!
--       autocmd FileType * call MakeBracketMaps()
--   augroup END
-- ]]
-- vim.keymap.set('n', ']', ']]', { silent = true, noremap = true, nowait = true })
-- vim.keymap.set('n', '[', '[[', { silent = true, noremap = true, nowait = true })



-- keymaps
local dapopts = { silent = true, noremap = true }
-- TODO: attach to running debugger
--
vim.keymap.set('n', "<F5>", function() require("dap").continue() end, { desc = "Launch/continue", dapopts.args })
vim.keymap.set('n', "<leader>dc", function() require("dap").continue() end, { desc = "Launch/continue", dapopts.args })
vim.keymap.set('n', "<leader>dC", function() require("dap").reverse_continue() end, { desc = "Reverse continue", dapopts.args })
vim.keymap.set('n', "<leader>drr", function() require("dap").continue() end, { desc = "Launch/continue", dapopts.args })
--
vim.keymap.set('n', "<leader>dq", function() require("dap").disconnect() end, { desc = "Disconnect/quit", dapopts.args })
--
vim.keymap.set('n', "<leader>dR", function() require("dap").restart() end, { desc = "Restart", dapopts.args })
vim.keymap.set('n', "<leader>drr", function() require("dap").restart() end, { desc = "Restart", dapopts.args })
--
vim.keymap.set('n', "<leader>dL", function() require("dap").run_last() end, { desc = "Run last", dapopts.args })
vim.keymap.set('n', "<leader>drl", function() require("dap").run_last() end, { desc = "Run last", dapopts.args })
--
vim.keymap.set('n', "<F9>", function() require("dap").step_over() end, { desc = "Step over", dapopts.args })
vim.keymap.set('n', 'L', function() require("dap").step_over() end, { desc = "Step over (or L)", nowait = true, dapopts.args })
vim.keymap.set('n', "<leader>dj", function() require("dap").step_over() end, { desc = "Step over", dapopts.args })
--
vim.keymap.set('n', "<F7>", function() require("dap").step_back() end, { desc = "Step back", dapopts.args })
vim.keymap.set('n', 'H', function() require("dap").step_back() end, { desc = "Step back (or H)", nowait = true, dapopts.args })
vim.keymap.set('n', "<leader>dk", function() require("dap").step_back() end, { desc = "Step back", dapopts.args })
--
vim.keymap.set('n', "<F8>", function() require("dap").step_into() end, { desc = "Step into", dapopts.args })
vim.keymap.set('n', '}', function() require("dap").step_into() end, { desc = "Step into", dapopts.args })
vim.keymap.set('n', "<leader>di", function() require("dap").step_into() end, { desc = "Step into (or '}')", dapopts.args })
--
vim.keymap.set('n', "<F10>", function() require("dap").step_out() end, { desc = "Step out", dapopts.args })
vim.keymap.set('n', '{', function() require("dap").step_out() end, { desc = "Step out", dapopts.args })
vim.keymap.set('n', "<leader>do", function() require("dap").step_out() end, { desc = "Step out (or '{')", dapopts.args })
--
vim.keymap.set('n', "<leader>dl", function() require("dap").run_to_cursor() end, { desc = "Debug until line under cursor", dapopts.args })
--
vim.keymap.set('n', ')', function() require("dap").down() end, { desc = "Down stacktrace", dapopts.args })
--
vim.keymap.set('n', '(', function() require("dap").up() end, { desc = "Up stacktrace", dapopts.args })
--
vim.keymap.set('n', "<Leader>dt", function() require("dap").toggle_breakpoint() end, { desc = "Breakpoint", dapopts.args })
vim.keymap.set('n', "<Leader>dT", function()
  require("dap").set_breakpoint(vim.fn.input({
      prompt = "[Condition] > ",
      default = "",
      cancelreturn = ""
    })
  ) end, { desc = "Breakpoint set condition", dapopts.args })
vim.keymap.set('n', "<Leader>db", function() require("dap").list_breakpoints() end, { desc = "List breakpoints", dapopts.args })
vim.keymap.set('n', "<Leader>dD", function() require("dap").clear_breakpoints() end, { desc = "Clear breakpoints", dapopts.args })
--
vim.keymap.set('n', "<Leader>dr", function() require("dap").repl.toggle() end, { desc = "REPL toggle", dapopts.args })
--
vim.keymap.set({'n', 'v'}, "|", function()
  require("dap.ui.widgets").hover()
end, { desc = "Hover", dapopts.args })
--
-- vim.keymap.set({'n', 'v'}, "<Leader>dp", function()
--   require("dap.ui.widgets").preview()
-- end, { desc = "Preview", dapopts.args })
--
vim.keymap.set('n', "<Leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "Show frames", dapopts.args })
--
vim.keymap.set('n', "<Leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "Show scopes", dapopts.args })

local wk = require("which-key")
wk.register({
  b = {
    name = "Buffers"
  },
  d = {
    name = "Debbuger",
    r = {
      name = "Run",
    }
  },
  --
  l = {
    name = "LSP"
  },
  --
  g = {
    name = "Git",
    s = {
      name = "Stage"
    },
    u = {
      name = "Unstage"
    }
  },
  --
  m = {
    name = "Make"
  },
  --
  P = {
    name = "Packer"
  },
  --
  p = {
    name = "Projects"
  },
  --
  q = {
    name = "Quicklist"
  },
  --
  s = {
    name = "Search"
  },
}, { prefix = "<leader>" })
