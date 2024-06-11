local plugins = {
    -- Filesystem Tree
    {
        'nvim-tree/nvim-tree.lua',
        version = '^1',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
}

local setup = function()
    -- Filesystem Tree
    require('nvim-tree').setup({
        on_attach = function(bufnr)
            local api = require "nvim-tree.api"
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            api.config.mappings.default_on_attach(bufnr)
        end,
        filters = {
            custom = {
                '^\\.git$',
            },
        },
        live_filter = {
            always_show_folders = false,
        },
        renderer = {
            icons = {
                symlink_arrow = '  ',
                glyphs = {
                    modified = "",
                    git = {
                        unstaged = "",
                        staged = "",
                        unmerged = "",
                        renamed = "",
                        untracked = "",
                        deleted = "",
                        ignored = "",
                    },
                },
            },
        },
        view = {
            side = 'right',
            width = 40,
        },
    })

    local nvim_tree = require('nvim-tree.api')
    vim.keymap.set(
        'n',
        '<C-CR>',
        function()
            nvim_tree.tree.toggle({
                path = '.',
                find_file = true,
            })
        end,
        { desc = '[<C-CR>] File Tree' }
    )

    -- Disable status line on the file tree
    nvim_tree.events.subscribe(nvim_tree.events.Event.TreeOpen, function()
        local tree_winid = nvim_tree.tree.winid()
        if tree_winid ~= nil then
            vim.api.nvim_set_option_value('statusline', '', {win = tree_winid})
        end
    end)

    -- Open files on creation
    nvim_tree.events.subscribe(
        nvim_tree.events.Event.FileCreated,
        function(file)
            vim.cmd("edit " .. file.fname)
        end
    )

    -- Make :bd and :q behave as usual when tree is visible
    vim.api.nvim_create_autocmd({'BufEnter', 'QuitPre'}, {
        nested = false,
        callback = function(e)
            local tree = nvim_tree.tree

            -- Nothing to do if tree is not opened
            if not tree.is_visible() then
                return
            end

            -- How many focusable windows do we have? (excluding e.g. incline status window)
            local winCount = 0
            for _,winId in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_config(winId).focusable then
                    winCount = winCount + 1
                end
            end

            -- We want to quit and only one window besides tree is left
            if e.event == 'QuitPre' and winCount == 2 then
                vim.api.nvim_cmd({cmd = 'qall'}, {})
            end

            -- :bd was probably issued an only tree window is left
            -- Behave as if tree was closed (see `:h :bd`)
            if e.event == 'BufEnter' and winCount == 1 then
                -- Required to avoid "Vim:E444: Cannot close last window"
                vim.defer_fn(function()
                    -- close nvim-tree: will go to the last buffer used before closing
                    tree.toggle({find_file = true, focus = true})
                    -- re-open nivm-tree
                    tree.toggle({find_file = true, focus = false})
                end, 10)
            end
        end
    })
end

return {
    plugins = plugins,
    setup = setup,
}
