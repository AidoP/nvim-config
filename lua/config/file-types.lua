return {
    plugins = {

    },
    setup = function()
        scan_file = function(path, buffer)
            local content = vim.api.nvim_buf_get_lines(buffer, 0, 1000, false)
            for i = 1, #content do
                -- Look for a TITLE instruction
                m, e = string.match(content[i], [[^\w*\W+[Tt][Ii][Tt][Ll][Ee]\W+'.*']])
                if m ~= nil then
                    print('found TITLE instruction')
                    return 'hlasm'
                end

                -- Look for a CSECT instruction
                m, e = string.match(content[i], [[^\w*\W+[CcDd][Ss][Ee][Cc][Tt].*$]])
                if m ~= nil then
                    return 'hlasm'
                end

                -- Look for a SYSSTATE instruction
                m, e = string.match(content[i], [[^\W+[Ss][Yy][Ss][Ss][Tt][Aa][Tt][Ee]\W+.*[([Aa][Rr][Cc][Hh][Ll][Vv][Ll])([Aa][Mm][Oo][Dd][Ee])].*$]])
                if m ~= nil then
                    return 'hlasm'
                end

                -- Look for a MACRO instruction
                m, e = string.match(content[i], [[^\W+[Mm][Aa][Cc][Rr][Oo].*$]])
                if m ~= nil then
                    return 'hlasm'
                end
            end
        end
        vim.filetype.add({
            extension = {
                hlasm = 'hlasm'
            },
            pattern = {
                ['.*/[Aa][Ss][Mm][Pp][Gg][Mm]/[^/]*'] = 'hlasm',
                ['.*/[Aa][Ss][Mm][Mm][Aa][Cc]/[^/]*'] = 'hlasm',
                ['.*%.asm'] = 'hlasm',
                ['.*%.asmmac'] = 'hlasm',
                ['.*%.asmpgm'] = 'hlasm',
                ['.*%.hlasm'] = 'hlasm',
                ['.*%.s'] = {
                    priotity = -math.huge,
                    scan_file,
                },
            },
        })
    end
}
