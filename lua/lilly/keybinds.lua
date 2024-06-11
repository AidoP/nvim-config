local plugins = {

}

local setup = function()
    -- Ctrl-arrows to switch panes
    vim.keymap.set('n', '<C-up>', '<C-w><up>', { desc = 'Focus Window Up' })
    vim.keymap.set('n', '<C-down>', '<C-w><down>', { desc = 'Focus Window Down' })
    vim.keymap.set('n', '<C-left>', '<C-w><left>', { desc = 'Focus Window Left' })
    vim.keymap.set('n', '<C-right>', '<C-w><right>', { desc = 'Focus Window Right' })
    vim.keymap.set('n', '<C-q>', '<C-w>q', { desc = 'Close Window' })
end

return {
    plugins = plugins,
    setup = setup,
}
