local plugins = {

}

local setup = function()
    -- Ctrl-arrows to switch panes
    vim.keymap.set('n', '<C-up>', '<C-w><up>')
    vim.keymap.set('n', '<C-down>', '<C-w><down>')
    vim.keymap.set('n', '<C-left>', '<C-w><left>')
    vim.keymap.set('n', '<C-right>', '<C-w><right>')
end

return {
    plugins = plugins,
    setup = setup,
}
