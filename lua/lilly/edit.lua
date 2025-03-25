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

    -- Disable writebackup on SSHFS as it destroys extended attributes
    vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
        callback = function(args)
            vim.api.nvim_set_option_value('writebackup', false, {})
        end,
        pattern = {
            '/mf/*',
            '/home/aidop/d1/*',
            '/home/aidop/d3/*',
            '/home/aidop/tdma/*',
            '/home/aidop/k1/*',
        },
    })

    -- File Encodings
    -- TODO: iconv will have support for `IBM-1047/ZOS_UNIX` soon
    vim.o.fileencodings = 'utf8,IBM-1047/ZOS_UNIX,IBM-1047'

    vim.api.nvim_create_autocmd({'FileReadPost', 'BufReadPost'}, {
        callback = function(args)
            local encoding = vim.api.nvim_get_option_value('fileencoding', { buf = args.buf })
            if encoding:lower() ~= 'ibm-1047' and encoding:lower() ~= 'ibm1047' then
                return
            end
            vim.api.nvim_set_option_value('eol', false, { buf = args.buf })
            vim.api.nvim_set_option_value('fixeol', false, { buf = args.buf })
            local ok, resul = pcall(
                vim.cmd,
                [[%s//\r/g]]
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
            if encoding:lower() ~= 'ibm-1047' and encoding:lower() ~= 'ibm1047' then
                return
            end
            vim.api.nvim_set_option_value('eol', false, { buf = args.buf })
            vim.api.nvim_set_option_value('fixeol', false, { buf = args.buf })
            local ok, result = pcall(
                vim.cmd,
                [[%s/\n//g]]
            )
        end
    })
    vim.api.nvim_create_autocmd({'FileWritePost', 'BufWritePost'}, {
        callback = function(args)
            local encoding = vim.api.nvim_get_option_value('fileencoding', { buf = args.buf })
            if encoding:lower() ~= 'ibm-1047' and encoding:lower() ~= 'ibm1047' then
                return
            end
            local ok, result = pcall(
                vim.cmd,
                [[u]]
            )
        end
    })
end

return {
    plugins = plugins,
    setup = setup,
}
