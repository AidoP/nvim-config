
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Get all config modules
local config = {
  require('config.editor'),
  require('config.git'),
  require('config.lsp'),
}

-- Plugin Manager - lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}

-- Get plugins for all config modules
for i, c in ipairs(config) do
  for j, p in ipairs(c.plugins) do
    table.insert(plugins, p)
  end
end

require('lazy').setup(plugins, {})

-- Run setup for all config modules
for i, c in ipairs(config) do
  c.setup()
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
