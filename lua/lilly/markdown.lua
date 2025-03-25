local plugins = {
    -- Markdown Renderer
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'echasnovski/mini.nvim',
        },
        opts = {},
    },
}

local setup = function()
    require('render-markdown').setup({
        file_types = { 'markdown' },
    })
end

return {
    plugins = plugins,
    setup = setup,
}
