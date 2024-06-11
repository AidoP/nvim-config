local plugins = {
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {},
    },
}
local setup = function()

end

return {
    plugins = plugins,
    setup = setup,
}
