local plugins = {
    -- Jump pad
    -- {
    --     url = 'file:///home/aidop/projects/jump.nvim',
    -- },
}
local setup = function()
    local jump = require('jump')
    jump.setup({})

    if vim.fn.argc() == 0 then
        jump.show()
    end
end
return {
    plugins = plugins,
    setup = setup,
}
