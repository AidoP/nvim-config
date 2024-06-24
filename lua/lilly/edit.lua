local plugins = {
    'RRethy/vim-illuminate',
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },
}
local setup = function()
    require('illuminate').configure({
        providers = {
            'lsp',
            'treesitter',
        },
        delay = 200,
        filetypes_denylist = {
            'NvimTree',
            'fugitive',
        },
    })

    -- File Encodings
    -- TODO: iconv will have support for `IBM-1047/ZOS_UNIX` soon
    vim.o.fileencodings = 'utf8,IBM-1047/ZOS_UNIX,IBM-1047'

    vim.api.nvim_create_autocmd({'FileReadPost', 'BufReadPost', 'FileWritePost', 'BufWritePost'}, {
        callback = function(args)
            local encoding = vim.api.nvim_get_option_value('fileencoding', { buf = args.buf })
            if encoding:lower() ~= 'ibm-1047' then
                return
            end
            vim.api.nvim_set_option_value('eol', false, { buf = args.buf })
            vim.api.nvim_set_option_value('fixeol', false, { buf = args.buf })
            local ok, resul = pcall(
                vim.cmd,
                [[%s/<U+0085>/\r/g]]
            )
            local ok, resul = pcall(
                vim.cmd,
                [[%s#\($\n\s*\)\+\%$##]]
            )
        end
    })
    vim.api.nvim_create_autocmd({'FileWritePre', 'BufWritePre'}, {
        callback = function(args)
            local encoding = vim.api.nvim_get_option_value('fileencoding', { buf = args.buf })
            if encoding:lower() ~= 'ibm-1047' then
                return
            end
            vim.api.nvim_set_option_value('eol', false, { buf = args.buf })
            vim.api.nvim_set_option_value('fixeol', false, { buf = args.buf })
            local ok, result = pcall(
                vim.cmd,
                [[%s/\n/<U+0085>/g]]
            )
        end
    })
end

return {
    plugins = plugins,
    setup = setup,
}
