-- Vim keymaps (not related to plugins)
require "keymaps"

-- Nvim options
require "options"

-- Plugins
-- Make sure lazy is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
    -- Where personal plugins live
    dev = {
      -- directory where you store your local plugin projects
      path = "~/software/misc/nvim",
      fallback = false,
    },
  })

-- Misc
require "misc"

-- Autocmds
require "autocmds"

-- Plugins config is automatically loaded by lazy.nvim
-- and is located in after/plugin

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
