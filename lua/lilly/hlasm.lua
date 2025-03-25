local setup = function()
    local lspconfig = require('lspconfig')
    local lsp_util = require('lspconfig.util')
    local lsp_configs = require('lspconfig.configs')

    if not lsp_configs.hlasm then
        lsp_configs.hlasm = {
            default_config = {
                autostart = true,
                cmd = { 'hlasm-language-server' },
                filetypes = { 'hlasm' },
                root_dir = lspconfig.util.root_pattern('.hlasmplugin'),
                settings = {},
            },
            docs = {
                description = [[
                https://github.com/eclipse-che4z/che-che4z-lsp-for-hlasm

                Language Server for IBM High-Level Assember]],
            },
        }
    end

    local detect_hlasm = {
        priority = math.huge,
        function(path, bufnr)
            local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1000, false)
            for i = 1, #content do
                m, e = string.match(content[i], '^%w*[ ]+[Tt][Ii][Tt][Ll][Ee][ ]+\'')
                if m ~= nil then
                    return 'hlasm'
                end
                m, e = string.match(content[i], '^[ ]+[Mm][Aa][Cc][Rr][Oo][ ]*$')
                if m ~= nil then
                    return 'hlasm'
                end
            end
        end,
    }

    vim.filetype.add({
        extension = {
            hlasm = 'hlasm'
        },
        pattern = {
            ['.*%.hlasm'] = 'hlasm',
            ['.*%.s'] = detect_hlasm,
        },
    })
end

return {
    setup = setup,
}

