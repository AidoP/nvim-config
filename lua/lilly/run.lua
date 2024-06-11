local plugins = {

}
local setup = function()
    local just = require('just')
    just.setup({})

    vim.keymap.set(
        'n',
        '<F5>',
        function()
            just.api.run(nil, function(err, stdout)
                if stdout == nil then
                    return
                end
                vim.print(stdout)
                vim.notify(stdout, vim.log.levels.INFO, {})
            end)
        end,
        { desc = '[f5] default just recipe' }
    )

    vim.keymap.set(
        'n',
        '<leader>j',
        function()
            just.api.dump(function(tasks)
                vim.print(tasks)
                -- vim.notify(tasks, vim.log.levels.INFO, {})
            end)
        end,
        { desc = '[J]ust [C]hoose' }
    )
end

return {
    plugins = plugins,
    setup = setup,
}
