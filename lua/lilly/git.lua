local status_signs_attach = function(bufnr)
    vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

    -- don't override the built-in and fugitive keymaps
    local gs = package.loaded.gitsigns
    vim.keymap.set({'n', 'v'}, ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
    vim.keymap.set({'n', 'v'}, '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
    end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
end

local plugins = {
    -- Git Status Signs
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = status_signs_attach,
        },
    },
    -- Git Commands
    'tpope/vim-fugitive',
}
local setup = function()

end

return {
    plugins = plugins,
    setup = setup,
}
