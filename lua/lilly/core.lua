local plugins = {
    -- Terminal
    {
        'akinsho/toggleterm.nvim',
        version = "^2",
        config = true,
    },
    -- Show Indentation Lines
    {
        'lukas-reineke/indent-blankline.nvim',
        -- See `:help indent_blankline.txt`
        main = 'ibl',
        opts = {},
    },
    -- Notifications
    'rcarriga/nvim-notify',
}

local setup = function()
    -- Line Numbering
    vim.wo.number = true

    -- Sign Column
    vim.o.signcolumn = 'yes'

    -- Better Colours
    vim.o.termguicolors = true

    -- Tab Behaviour
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.smartindent = true
    vim.o.expandtab = true

    -- Columns 80 and 160 Guide
    vim.o.cc = '81,161'

    -- Show Invisible Characters
    vim.o.list = true
    vim.o.listchars = 'trail:·,tab:>-'

    -- Save Undo History
    vim.o.undofile = true

    -- Case-Insensitive Search
    vim.o.ignorecase = true
    vim.o.smartcase = true

    -- Highlight on Search
    vim.o.hlsearch = false

    -- Enable Mouse Mode
    vim.o.mouse = 'a'

    -- Sync Clipboard with OS
    vim.o.clipboard = 'unnamedplus'

    -- Decrease Update Time
    vim.o.updatetime = 2500

    -- Use nvim-notify for notifications
    vim.notify = require('notify')

    -- Indent Blank Line
    require('ibl').setup({
        indent = {
            char = '┊',
        },
        scope = {
            enabled = true,
        },
    })

    -- Terminal
    require('toggleterm').setup({
        open_mapping = [[<C-space>]],
        insert_mappings = true,
        terminal_mappings = true,
        direction = 'tab',
    })
end

return {
    plugins = plugins,
    setup = setup,
}
