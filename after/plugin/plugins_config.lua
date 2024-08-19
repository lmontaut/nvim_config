----------------------------
-- [[ Configure Packer ]] --
----------------------------
-- local has_packer, _ = pcall(require, 'packer')
-- if has_packer then
--   vim.keymap.set("n", "<leader>Pc", "<CMD>PackerCompile<CR>", { desc = "Packer compile" })
--   vim.keymap.set("n", "<leader>Pi", "<CMD>PackerInstall<CR>", { desc = "Packer install" })
--   vim.keymap.set("n", "<leader>Pd", "<CMD>PackerClean<CR>", { desc = "Packer clean" })
--   vim.keymap.set("n", "<leader>Ps", "<CMD>source %<CR>", { desc = "Source current file" })
-- end

----------------------------------
-- [[ Configure Comment.nvim ]] --
----------------------------------
local has_comment, comment = pcall(require, 'Comment')
if has_comment then
  comment.setup()
  vim.keymap.set("n", "\\", require('Comment.api').toggle.linewise.current, { desc = "Comment" })
  vim.keymap.set("v", "\\", "<ESC><CMD>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>",
    { desc = "Comment" })

  -- Fill line with commented character until column 80
  local fill_line = function(str)
    if str == nil then
      str = "="
    end
    vim.cmd("normal _")    -- go to the first non-blank character on current line
    local max_col = 80 - 3 -- 80 - 3 for the 3 characters of the comment
    local reps = (max_col - vim.fn.col(".")) / string.len(str)
    if reps > 0 then
      vim.cmd("normal O")
      vim.cmd("s/$/ " .. string.rep(str, reps))
      vim.cmd("normal \\") -- comment
      vim.cmd("normal ==") -- align
    end
  end
  local fill_line_block = function()
    fill_line()
    vim.cmd("normal _")
    vim.cmd("normal O")
    vim.cmd("normal \\")
    vim.cmd("normal ==")
    vim.cmd("normal $a ")
    fill_line()
    vim.cmd("normal j$")
  end
  vim.keymap.set("n", "<leader>=", function() fill_line() end,
    { desc = "Fill line above with =", noremap = true, silent = true })
  vim.keymap.set("n", "<leader>+", function() fill_line_block() end,
    { desc = "Fill block above with =", noremap = true, silent = true })
end

--------------------------------------
-- [[ Configure indent-blankline ]] --
--------------------------------------
-- See `:help indent_blankline.txt`
local has_indent_blankline, indent_blankline = pcall(require, 'indent_blankline')
if has_indent_blankline then
  indent_blankline.setup({
    char                            = '┊',
    show_trailing_blankline_indent  = true,
    indent_blankline_use_treesitter = true,
    show_current_context            = true,
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
  local actions               = require("telescope.actions")
  local telescope             = require("telescope")
  local telescopeConfig       = require("telescope.config")
  -- Extensions actions
  local has_live_grep_args, _ = pcall(telescope.load_extension, "live_grep_args")
  local lga_actions           = require("telescope-live-grep-args.actions")

  -- Clone the default Telescope configuration
  local vimgrep_arguments     = { unpack(telescopeConfig.values.vimgrep_arguments) }
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
          ["<C-h>"] = "which_key",

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
        fname_width = 120,
      },
      lsp_definitions = {
        fname_width = 120,
      },
      lsp_document_symbols = {
        symbol_width = 120,
      },
      git_files = {
        file_ignore_patterns = { "%.png", "%.jpg", "%.jpeg" },
      },
      find_files = { -- Search ALL files, even if not tracked by git
        -- find_command = { "rg", "--files", "--hidden", },
        -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      },
    },
    -- Extensions
    extensions = {
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<C-f>"] = lga_actions.quote_prompt(),
            ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      },
    }
  })

  -- See `:help telescope.builtin`
  local tb = require('telescope.builtin')
  ---@format disable
  vim.keymap.set('n', '<leader>?'      , tb.oldfiles                , { desc = 'Find recently opened files' })
  vim.keymap.set('n', '<leader>,'      , tb.buffers                 , { desc = 'Find buffer'                })
  vim.keymap.set('n', '<leader><space>', tb.git_files               , { desc = 'Find git file'              })
  vim.keymap.set('n', '<leader>s:'     , tb.command_history         , { desc = 'Search command history'     })
  vim.keymap.set('n', '<leader>sC'     , tb.commands                , { desc = 'Search all vim commands'    })
  vim.keymap.set('n', '<leader>sq'     , tb.quickfix                , { desc = 'Search in quickfix'         })
  vim.keymap.set('n', '<leader>sf'     , tb.find_files              , { desc = 'Find files'                 })
  vim.keymap.set('n', '<leader>r'      , "<CMD>Telescope resume<CR>", { desc = 'Telescope resume'           })
  vim.keymap.set('n', '<leader>/'      , function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = 'Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>sf', tb.find_files        , { desc = 'Search files'              })
  vim.keymap.set('n', '<leader>sk', tb.keymaps           , { desc = 'Search keymaps'            })
  vim.keymap.set('n', '<leader>sw', tb.grep_string       , { desc = 'Search current word'       })
  vim.keymap.set('n', '<leader>sg', tb.live_grep         , { desc = 'Grep in directory'         })
  vim.keymap.set('n', '<leader>sd', tb.diagnostics       , { desc = 'Search diagnostics'        })
  vim.keymap.set('n', '<leader>sc', tb.git_commits       , { desc = 'Search git commits'        })
  vim.keymap.set('n', '<leader>sm', tb.man_pages         , { desc = 'Search man pages'          })
  vim.keymap.set('n', '<leader>8' , tb.reloader          , { desc = 'Reload vim modules'        })
  vim.keymap.set('n', '<leader>sh', tb.search_history    , { desc = 'Search history'            })
  vim.keymap.set('n', '<leader>sl', tb.lsp_incoming_calls, { desc = 'Search LSP incoming calls' })
  vim.keymap.set('n', '<leader>sL', tb.lsp_outgoing_calls, { desc = 'Search LSP outgoing calls' })
  -- Quickfix list interaction
  vim.keymap.set('n', '<leader>sQ', tb.quickfixhistory, { desc = 'Search quickfix history' })
  vim.keymap.set('n', '<leader>qh', tb.quickfixhistory, { desc = 'Quickfix history'        })
  vim.keymap.set('n', '<leader>qt', tb.quickfix       , { desc = 'Telescope quickfix'      })
  ---@format enable

  ------------------------
  -- TELESCOPE EXTENSIONS
  ------------------------
  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')

  -- Proper grep for telescope
  if has_live_grep_args then
    vim.keymap.set('n', '<leader>sg', function() telescope.extensions.live_grep_args.live_grep_args() end,
      { desc = 'Grep in directory' })
  end
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
    sync_install = false,
    -- Add languages to be installed here that you want installed for treesitter
    -- ensure_installed = { 'c', 'cpp', 'cmake', 'lua', 'python', 'rust', 'help', 'vim' },
    ensure_installed = { 'c', 'cpp', 'cmake', 'lua', 'python', 'rust', 'vim' },

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection   = '<leader>ee',
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

  -- Hack for certain file types
  vim.cmd [[
    autocmd FileType cpp TSDisable indent
    " autocmd FileType help TSDisable highlight
  ]]
end

------------------------------
-- [[ Configure nvim-cmp ]] --
------------------------------
local has_cmp, cmp = pcall(require, 'cmp')
local has_luasnip, luasnip = pcall(require, 'luasnip')
if has_cmp then
  vim.cmd [[
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
    -- ['<C-e>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     return cmp.abort()
    --   end
    --     fallback()
    --   end, { 'i', 'c' }),
    -- Invoke completion
    ['<Tab>'] = cmp.mapping(function()
      cmp.complete()
    end, { 'i', 'c' }),
    -- Close completion window
    ['<C-e>'] = cmp.mapping(function()
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

  local fixed_width = 50
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
      fields = { "abbr", "menu", "kind" },
      format = function(entry, item)
        -- Define menu shorthand for different completion sources.
        local menu_icon = {
          nvim_lsp = "[NLSP]",
          nvim_lua = "[NLUA]",
          luasnip  = "[LSNP]",
          buffer   = "[BUFF]",
          path     = "[PATH]",
        }
        -- Set the menu "icon" to the shorthand for each completion source.
        item.menu = menu_icon[entry.source.name]

        -- Set the fixed width of the completion menu to 60 characters.
        -- fixed_width = 20

        -- Set 'fixed_width' to false if not provided.
        fixed_width = fixed_width or false

        -- Get the completion entry text shown in the completion window.
        local content = item.abbr

        -- Set the fixed completion window width.
        if fixed_width then
          vim.o.pumwidth = fixed_width
        end

        -- Get the width of the current window.
        local win_width = vim.api.nvim_win_get_width(0)

        -- Set the max content width based on either: 'fixed_width'
        -- or a percentage of the window width, in this case 20%.
        -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
        local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

        -- Truncate the completion entry text if it's longer than the
        -- max content width. We subtract 3 from the max content width
        -- to account for the "..." that will be appended to it.
        if #content > max_content_width then
          item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
        else
          item.abbr = content .. (" "):rep(max_content_width - #content)
        end
        return item
      end,
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

-------------------------------
-- [[ Configure Lspsaga ]] --
-------------------------------
-- Needs to be `setup` after nvim-lspconfig
local has_lspsaga, lspsaga = pcall(require, "lspsaga")
if has_lspsaga then
  lspsaga.setup({
    outline = {
      win_width    = 50,
      auto_preview = false,
      keys         = {
        toggle_or_jump = { "<CR>", "o" },
        jump = { "e" },
      },
    },
    finder = {
      keys = {
        quit = { "q", "<Esc>" },
        toggle_or_open = { "<CR>", "o" },
      }
    },
    lightbulb = {
      sign = false
    }
  })
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
    patterns = { ".git", ".clangd" },
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
  vim.keymap.set('n', '<leader>0', "<CMD>ProjectRoot<CR>", { desc = 'Set project root to current project' })
end

-------------------------
-- [[ Configure LSP ]] --
-------------------------
-- Needed at multiple places in this configuration
local lsp_pythonpath = "$HOME/miniforge3/bin/python"
if os.getenv("CONDA_PREFIX") then
  lsp_pythonpath = os.getenv("CONDA_PREFIX") .. "/bin/python"
end
local on_attach                  = nil
local use_lsp_mappings_telescope = true
local use_lsp_mappings_lspsaga   = true -- has precedence over telescope
local has_lsp_util, _            = pcall(require, "lspconfig.util")
--
-- This bit of code sets up the LSP servers used and their related keybindings.
-- I don't do it here but in theory you can have different keybindings for each server.
if has_lsp_util then
  --
  --  This function gets run when an LSP connects to a particular buffer.
  on_attach = function(client, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    if client.server_capabilities.signatureHelpProvider then
      local has_lspoverloads, lspoverloads = pcall(require, "lsp-overloads")
      if has_lspoverloads then
        lspoverloads.setup(client, {
          ui = {
            max_height = 40,
            max_width = 120,
          },
          -- Don't show the overload by default
          display_automatically = false,
          keymaps = {
            next_signature     = "<C-j>",
            previous_signature = "<C-k>",
            next_parameter     = "<C-l>",
            previous_parameter = "<C-h>",
            close_signature    = "<C-s>"
          },
        })
      end
      vim.api.nvim_set_keymap("n", "<C-s>", "<CMD>LspOverloadsSignature<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("i", "<C-s>", "<CMD>LspOverloadsSignature<CR>", { noremap = true, silent = true })
    end
    --
    -- In this case, we create a func that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
    end

    local imap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('i', keys, func, { buffer = bufnr, desc = desc, silent = true })
    end

    -- Mappings using the vim.lsp.buf functions:
    local tb = require('telescope.builtin')
    -- The following comment is to turn off the formatting of the following code block:
    ---@format disable
    nmap('gd'        , vim.lsp.buf.definition             , 'Goto definition'             )
    nmap('gD'        , vim.lsp.buf.declaration            , 'Goto declatation'            )
    nmap('gI'        , vim.lsp.buf.implementation         , 'Goto implementation'         )
    nmap('gt'        , vim.lsp.buf.type_definition        , 'Goto type definition'        )
    nmap('gr'        , vim.lsp.buf.references             , 'Goto references'             )
    nmap('<C-x>'     , vim.lsp.buf.signature_help         , 'Signature Documentation'     )
    imap('<C-x>'     , vim.lsp.buf.signature_help         , 'Signature Documentation'     )
    nmap('K'         , vim.lsp.buf.hover                  , 'Hover Documentation'         )
    nmap('<leader>cr', vim.lsp.buf.rename                 , 'Rename'                      )
    nmap('<leader>cc', vim.lsp.buf.code_action            , 'Code action'                 )
    nmap('<leader>cs', tb.lsp_document_symbols            , 'Document symbols'            )
    nmap('<leader>cS', tb.lsp_dynamic_workspace_symbols   , 'Workspace symbols'           )
    nmap('gh'        , "<CMD>ClangdSwitchSourceHeader<CR>", 'Switch from source to header')
    nmap("<leader>co", vim.lsp.buf.outgoing_calls         , 'Outgoing calls'              )
    nmap("<leader>ci", vim.lsp.buf.incoming_calls         , 'Incoming calls'              )
    -- Diagnostic keymaps
    nmap('<leader>cD', tb.diagnostics           , 'Diagnostics'                      )
    nmap("<leader>ck", vim.diagnostic.goto_prev , 'Previous diagnostic'              )
    nmap("<leader>cj", vim.diagnostic.goto_next , 'LSP: Next diagnostic'             )
    nmap("gl"        , vim.diagnostic.open_float, 'LSP: Open diagnostic under cursor')
    local format_buffer = function()
      if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "python" then
        vim.cmd("!black %")
      else
        vim.lsp.buf.format()
      end
    end
    nmap('<leader>f' , format_buffer, 'Format')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      format_buffer()
    end, { desc = 'Format current buffer with LSP' })
    -- Create an autocmd to format the buffer on save
    local format_ignored_repos = {
      "pinocchio",
      "contact%-optimization",
      "collision_detection/fcl", -- to not mistake with the hpp-fcl repo
    }
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.lua", "*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.hh", "*.cxx", "*.hxx", "*.rs" },
      callback = function()
        local root_dir, _ = require("project_nvim.project").get_project_root()
        local formatting_is_ignored = false
        if root_dir == nil then
          formatting_is_ignored = true
        else
          for _, repo in ipairs(format_ignored_repos) do
            if string.find(root_dir, repo) then
              formatting_is_ignored = true
            end
          end
        end
        if not formatting_is_ignored then
          format_buffer()
        end
      end
    })

    if use_lsp_mappings_telescope then
      nmap('gd', tb.lsp_definitions     , 'Goto definition'      )
      nmap('gI', tb.lsp_implementations , 'Goto implementation'  )
      nmap('gt', tb.lsp_type_definitions, 'Goto type definitions')
      nmap('gr', tb.lsp_references      , 'Goto references'      )
    end

    -- Documentation: https://nvimdev.github.io/lspsaga/
    if use_lsp_mappings_lspsaga and has_lspsaga then
      nmap('K'         , "<CMD>Lspsaga hover_doc<CR>"                 , 'Hover Documentation'  )
      nmap('<leader>cr', "<CMD>Lspsaga rename<CR>"                    , 'Rename'               )
      nmap('gp'        , "<CMD>Lspsaga peek_definition<CR>"           , 'Peek definition'      )
      nmap('gl'        , "<CMD>Lspsaga show_line_diagnostics<CR>"     , 'Buffer diagnostics'   )
      nmap("<leader>co", "<CMD>Lspsaga outgoing_calls<CR>"            , 'Outgoing calls'       )
      nmap("<leader>ci", "<CMD>Lspsaga incoming_calls<CR>"            , 'Incoming calls'       )
      nmap('<leader>cd', "<CMD>Lspsaga show_buf_diagnostics<CR>"      , 'Buffer diagnostics'   )
      nmap('<leader>cD', "<CMD>Lspsaga show_workspace_diagnostics<CR>", 'Workspace diagnostics')
      -- Finder
      nmap('gr'         , "<CMD>Lspsaga finder tyd+def+ref+imp<CR>", 'Goto references'      )
      nmap('gI'         , "<CMD>Lspsaga finder imp<CR>"            , 'Goto implementation'  )
      nmap('gt'         , "<CMD>Lspsaga finder tyd<CR>"            , 'Goto type definitions')
      nmap('<leader>cfd', "<CMD>Lspsaga finder def<CR>"            , 'Find definitions'     )
      nmap('<leader>cfi', "<CMD>Lspsaga finder imp<CR>"            , 'Find implementations' )
      nmap('<leader>cfr', "<CMD>Lspsaga finder ref<CR>"            , 'Find references'      )
      nmap('<leader>cft', "<CMD>Lspsaga finder tyd<CR>"            , 'Find type definitions')
      -- Outline
      nmap('<leader>I', "<CMD>Lspsaga outline<CR>", 'File outline')
    end
    ---@format enable
  end
end

-- Neodev: better support for the signature, docs and completion.
local has_neodev, neodev = pcall(require, "neodev")
if has_neodev then
  neodev.setup({
    library = { plugins = { "nvim-dap-ui" }, types = true }, -- To have type checking in dap-ui
  })
end

-- Nvim-cmp supports additional completion capabilities for LSP, so broadcast that to servers
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
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local diagnostics_config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = false, -- avoids being stressed by the LSP while typing...
  underline = false,
  severity_sort = true,
  float = {
    focusable = false,
    style     = "minimal",
    border    = "rounded",
    source    = "always",
    header    = "",
    prefix    = "",
  },
}

vim.diagnostic.config(diagnostics_config)
vim.lsp.diagnostics_config = diagnostics_config

---------------------------
-- [[ Configure Mason ]] --
---------------------------
-- Mason allows to easily install and manage LSPs, debuggers, linters etc.
local has_mason, mason = pcall(require, "mason")
local has_mason_lsp_config, mason_lspconfig = pcall(require, "mason-lspconfig")
local has_lspconfig, lspconfig = pcall(require, "lspconfig")
if has_mason and has_mason_lsp_config and has_lspconfig then
  mason.setup()
  mason_lspconfig.setup()

  -- Have the following language servers enabled by default, with these options.
  local servers = {
    clangd = {},
    lua_ls = {},
    neocmake = {},
    rust_analyzer = {},
    pyright = {
      python = {
        pythonPath = lsp_pythonpath,
        analysis = {
          typeCheckingMode = "off",
        }
      }
    },
  }

  -- Mason ensures the servers in `servers` are installed.
  -- Go checkout the `servers` variable to see the options for each server.
  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers({
    function(server_name)
      -- Put server specific things if needed.
      -- For example, for clangd, we want to use the background-index and
      -- disable header-insertion.
      if server_name == "clangd" then
        lspconfig.clangd.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          -- Each server can have its own command to start it.
          cmd = { "clangd", "--background-index", "--header-insertion=never", "--offset-encoding=utf-16" },
          -- cmd = { "clangd", "--header-insertion=never", "--offset-encoding=utf-16" },
          settings = servers.clangd,
        })
      elseif server_name == "lua_ls" then
        lspconfig[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
              client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                  runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                  },
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                      'vim',
                      'require'
                    },
                  },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME
                      -- "${3rd}/luv/library"
                      -- "${3rd}/busted/library",
                    }
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = vim.api.nvim_get_runtime_file("", true)
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              })

              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
          end
        })
      else
        lspconfig[server_name].setup({
          capabilities = capabilities,     -- This is needed for nvim-cmp to work
          on_attach = on_attach,           -- This is needed for the keybindings to work
          settings = servers[server_name], -- Specific settings for the server
          -- There are other options you can set for each server, like cmd, filetypes, etc.
          -- Visit the lspconfig documentation for more information.
        })
      end
    end,
  })
else
  if not has_mason then
    print("Warning: missing mason.")
  end
  if not has_mason_lsp_config then
    print("Warning: missing mason-lspconfig.")
  end
  if not has_lspconfig then
    print("Warning: missing lsp-config.")
  end
end

-- This bit of code is for C# only
if has_lspconfig then
  local pid = vim.fn.getpid()
  local omnisharp_bin = "$HOME/software/misc/omnisharp-osx/run"

  lspconfig.omnisharp.setup({
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    on_attach = on_attach,
    capabilities = capabilities,

    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = false,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = false,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = false,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = false,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local function toSnakeCase(str)
        return string.gsub(str, "%s*[- ]%s*", "_")
      end

      if client ~= nil and client.name == 'omnisharp' then
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

--------------------------------
-- [[ Configure bufferline ]] --
--------------------------------
local has_bufferline, bufferline = pcall(require, "bufferline")
if has_bufferline then
  bufferline.setup()
end

-------------------------------------
-- [[ Configure symbols outline ]] --
-------------------------------------
-- When lspsaga outline is turned off
---@format disable
local has_symbols_outline, symbols_outline = pcall(require, "symbols-outline")
if has_symbols_outline then
  symbols_outline.setup({
    show_guides           = true,
    auto_preview          = false,
    position              = 'right',
    auto_close            = false,
    show_numbers          = false,
    show_relative_numbers = false,
    autofold_depth        = 1,
    auto_unfold_hover     = true,
    keymaps               = {
      close          = { "<Esc>", "q" },
      goto_location  = "<Cr>",
      focus_location = "o",
      hover_symbol   = "<C-space>",
      toggle_preview = "K",
      rename_symbol  = "r",
      code_actions   = "a",
      fold           = "h",
      fold_all       = "H",
      unfold         = "l",
      unfold_all     = "L",
      fold_reset     = "R",
    },
    symbols = {
      File          = { icon = ""   , hl = "@text.uri"    },
      Module        = { icon = ""   , hl = "@namespace"   },
      Namespace     = { icon = ""   , hl = "@namespace"   },
      Package       = { icon = ""   , hl = "@namespace"   },
      Class         = { icon = "𝓒"   , hl = "@type"        },
      Method        = { icon = "ƒ"   , hl = "@method"      },
      Property      = { icon = ""   , hl = "@method"      },
      Field         = { icon = "ғ"   , hl = "@field"       },
      Constructor   = { icon = ""   , hl = "@constructor" },
      Enum          = { icon = "ℰ"   , hl = "@type"        },
      Interface     = { icon = "ﰮ"   , hl = "@type"        },
      Function      = { icon = ""   , hl = "@function"    },
      Variable      = { icon = ""   , hl = "@constant"    },
      Constant      = { icon = ""   , hl = "@constant"    },
      String        = { icon = "𝓐"   , hl = "@string"      },
      Number        = { icon = "#"   , hl = "@number"      },
      Boolean       = { icon = "⊨"   , hl = "@boolean"     },
      Array         = { icon = ""   , hl = "@constant"    },
      Object        = { icon = "⦿"   , hl = "@type"        },
      Key           = { icon = "🔐"  , hl = "@type"        },
      Null          = { icon = "NULL", hl = "@type"        },
      EnumMember    = { icon = ""   , hl = "@field"       },
      Struct        = { icon = "𝓢"   , hl = "@type"        },
      Event         = { icon = "є"   , hl = "@type"        },
      Operator      = { icon = "+"   , hl = "@operator"    },
      TypeParameter = { icon = "𝙏"   , hl = "@parameter"   },
      Component     = { icon = "к"   , hl = "@function"    },
      Fragment      = { icon = "Ґ"   , hl = "@constant"    },
    },
  })
  vim.keymap.set('n', '<leader>I', "<CMD>SymbolsOutline<CR>", { desc = 'Symbols outline' })
end
---@format enable

------------------------------
-- [[ Configure fugitive ]] --
------------------------------
---@format disable
vim.keymap.set('n', '<leader>gG', '<CMD>vertical rightbelow Git<CR>',
  { desc = 'Git status fugitive' })
vim.keymap.set('n', '<leader>gC', '<CMD>vertical rightbelow Git log --oneline<CR>',
  { desc = 'Git short log' })
vim.keymap.set('n', '<leader>gL', '<CMD>rightbelow vsplit | Gclog<CR>',
  { desc = 'Git log (fugitive)' })
vim.keymap.set('n', '<leader>gj', '<CMD>Gitsigns next_hunk<CR>'   , { desc = 'Next hunk'                               })
vim.keymap.set('n', '<leader>gk', '<CMD>Gitsigns prev_hunk<CR>'   , { desc = 'Previous hunk'                           })
vim.keymap.set('n', '<leader>gc', '<CMD>Git commit -v -q<CR>'     , { desc = 'Git commit'                              })
vim.keymap.set('n', '<leader>gf', ':Git fetch<Space>'             , { desc = 'Git fetch'       , silent = false        })
vim.keymap.set('n', '<leader>gp', ':Git pull<Space>'              , { desc = 'Git pull'        , silent = false        })
vim.keymap.set('n', '<leader>gP', ':Git push<Space>'              , { desc = 'Git push'        , silent = false        })
vim.keymap.set('n', '<leader>ga', ':Git add %<Space>'             , { desc = 'Git stage file'  , silent = false        })
vim.keymap.set('n', '<leader>gS', ':Git reset %<Space>'           , { desc = 'Git unstage file', silent = false        })
vim.keymap.set('n', '<leader>gd', '<CMD>Gdiffsplit<CR>'           , { desc = 'Git file diff'                           })
vim.keymap.set('n', '<leader>gm', '<CMD>Gdiffsplit!<CR>'          , { desc = 'Git solve conflicts'                     })
vim.keymap.set('n', '<leader>g[', '<CMD>diffget //2<CR>'          , { desc = 'Git conflict select target (left/up)'    })
vim.keymap.set('n', '<leader>g]', '<CMD>diffget //3<CR>'          , { desc = 'Git conflict select source (right/down)' })
vim.keymap.set('n', '<leader>gR', '<CMD>Gitsigns reset_buffer<CR>', { desc = 'Git reset buffer'                        })
vim.keymap.set('n', '<leader>gt', '<CMD>Gitsigns toggle_current_line_blame<CR>',
  { desc = 'Git toggle blame line' })
vim.keymap.set({ 'n' , 'v' }, '<leader>gs', '<CMD>Gitsigns stage_hunk<CR>'     , { desc = 'Git stage hunk'   })
vim.keymap.set({ 'n' , 'v' }, '<leader>gS', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = 'Git unstage hunk' })
vim.keymap.set({ 'n' , 'v' }, '<leader>gr', '<CMD>Gitsigns reset_hunk<CR>'     , { desc = 'Git reset hunk'   })
local tb = require('telescope.builtin')
vim.keymap.set('n', '<leader>gu', tb.git_stash      , { desc = 'Git stashes'     })
vim.keymap.set('n', '<leader>gb', tb.git_branches   , { desc = 'Git branches'    })
vim.keymap.set('n', '<leader>gl', tb.git_commits    , { desc = 'Git log'         })
vim.keymap.set('n', '<leader>gB', '<CMD>GBrowse<CR>', { desc = 'Git open remote' })
---@format enable

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
  vim.cmd("autocmd Filetype pap-output nnoremap <silent> <buffer> <CR> <CMD>cg<Space>" .. pap.dumpfile .. "<CR>'B")
  -- vim.cmd("autocmd Filetype pap-output nnoremap <silent> <buffer> q <CMD>cg<Space>".. pap.dumpfile .. "<CR>'B")
  vim.cmd("autocmd Filetype pap-output nnoremap <silent> <buffer> <leader>qq <CMD>cg<Space>" ..
    pap.dumpfile .. "<CR><CMD>cc<CR>")

  vim.api.nvim_create_user_command('Papcmd',
    function(command) pap.set_cmd(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Pap',
    function(command) pap.run_cmd(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Paphsize',
    function(command) pap.set_window_hsize(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Papvsize',
    function(command) pap.set_window_vsize(command.args) end, { nargs = "*" })
  vim.api.nvim_create_user_command('PapSetHorizontal',
    function()
      pap.set_horizontal_window(); print("Pap set in horizontal mode.")
    end, {})
  vim.api.nvim_create_user_command('PapSetVertical',
    function()
      pap.set_vertical_window(); print("Pap set in vertical mode.")
    end, {})
  vim.api.nvim_create_user_command('Paprun',
    function(command) pap.run_custom_cmd(command.args, false) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Par',
    function(command) pap.run_custom_cmd(command.args, false) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Paprerun',
    function() pap.run_custom_cmd("_last", false) end, { nargs = "*" })
  vim.api.nvim_create_user_command('Papa',
    function(command) pap.run_custom_cmd(command.args, false) end, { nargs = "*" })
  vim.keymap.set("n", "<leader>qe", "<CMD>cg<Space>~/.cache/nvim/pap_output.txt<CR><CMD>cc<CR>",
    { noremap = true, silent = true, desc = "Load error file into quickfix" })
  vim.keymap.set("n", "<leader>psh", "<CMD>Paphsize<CR>",
    { noremap = true, silent = true, desc = "Set pap horizontal window size" })
  vim.keymap.set("n", "<leader>psv", "<CMD>Papvsize<CR>",
    { noremap = true, silent = true, desc = "Set pap vertical window size" })
  vim.keymap.set("n", "<leader>pr", "<CMD>Paprun<CR>",
    { noremap = true, silent = true, desc = "Paprun (any cmd)" })
  vim.keymap.set("n", "<leader>pR", "<CMD>Paprerun<CR>",
    { noremap = true, silent = true, desc = "Pap rerun last cmd" })
  vim.keymap.set("n", "<leader>pc", "<CMD>Papcmd<CR>",
    { noremap = true, silent = true, desc = "Set pap default cmd" })
  vim.keymap.set("n", "<leader>pp", ":Pap<space>",
    { noremap = true, silent = false, desc = "Pap (prefix default cmd)" })
  vim.keymap.set("n", "<leader>pv", "<CMD>PapSetVertical<CR>",
    { noremap = true, silent = true, desc = "Pap set vertical mode" })
  vim.keymap.set("n", "<leader>ph", "<CMD>PapSetHorizontal<CR>",
    { noremap = true, silent = true, desc = "Pap set horizontal mode" })

  local get_default_file_cmd = function(args)
    -- clang++ -std=c++11 -o ./build/%:t:r %:~:. && ./build/%:t:r
    local file = vim.fn.expand("%:~:.")
    local exe = "./build/" .. vim.fn.expand("%:t:r")
    local ext = vim.fn.expand("%:e")
    local cmd = nil
    if ext == "cpp" then
      cmd = "clang++ -std=c++11 -o " .. exe .. " " .. file
      if args ~= nil then
        cmd = cmd .. " " .. args .. " && " .. exe
      end
    elseif ext == "c" then
      cmd = "clang++ -std=c99 -o " .. exe .. " " .. file .. " && " .. exe
      if args ~= nil then
        cmd = cmd .. " " .. args .. " && " .. exe
      end
    elseif ext == "py" then
      cmd = "python " .. file
    else
      print("Pap: Unsupported file type")
    end
    return cmd
  end

  local compile_and_run_file = function(args)
    local cmd = get_default_file_cmd(args)
    if cmd ~= nil then
      pap.run_custom_cmd(cmd, false)
    end
  end
  vim.api.nvim_create_user_command('PaprunFile',
    function()
      local cmd = get_default_file_cmd(nil)
      vim.ui.input({ prompt = "Compilation command: " .. cmd .. "\n[Arguments] > " }, function(input)
        compile_and_run_file(input)
      end)
    end, { nargs = "*" })

  vim.keymap.set("n", "<leader>pl", "<CMD>PaprunFile<CR>",
    { noremap = true, silent = true, desc = "Compile file and run" })
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

  local function get_executable()
    local path = nil
    vim.ui.input({
      prompt = "[Path to executable] > ",
      default = vim.fn.getcwd() .. '/',
      completion = "file",
    }, function(input)
      path = input
    end)
    return (path and path ~= "") and path or dap.ABORT
  end

  local function get_arguments()
    local args = {}
    vim.ui.input({ prompt = "[Executable arguments] > " }, function(input)
      if input ~= nil and input ~= "" then
        args = vim.split(input or "", " ")
      else
        args = {}
      end
    end)
    return args
  end

  ------------------------------------
  -- C/C++/Rust configurations
  ------------------------------------
  local lldb_path = "/opt/homebrew/opt/llvm/bin/lldb-vscode" -- Adjust depdending on llvm version
  local os_name = vim.loop.os_uname().sysname
  if os_name == "Linux" then
    -- On arch-based linux, simply do `sudo pacman -S lldb`
    lldb_path = "/usr/bin/lldb-vscode"
  end
  dap.adapters.lldb       = {
    type    = "executable",
    command = lldb_path,
    name    = "lldb"
  }

  dap.adapters.codelldb   = {
    type = 'server',
    host = '127.0.0.1',
    port = 13000
  }

  dap.configurations.cpp  = {
    {
      type             = 'lldb', -- Name of the dap.adapter you want to use
      request          = 'launch',
      name             = '(default) Debug binary executable',
      program          = get_executable,
      cwd              = '${workspaceFolder}',
      stopOnEntry      = false,
      args             = get_arguments, -- select arguments to be passed to the executable
      reverseDebugging = true,          -- Not available on bare metal
      runInTerminal    = true           -- So that the program's output is displayed in console
    },
  }
  dap.configurations.c    = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

  ------------------------------------
  -- Python config
  ------------------------------------
  dap.adapters.python     = {
    type    = 'executable',
    command = lsp_pythonpath,
    args    = { '-m', 'debugpy.adapter' },
  }

  -- Used to debug C++ code from python
  dap.adapters.python_cpp = {
    type    = "executable",
    command = lldb_path,
    name    = "lldb"
  }

  local function get_python_arguments()
    return coroutine.create(function(dap_run_co)
      local args = {}
      vim.ui.input({ prompt = "[Python file to debug + arguments] > " }, function(input)
        args = vim.split(input or "", " ")
        coroutine.resume(dap_run_co, args)
      end)
    end)
  end

  dap.configurations.python = {
    {
      -- The first three options are required by nvim-dap
      type           = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
      request        = 'launch',
      name           = "(default) Debug python file",

      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
      program        = "${file}",            -- This configuration will launch the current file if used.
      pythonPath     = lsp_pythonpath,
      console        = "integratedTerminal", -- So that the program's output is displayed in console
      args           = get_arguments,
      redirectOutput = true                  -- So that the program's output is displayed in console
    },
    {
      -- The first three options are required by nvim-dap
      type             = 'python_cpp',
      request          = 'launch',
      name             = "(default) Debug rust/C/C++ from python",

      -- Options below are for lldb
      cwd              = '${workspaceFolder}',
      -- lldb will debug the `python` program and the `args` will be used to pass the name of the python program + the optional arguments.
      program          = "python",
      stopOnEntry      = false,
      args             = get_python_arguments, -- select python file + arguments to be passed to the executable
      reverseDebugging = true,
      runInTerminal    = true,
      justMyCode       = false
    },
  }

  dap.defaults.fallback.external_terminal = {
    command = '/Applications/Alacritty.app/Contents/MacOS/alacritty',
    args    = { '-e' },
  }

  -- Allows DAP to load `.vscode/launch.json`
  -- I you want to add something that has the 'python_cpp' adapter to the 'python' configurations,
  -- you would do something like:
  --     require('dap.ext.vscode').load_launchjs(nil, { python_cpp = {'python'} })
  -- I you want to add something that has the 'lldb' adapter to the 'c', cpp or rust configurations,
  -- you would do something like:
  --     require('dap.ext.vscode').load_launchjs(nil, { lldb = {'c'} }) -- will add only to c config
  -- or:
  --     require('dap.ext.vscode').load_launchjs(nil, { lldb = {'c', 'cpp', 'rust'} }) -- will add to the 3
  local load_launch_json = function()
    require('dap.ext.vscode').load_launchjs(nil, {})
    require('dap.ext.vscode').load_launchjs(nil, { lldb = { 'rust', 'c', 'cpp' } })
    require('dap.ext.vscode').load_launchjs(nil, { python_cpp = { 'python' } })
    -- Add more stuff that needs to be reloaded if needed
    print("Reloaded configurations in .vscode/launch.json")
  end
  load_launch_json()
  vim.keymap.set("n", "<leader>dJ", load_launch_json, { noremap = true, silent = true, desc = "(Re)-load launch.json" })

  -- keymaps
  -- TODO: attach to running debugger
  -- Launch
  vim.keymap.set('n', "<leader>dl", function() dap.continue() end, { desc = "Launch/continue", dapopts.args })
  -- Quit
  vim.keymap.set('n', "<leader>dq", function()
    dap.disconnect()
    vim.cmd("stopinsert")
  end, { desc = "Disconnect/quit", dapopts.args })
  -- Restart
  vim.keymap.set('n', "<leader>dR", function() dap.restart() end, { desc = "Restart", dapopts.args })
  -- Step over
  vim.keymap.set('n', "<leader>dj", function() dap.step_over() end, { desc = "Step over", dapopts.args })
  -- Step into
  vim.keymap.set('n', "<leader>di", function() dap.step_into() end, { desc = "Step into", dapopts.args })
  -- Step out
  vim.keymap.set('n', "<leader>do", function() dap.step_out() end, { desc = "Step out", dapopts.args })
  -- Run to cursor
  vim.keymap.set('n', "<leader>dL", function() dap.run_to_cursor() end, { desc = "Run until cursor", dapopts.args })
  -- Pause
  vim.keymap.set('n', "<leader>dP", function() dap.pause() end, { desc = "Pause", dapopts.args })
  -- Breakpoints
  vim.keymap.set('n', "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Breakpoint", dapopts.args })
  vim.keymap.set('n', "<leader>dc", function()
    dap.set_breakpoint(vim.fn.input({
      prompt = "[Condition] > ",
      default = "",
      cancelreturn = ""
    })
    )
  end, { desc = "Breakpoint set condition", dapopts.args })
  vim.keymap.set('n', "<leader>dD", function() dap.clear_breakpoints() end, { desc = "Clear breakpoints", dapopts.args })
  -- Repl
  vim.keymap.set('n', "<leader>dr", function() dap.repl.toggle() end, { desc = "REPL toggle", dapopts.args })
  -- Hover
  vim.keymap.set({ 'n', 'v' }, "<leader>dk", function() require('dap.ui.widgets').hover() end, { desc = "Hover" })
  -- Up/down the stack trace (without stepping)
  vim.keymap.set('n', "<leader>dn", function() dap.down() end, { desc = "Down stack trace" })
  vim.keymap.set('n', "<leader>dp", function() dap.up() end, { desc = "Up stack trace" })
  -- Show frames
  vim.keymap.set('n', "<leader>df", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes)
  end, { desc = "Show frames", dapopts.args })
  -- Show scopes
  vim.keymap.set('n', "<leader>ds", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.frames)
  end, { desc = "Show scopes", dapopts.args })
  -- Widgets
  vim.keymap.set({ 'n', 'v' }, '<leader>dw', function()
    require('dap.ui.widgets').preview()
  end, { desc = "Preview" })

  -- Integration with Telescope
  require('telescope').load_extension("dap")
  vim.keymap.set('n', '<leader>dtc', '<CMD>Telescope dap commands<CR>',
    { desc = "Telescope dap commands", dapopts.args })
  vim.keymap.set('n', '<leader>dtC', '<CMD>Telescope dap configurations<CR>',
    { desc = "Telescope dap configurations", dapopts.args })
  vim.keymap.set('n', '<leader>dtv', '<CMD>Telescope dap variables<CR>',
    { desc = "Telescope dap variables", dapopts.args })
  vim.keymap.set('n', '<leader>dtf', '<CMD>Telescope dap frames<CR>',
    { desc = "Telescope dap frames", dapopts.args })
  vim.keymap.set('n', '<leader>dtb', '<CMD>Telescope dap list_breakpoints<CR>',
    { desc = "Telescope dap list_breakpoints", dapopts.args })
  vim.keymap.set('n', '<leader>dB', '<CMD>Telescope dap list_breakpoints<CR>',
    { desc = "Telescope dap list_breakpoints", dapopts.args })
end

--------------------------------------
-- [[ Configure DAP virtual text ]] --
--------------------------------------
local has_dap_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if has_dap_virtual_text then
  dap_virtual_text.setup({
    enable = false
  })
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
        pause      = "",
        play       = "",
        run_last   = "",
        step_back  = "",
        step_over  = "",
        step_into  = "",
        step_out   = "",
        terminate  = ""
      }
    },
    element_mappings = {},
    expand_lines = false,
    floating = {
      border   = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed     = "",
      current_frame = "",
      expanded      = ""
    },
    layouts = {
      -- Simple layout
      {
        elements = {
          { id = "repl",    size = 0.3 },
          { id = "console", size = 0.3 },
          -- { id = "breakpoints", size = 0.2 },
          { id = "watches", size = 0.3 },
        },
        position = "bottom",
        size = 10
      },
      -- More details
      {
        elements = {
          { id = "watches", size = 0.3 }, -- Keep track of expressions
          { id = "stacks",  size = 0.3 }, -- keep track of scope variables
          { id = "scopes",  size = 0.3 }, -- Variables of the program
        },
        position = "left",
        size = 40
      }
    },
    mappings = {
      edit   = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open   = "o",
      remove = "d",
      repl   = "r",
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
  end
  -- dap.listeners.before.event_terminated["dapui_config"] = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited["dapui_config"] = function()
  --   dapui.close()
  -- end

  -- Toggle DAP ui
  vim.keymap.set("n", "<leader>d<CR>", function()
    dapui.toggle()
  end, { desc = "Toggle DAP UI", dapopts.args })
  vim.keymap.set("n", "<leader>d1", function()
    dapui.toggle({ layout = 1 })
  end, { desc = "Toggle bottom DAP UI", dapopts.args })
  vim.keymap.set("n", "<leader>d2", function()
    dapui.toggle({ layout = 2 })
  end, { desc = "Toggle left DAP UI", dapopts.args })
  -- Trigger DAP ui element
  vim.keymap.set("n", "<leader>du", function()
    ---@diagnostic disable-next-line: missing-fields, param-type-mismatch
    dapui.float_element(nil, { width = 180, height = 40, enter = true, position = "center" })
  end, { desc = "Dap show...", dapopts.args })
  -- Hover
  vim.keymap.set({ "n", "v" }, "<leader>dk", function()
    -- eval twice to enter the floating window
    dapui.eval()
    dapui.eval()
  end, { desc = "Hover", dapopts.args })
  -- Breakpoints
  vim.keymap.set("n", "<leader>dB", function()
    ---@diagnostic disable-next-line: missing-fields
    dapui.float_element("breakpoints", { enter = true })
  end, { desc = "List breakpoints", dapopts.args })
  -- Watches
  vim.keymap.set("n", "<leader>dw", function()
    ---@diagnostic disable-next-line: missing-fields
    dapui.float_element("watches", { enter = true })
  end, { desc = "Show watches", dapopts.args })
  -- Scopes
  vim.keymap.set("n", "<leader>ds", function()
    dapui.float_element("scopes", { width = 180, height = 40, enter = true, position = "center" })
  end, { desc = "Show scopes", dapopts.args })
  -- Stacks frames
  vim.keymap.set("n", "<leader>df", function()
    dapui.float_element("stacks", { width = 180, height = 40, enter = true, position = "center" })
  end, { desc = "Show frames", dapopts.args })

  -- Completion (if debugger supports it)
  if has_cmp then
    cmp.setup({
      enabled = function()
        return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
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
      if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
        vim.api.nvim_buf_set_keymap(0, 'i', "<C-w>", "<CMD>norm ciw<CR>", { silent = true, noremap = true })
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
vim.cmd [[
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
              undone    = { icon = "◌" },
              pending   = { icon = "◔" },
              done      = { icon = "✓" },
              on_hold   = { icon = "◫" },
              urgent    = { icon = "" },
              cancelled = { icon = "✕" },
            },
          },
          dim_code_blocks = {
            conceal = false,
          }
        }
      },                  -- Adds pretty icons to your documents
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            research = "~/notes",
          },
        },
      },
    },
  })
  vim.keymap.set("n", "<leader>nw", ":Neorg workspace<space>",
    { noremap = true, silent = false, desc = "Set neorg workspace" })
  vim.keymap.set("n", "<leader>ni", "<CMD>Neorg index<CR>",
    { noremap = true, silent = true, desc = "Go to workspace index" })
  vim.keymap.set("n", "<leader>nr", "<CMD>Neorg return<CR>",
    { noremap = true, silent = true, desc = "Return to code" })
  vim.keymap.set("n", "<leader>nj", "<CMD>Neorg journal today<CR>",
    { noremap = true, silent = true, desc = "Journal today" })
  vim.keymap.set("n", "<leader>nJj", "<CMD>Neorg journal today<CR>",
    { noremap = true, silent = true, desc = "Journal today" })
  vim.keymap.set("n", "<leader>nJt", "<CMD>Neorg journal tomorrow<CR>",
    { noremap = true, silent = true, desc = "Journal tomorrow" })
  vim.keymap.set("n", "<leader>nJy", "<CMD>Neorg journal yesterday<CR>",
    { noremap = true, silent = true, desc = "Journal yesterday" })
end

-----------------------------------
-- [[ Configure obsidian.nvim ]] --
-----------------------------------
local has_obsidian, obsidian = pcall(require, "obsidian")
if has_obsidian then
  obsidian.setup({
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
    { silent = true, desc = 'Fold-cycle: open folds' })
  vim.keymap.set('n', '<s-tab>',
    function() return require('fold-cycle').close() end,
    { silent = true, desc = 'Fold-cycle: close folds' })
  vim.keymap.set('n', 'zC',
    function() return require('fold-cycle').close_all() end,
    { remap = true, silent = true, desc = 'Fold-cycle: close all folds' })
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
  vim.keymap.set('n', '<leader>gh', '<CMD>DiffviewFileHistory %<CR>', { desc = 'File history' })
end

---------------------------
-- [[ Configure Dired ]] --
---------------------------
local has_dired, dired = pcall(require, "dired")
if has_dired then
  dired.setup({
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
  mc.setup({})
  vim.keymap.set('n', '<leader>Mw', '<CMD>MCstart<CR>', { desc = "Multicursors start word" })
  vim.keymap.set('n', '<leader>Mc', '<CMD>MCunderCursor<CR>', { desc = "Multicursors start cursor" })
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

---------------------------
-- [[ Configure Noice ]] --
---------------------------
local has_noice, noice = pcall(require, "noice")
if has_noice then
  noice.setup({
    messages = {
      view = "notify",     -- I don't need to know that I saved every time I save...
      enabled = true,
      view_search = false, -- I don't need to know that I searched every time I search...
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"]                = true,
        ["cmp.entry.get_documentation"]                  = true,
      },
      signature = {
        enable = false,
        auto_open = {
          enabled = false,
        },
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search         = true,  -- use a classic bottom cmdline for search
      command_palette       = true,  -- position the cmdline and popupmenu together
      long_message_to_split = true,  -- long messages will be sent to a split
      inc_rename            = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border        = false, -- add a border to hover docs and signature help
    },
  })
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
    file_status = true, -- Displays file status (readonly status, modified status)
    path = 1,           -- 0: Just the filename
    -- 1: Relative path
    -- 2: Absolute path
    -- 3: Absolute path, with tilde as the home directory

    shorting_target = 40, -- Shortens path to leave 40 spaces in the window
    -- for other components. (terrible name, any suggestions?)
    symbols = {
      modified = '[+]',       -- Text to show when the file is modified.
      readonly = '[-]',       -- Text to show when the file is non-modifiable or readonly.
      unnamed  = '[No Name]', -- Text to show for unnamed buffers.
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
    color = { fg = green },
    cond = conditions.hide_in_width,
  }

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    color   = {},
    cond    = conditions.hide_in_width,
  }

  local diff = {
    "diff",
    colored = true,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond    = conditions.hide_in_width
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
      local buf_clients = vim.lsp.get_clients()
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

  local lualine_x = {
    diagnostics,
    treesitter,
    lsp,
  }
  if has_noice then
    lualine_x = {
      -- {
      --   noice.api.status.message.get_hl,
      --   cond = noice.api.status.message.has,
      -- },
      {
        noice.api.status.command.get,
        cond = noice.api.status.command.has,
        color = { fg = "#ff9e64" },
      },
      {
        noice.api.status.mode.get,
        cond = noice.api.status.mode.has,
        color = { fg = "#ff9e64" },
      },
      {
        noice.api.status.search.get,
        cond = noice.api.status.search.has,
        color = { fg = "#ff9e64" },
      },
      diagnostics,
      treesitter,
      lsp,
    }
  end

  lualine.setup({
    options = {
      globalstatus         = true,
      icons_enabled        = true,
      theme                = 'auto',
      component_separators = { left = '', right = '' },
      section_separators   = { left = '', right = '' },
      disabled_filetypes   = { "alpha", "dashboard", "NvimTree", "Outline", "startify" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { mode },
      lualine_b = { branch, filename, diff },
      lualine_c = { python_env },
      lualine_x = lualine_x,
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
    extensions = { "quickfix", "fugitive", "nvim-dap-ui", "symbols-outline", "chadtree" },
  })
end

---------------------------------
-- [[ Configure toggle term ]] --
---------------------------------
local has_toggleterm, toggleterm = pcall(require, "toggleterm")
if has_toggleterm then
  toggleterm.setup({
    direction = "float",
  })
  -- By applying the mappings this way you can pass a count to your
  -- mapping to open a specific window.
  -- For example: 2<C-t> will open terminal 2
  ---@format disable
  vim.keymap.set('n', "<c-t>", "<CMD>exe v:count1 . 'ToggleTerm'<CR>",      { desc = "ToggleTerm" })
  vim.keymap.set('i', "<c-t>", "<Esc><CMD>exe v:count1 . 'ToggleTerm'<CR>", { desc = "ToggleTerm" })
  ---@format enable
  vim.cmd [[
    autocmd TermEnter term://*toggleterm#* tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
  ]]
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "toggleterm" then
        vim.api.nvim_command("startinsert")
        return
      end
    end,
  })
end

-------------------------------
-- [[ Configure autopairs ]] --
-------------------------------
local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
if has_autopairs then
  autopairs.setup({})
end

---------------------------------
-- [[ Configure nvim-window ]] --
---------------------------------
local has_nvim_window, nvim_window = pcall(require, "nvim-window")
if has_nvim_window then
  nvim_window.setup({})
  vim.keymap.set('n', "<leader>wn", function() nvim_window.pick() end, { desc = "Pick window" })
end

-------------------------------
-- [[ Configure Win-shift ]] --
-------------------------------
local has_winshift, winshift = pcall(require, "winshift")
if has_winshift then
  winshift.setup({})
  vim.keymap.set('n', "<leader>wm", "<CMD>WinShift<CR>", { desc = "Move window" })
end

----------------------------------
-- [[ Configure smart-splits ]] --
----------------------------------
local has_smart_splits, smart_splits = pcall(require, "smart-splits")
if has_smart_splits then
  ---@format disable
  vim.keymap.set('n', '<C-Up>'   , smart_splits.resize_up   , { desc = "Resize up"    })
  vim.keymap.set('n', '<C-Down>' , smart_splits.resize_down , { desc = "Resize down"  })
  vim.keymap.set('n', '<C-Left>' , smart_splits.resize_left , { desc = "Resize left"  })
  vim.keymap.set('n', '<C-Right>', smart_splits.resize_right, { desc = "Resize right" })
  ---@format enable
end

-----------------------------
-- [[ Configure copilot ]] --
-----------------------------
-- vim.cmd [[
--   " Don't activate Copilot by default.
--   " autocmd VimEnter * Copilot disable
-- ]]
-- vim.keymap.set('i', '<M-CR>', 'copilot#Accept("\\<CR>")', {
--   expr = true,
--   replace_keycodes = false
-- })
-- vim.g.copilot_no_tab_map = true
---@format disable
-- vim.keymap.set('n', '<leader>Ce', '<CMD>Copilot enable<CR>'    , { desc = "Enable copilot"      })
-- vim.keymap.set('n', '<leader>Cd', '<CMD>Copilot disable<CR>'   , { desc = "Disable copilot "    })
-- vim.keymap.set('n', '<leader>Cs', '<CMD>Copilot status<CR>'    , { desc = "Copilot status"      })
-- vim.keymap.set('n', '<leader>Cc', '<CMD>Copilot panel<CR>'     , { desc = "Copilot panel"       })
-- vim.keymap.set('i', '<M-e>'     , '<Plug>(copilot-dismiss)'    , { desc = "Copilot dismiss"     })
-- vim.keymap.set('i', '<M-\\>'    , '<Plug>(copilot-suggest)'    , { desc = "Copilot suggest"     })
-- vim.keymap.set('i', '<M-p>'     , '<Plug>(copilot-suggest)'    , { desc = "Copilot suggest"     })
-- vim.keymap.set('i', '<M-l>'     , '<Plug>(copilot-accept-word)', { desc = "Copilot accept word" })
-- vim.keymap.set('i', '<M-j>'     , '<Plug>(copilot-accept-line)', { desc = "Copilot accept line" })
---@format enable

------------------------------
-- [[ Configure gpt.nvim ]] --
------------------------------
local has_gpt, gpt = pcall(require, "chatgpt")
if has_gpt then
  gpt.setup({
    api_key_cmd = "pass show nvim_gpt",
    yank_register = "+",
    edit_with_instructions = {
      diff = false,
      keymaps = {
        close = "<C-c>",
        accept = "<C-y>",
        toggle_diff = "<C-d>",
        toggle_settings = "<C-o>",
        toggle_help = "<C-h>",
        cycle_windows = "<Tab>",
        use_output_as_input = "<C-i>",
      },
    },
    chat = {
      loading_text = "Loading, please wait ...",
      question_sign = "", -- 🙂
      answer_sign = "ﮧ", -- 🤖
      border_left_sign = "",
      border_right_sign = "",
      max_line_length = 120,
      sessions_window = {
        active_sign = "  ",
        inactive_sign = "  ",
        current_line_sign = "",
        border = {
          style = "rounded",
          text = {
            top = " Sessions ",
          },
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
      keymaps = {
        close                   = "<C-c>",
        yank_last               = "<C-y>",
        yank_last_code          = "<C-k>",
        scroll_up               = "<C-u>",
        scroll_down             = "<C-d>",
        new_session             = "<C-n>",
        cycle_windows           = "<Tab>",
        cycle_modes             = "<C-f>",
        next_message            = "<C-j>",
        prev_message            = "<C-k>",
        select_session          = "<Space>",
        rename_session          = "r",
        delete_session          = "d",
        draft_message           = "<C-r>",
        edit_message            = "e",
        delete_message          = "d",
        toggle_settings         = "<C-o>",
        toggle_sessions         = "<C-p>",
        toggle_help             = "<C-h>",
        toggle_message_role     = "<C-r>",
        toggle_system_role_open = "<C-s>",
        stop_generating         = "<C-x>",
      },
    },
    popup_layout = {
      default = "center",
      center = {
        width = "80%",
        height = "80%",
      },
      right = {
        width = "50%",
        width_settings_open = "50%",
      },
    },
    popup_window = {
      border = {
        highlight = "FloatBorder",
        style = "rounded",
        text = {
          top = " ChatGPT ",
        },
      },
      win_options = {
        wrap = true,
        linebreak = true,
        foldcolumn = "4",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      buf_options = {
        filetype = "markdown",
      },
    },
    system_window = {
      border = {
        highlight = "FloatBorder",
        style = "rounded",
        text = {
          top = " SYSTEM ",
        },
      },
      win_options = {
        wrap = true,
        linebreak = true,
        foldcolumn = "4",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
    popup_input = {
      prompt = "  ",
      border = {
        highlight = "FloatBorder",
        style = "rounded",
        text = {
          top_align = "center",
          top = " Prompt ",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
      submit = "<C-Enter>",
      submit_n = "<Enter>",
      max_visible_lines = 20,
    },
    settings_window = {
      setting_sign = "  ",
      border = {
        style = "rounded",
        text = {
          top = " Settings ",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
    help_window = {
      setting_sign = "  ",
      border = {
        style = "rounded",
        text = {
          top = " Help ",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
    openai_params = {
      model = "gpt-3.5-turbo",
      frequency_penalty = 0,
      presence_penalty = 0,
      max_tokens = 1000,
      temperature = 0,
      top_p = 1,
      n = 1,
    },
    openai_edit_params = {
      model = "gpt-3.5-turbo",
      frequency_penalty = 0,
      presence_penalty = 0,
      temperature = 0,
      top_p = 1,
      n = 1,
    },
    use_openai_functions_for_edits = false,
    actions_paths = {},
    show_quickfixes_cmd = "Trouble quickfix",
    predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
    highlights = {
      help_key = "@symbol",
      help_description = "@comment",
    },
  })
  ---@format disable
  vim.keymap.set('n', '<leader>cc', '<CMD>ChatGPT<CR>'     , { desc = "Start GPT"                  })
  vim.keymap.set('n', '<leader>ca', '<CMD>ChatGPTActAs<CR>', { desc = "Act as"                     })
  vim.keymap.set('n', '<leader>cl', ':ChatGPTRun'          , { desc = "ChatGPTRun", silent = false })
  vim.keymap.set({ 'n', 'v' }, '<leader>ce', '<CMD>ChatGPTRun explain_code<CR>'             , { desc = "Explain code"           })
  vim.keymap.set({ 'n', 'v' }, '<leader>ct', '<CMD>ChatGPTRun add_tests<CR>'                , { desc = "Add tests"              })
  vim.keymap.set({ 'n', 'v' }, '<leader>cd', '<CMD>ChatGPTRun docstring<CR>'                , { desc = "Add docstring"          })
  vim.keymap.set({ 'n', 'v' }, '<leader>cs', '<CMD>ChatGPTRun summarize<CR>'                , { desc = "Summarize"              })
  vim.keymap.set({ 'n', 'v' }, '<leader>cb', '<CMD>ChatGPTRun fix_bugs<CR>'                 , { desc = "Fix bugs"               })
  vim.keymap.set({ 'n', 'v' }, '<leader>ck', '<CMD>ChatGPTRun keywords<CR>'                 , { desc = "Keywords"               })
  vim.keymap.set({ 'n', 'v' }, '<leader>co', '<CMD>ChatGPTRun optimize_code<CR>'            , { desc = "Optimize code"          })
  vim.keymap.set({ 'n', 'v' }, '<leader>cg', '<CMD>ChatGPTRun grammar_correction<CR>'       , { desc = "Grammar correction"     })
  vim.keymap.set({ 'n', 'v' }, '<leader>cr', '<CMD>ChatGPTRun code_readability_analysis<CR>', { desc = "Code review"            })
  vim.keymap.set({ 'n', 'v' }, '<leader>cp', '<CMD>ChatGPTRun complete_code<CR>'            , { desc = "Complete code"          })
  vim.keymap.set({ 'n', 'v' }, '<leader>ci', '<CMD>ChatGPTEditWithInstructions<CR>'         , { desc = "Edit with instructions" })
  ---@format enable
end

-----------------------------
-- [[ Configure harpoon ]] --
-----------------------------
local has_harpoon, harpoon = pcall(require, "harpoon")
if has_harpoon then
  harpoon:setup()
  -- basic telescope configuration
  local conf = require("telescope.config").values
  local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    }):find()
  end

  vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Harpoon: append to list" })
  vim.keymap.set("n", "<leader>.", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
  vim.keymap.set("n", "<leader>>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = "Open harpoon (editable)"})
end

-----------------------------
-- [[ Configure outline ]] --
-----------------------------
local has_outline, outline = pcall(require, "outline")
if has_outline then
    outline.setup({
      -- Your setup opts here (leave empty to use defaults)
    })
  vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
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
    A = { name = "AnyJump" },
    b = { name = "Buffers" },
    -- c = { name = "ChatGPT" },
    C = { name = "Copilot" },
    M = { name = "Multicursor" },
    d = {
      name = "Debbuger",
      t = { name = "Dap-telescope" },
    },
    e = {
      name = "Treesitter select",
      e = { name = "Start selection" },
      n = { name = "Increment node" },
      p = { name = "Decrement node" },
    },
    --
    c = { name = "Code LSP" },
    L = { name = "Loclist" },
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
      q = { name = "Kill a window" },
    }
  }, { prefix = "<leader>", mode = { "n", "v" } })
end
