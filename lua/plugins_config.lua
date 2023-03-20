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
        ["jk"] = { "<cmd>startinsert<cr>j<cmd>startinsert<cr>k", type = "command" },
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<esc>"] = actions.close,

        ["<CR>"] = actions.select_default,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        -- Absolutely insane, you can refine your search
        ["<C-e>"] = actions.to_fuzzy_refine,
        ["?"] = actions.which_key,

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
vim.keymap.set('n', '<leader>sC', require('telescope.builtin').commands, { desc = 'All commands' })
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
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').git_commits, { desc = 'Search git commits' })

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
  lua_ls = {},
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
}

-- Setup neovim lua configuration
require('neodev').setup({
  library = { plugins = { "nvim-dap-ui" }, types = true }, -- To have type checking in dap-ui
})

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
require("symbols-outline").setup({
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
})
vim.keymap.set('n', '<leader>i', "<CMD>SymbolsOutline<CR>", { desc = 'Symbols outline' })

---------------------------
-- [[ Configure fugitive ]]
---------------------------
vim.keymap.set('n', '<leader>gg', '<CMD>vertical rightbelow Git<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>gG', '<CMD>vertical rightbelow Git<CR>:vertical resize 80<CR>', { desc = 'Git status (half screen)' })
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
vim.keymap.set('n', '<leader>gs', '<CMD>Gitsigns stage_hunk<CR>', { desc = 'Git stage hunk' })
vim.keymap.set('n', '<leader>gS', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = 'Git unstage hunk' })
vim.keymap.set('n', '<leader>gd', '<CMD>Gdiffsplit<CR>', { desc = 'Git file diff' })
vim.keymap.set('n', '<leader>gm', '<CMD>Gdiffsplit!<CR>', { desc = 'Git solve conflicts' })
vim.keymap.set('n', '<leader>g[', '<CMD>diffget //2<CR>', { desc = 'Git conflict select target (left/up)' })
vim.keymap.set('n', '<leader>g]', '<CMD>diffget //3<CR>', { desc = 'Git conflict select source (right/down)' })
vim.keymap.set('n', '<leader>gr', '<CMD>Gitsigns reset_hunk<CR>', { desc = 'Git reset hunk' })
vim.keymap.set('n', '<leader>gR', '<CMD>Gitsigns reset_buffer<CR>', { desc = 'Git reset buffer' })
vim.keymap.set('n', '<leader>gt', '<CMD>Gitsigns toggle_current_line_blame<CR>', { desc = 'Git toggle blame line' })
vim.keymap.set('n', '<leader>gu', require('telescope.builtin').git_stash, { desc = 'Git stashes' })
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gl', require('telescope.builtin').git_commits, { desc = 'Git log' })
vim.keymap.set('n', '<leader>gB', '<CMD>GBrowse<CR>', { desc = 'Git open remote' })

----------------------------
-- [[ Configure vim-sneak ]]
----------------------------
vim.cmd [[
  nmap f <Plug>Sneak_f
  nmap F <Plug>Sneak_F
  let g:sneak#use_ic_scs = 1
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

----------------------
-- [[ Configure DAP ]]
----------------------
-- Helper to setup stuff:
-- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook

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

local dap = require('dap')
dap.adapters.lldb = {
  type = "executable",
  command = "/opt/homebrew/Cellar/llvm/15.0.7_1/bin/lldb-vscode", -- Adjust depdending on llvm version
  name = "lldb"
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
local dapopts = { silent = true, noremap = true }
-- TODO: attach to running debugger
--
vim.keymap.set('n', "<F5>", function() require("dap").continue() end, { desc = "Launch/continue", dapopts.args })
vim.keymap.set('n', "<leader>dl", function() require("dap").continue() end, { desc = "Launch/continue", dapopts.args })
vim.keymap.set('n', "<leader>dL", function() require("dap").reverse_continue() end, { desc = "Reverse continue", dapopts.args })
--
vim.keymap.set('n', "<leader>dq", function() require("dap").disconnect() end, { desc = "Disconnect/quit", dapopts.args })
--
vim.keymap.set('n', "<leader>dR", function() require("dap").restart() end, { desc = "Restart", dapopts.args })
--
-- vim.keymap.set('n', "<leader>dL", function() require("dap").run_last() end, { desc = "Run last", dapopts.args }) -- possibly needed if using .json configs
--
vim.keymap.set('n', "<F9>", function() require("dap").step_over() end, { desc = "Step over", dapopts.args })
vim.keymap.set('n', 'L', function() require("dap").step_over() end, { desc = "Step over (or L)", nowait = true, dapopts.args })
vim.keymap.set('n', "<leader>dsj", function() require("dap").step_over() end, { desc = "Step over", dapopts.args })
--
vim.keymap.set('n', "<F7>", function() require("dap").step_back() end, { desc = "Step back", dapopts.args })
vim.keymap.set('n', 'H', function() require("dap").step_back() end, { desc = "Step back (or H)", nowait = true, dapopts.args })
vim.keymap.set('n', "<leader>dsk", function() require("dap").step_back() end, { desc = "Step back", dapopts.args })
--
vim.keymap.set('n', "<F8>", function() require("dap").step_into() end, { desc = "Step into", dapopts.args })
vim.keymap.set('n', '}', function() require("dap").step_into() end, { desc = "Step into", dapopts.args })
vim.keymap.set('n', "<leader>dsi", function() require("dap").step_into() end, { desc = "Step into (or '}')", dapopts.args })
--
vim.keymap.set('n', "<F10>", function() require("dap").step_out() end, { desc = "Step out", dapopts.args })
vim.keymap.set('n', '{', function() require("dap").step_out() end, { desc = "Step out", dapopts.args })
vim.keymap.set('n', "<leader>dso", function() require("dap").step_out() end, { desc = "Step out (or '{')", dapopts.args })
--
vim.keymap.set('n', "<leader>dc", function() require("dap").run_to_cursor() end, { desc = "Debug until cursor", dapopts.args })
--
vim.keymap.set('n', ')', function() require("dap").down() end, { desc = "Down stacktrace", dapopts.args })
--
vim.keymap.set('n', '(', function() require("dap").up() end, { desc = "Up stacktrace", dapopts.args })
--
vim.keymap.set('n', "<Leader>dp", function() require("dap").pause() end, { desc = "Pause", dapopts.args })
--
vim.keymap.set('n', "<Leader>dk", function() require("dap").toggle_breakpoint() end, { desc = "Breakpoint", dapopts.args })
vim.keymap.set('n', "<Leader>dK", function()
  require("dap").set_breakpoint(vim.fn.input({
      prompt = "[Condition] > ",
      default = "",
      cancelreturn = ""
    })
  ) end, { desc = "Breakpoint set condition", dapopts.args })
vim.keymap.set('n', "<Leader>dD", function() require("dap").clear_breakpoints() end, { desc = "Clear breakpoints", dapopts.args })
--
vim.keymap.set('n', "<Leader>dr", function() require("dap").repl.toggle() end, { desc = "REPL toggle", dapopts.args })
--
vim.keymap.set({'n', 'v'}, "|", function()
  require("dap.ui.widgets").hover()
end, { desc = "Hover", dapopts.args })
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

-------------------------
-- [[ Configure DAP UI ]]
-------------------------
require("dapui").setup({
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
  require("dapui").open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  require("dapui").close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  require("dapui").close()
end
vim.keymap.set("n", "<leader>do", function() require("dapui").open() end, { desc = "Open DAP UI (no start)", dapopts.args })
vim.keymap.set("n", "<leader>dc", function() require("dapui").close() end, { desc = "Close DAP UI (no quit)", dapopts.args })
vim.keymap.set("n", "<leader><CR>", function() require("dapui").toggle() end, { desc = "Toggle DAP UI", dapopts.args })

-- Completion (if debugger supports it)
require("cmp").setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})


------------------------
-- [[ Configure netrw ]]
------------------------
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
]]

----------------------------
-- [[ Configure Which-key ]]
----------------------------
local wk = require("which-key")
wk.register({
  b = {
    name = "Buffers"
  },
  d = {
    name = "Debbuger",
    t = {
      name = "Search with Telescope"
    },
    s = {
      name = "Step/show"
    }
  },
  --
  l = {
    name = "LSP"
  },
  --
  g = {
    name = "Git",
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
  w = {
    name = "Window"
  }
}, { prefix = "<leader>" })
