local plugins = {
    -- Use Built-In Neovim LSP Support
    {
        'neovim/nvim-lspconfig',
    },
    -- Diagnostics
    {
        'folke/trouble.nvim',
        opts = {}
    },
}
local setup = function()

end

return {
    plugins = plugins,
    setup = setup,
}
