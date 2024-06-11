local plugins = {
    -- Telescope fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        version = '^0.1',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },
}
local setup = function()
    local telescope = require('telescope')
    telescope.setup {
        defaults = {
            mappings = {
                n = {
                    ['<C-d>'] = require('telescope.actions').delete_buffer,
                },
                i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = require('telescope.actions').delete_buffer,
                },
            },
        },
    }

    local telescope_builtin = require('telescope.builtin')
    telescope.load_extension('fzf')

    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
    --vim.keymap.set('n', '<C-p>', telescope_builtin.commands, { desc = 'a' })
end

return {
    plugins = plugins,
    setup = setup,
}
