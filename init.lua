-- Space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable unused built-in features
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local config = {
    require('lilly.autocomplete'),
    require('lilly.core'),
    require('lilly.edit'),
    require('lilly.file-tree'),
    require('lilly.git'),
    require('lilly.help'),
    require('lilly.keybinds'),
    require('lilly.lsp'),
    require('lilly.org'),
    --require('lilly.run'),
    --require('lilly.startup'),
    require('lilly.telescope'),
    require('lilly.tree-sitter'),
}

local plugins = {
    -- Luarocks package manager
    {
        "vhyrro/luarocks.nvim",
        priority = 9999,
        config = true,
    },
    -- Atom One Dark Theme
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'onedark'
        end,
    },
    -- Status Line
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                icons_enabled = true,
                theme = 'onedark',
                component_separators = '│',
                section_separators = '',
                disabled_filetypes = {
                    'NvimTree',
                },
            },
        },
    },
}

-- Plugin Manager - lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

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
