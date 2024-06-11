local plugins = {
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
}
local setup = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'c',
            'just',
            'lua',
            'meson',
            'query',
            'rust',
            'toml',
            'vim',
            'vimdoc',
        },
    })
end
return {
    plugins = plugins,
    setup = setup,
}
