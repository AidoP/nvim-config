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

    local ts = require('telescope.builtin')
    telescope.load_extension('fzf')

    vim.keymap.set('n', '<leader><space>', ts.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
        ts.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>sf', ts.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sg', ts.live_grep, { desc = '[S]earch by [G]rep' })
    --vim.keymap.set('n', '<C-p>', ts.commands, { desc = 'a' })
    vim.keymap.set('n', '<leader>sm', ts.marks, { desc = '[S]earch [M]arks' })
    vim.keymap.set('n', '<leader>sr', ts.lsp_references, { desc = '[S]earch [R]eferences' })
    vim.keymap.set('n', '<leader>ss', ts.lsp_document_symbols, { desc = '[S]earch [S]ymbols' })
    vim.keymap.set('n', '<leader>sc', ts.lsp_incoming_calls, { desc = '[S]earch Incoming [C]alls' })
    vim.keymap.set('n', '<leader>so', ts.lsp_outgoing_calls, { desc = '[S]earch [O]utgoing Calls' })
    vim.keymap.set('n', '<leader>si', ts.lsp_implementations, { desc = '[S]earch [I]mplementations' })
    vim.keymap.set(
        'n',
        '<leader>d',
        function()
            ts.diagnostics({ bufnr = 0 })
        end,
        { desc = 'Search [D]iagnostics' }
    )
end

return {
    plugins = plugins,
    setup = setup,
}
