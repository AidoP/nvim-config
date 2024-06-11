local plugins = {
    'RRethy/vim-illuminate',
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },
}
local setup = function()
    require('illuminate').configure({
        providers = {
            'lsp',
            'treesitter',
        },
        delay = 200,
        filetypes_denylist = {
            'NvimTree',
            'fugitive',
        },
    })
end

return {
    plugins = plugins,
    setup = setup,
}
