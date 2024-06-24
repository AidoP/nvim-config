local plugins = {
    {
        "nvim-neorg/neorg",
        dependencies = {
            "luarocks.nvim",
        },
        lazy = false,
        version = "*",
        config = true,
    },
}
local setup = function()
    require('neorg').setup({
        load = {
            ['core.defaults'] = {},
            ['core.dirman'] = {
                config = {
                    workspaces = {
                        notes = '~/notes',
                    },
                },
            },
        },
    })
end

return {
    plugins = plugins,
    setup = setup,
}
