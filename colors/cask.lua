vim.api.nvim_set_hl(0, 'Normal', {fg = '#ffffff'});
vim.api.nvim_set_hl(0, 'Comment', {fg = '#60a0ff'})

vim.api.nvim_set_hl(0, 'Constant', {fg = '#c0ffd0'})
vim.api.nvim_set_hl(0, 'String', {link = 'Constant'})

-- Remove most groups to keep it simple
vim.api.nvim_set_hl(0, 'Function', {link = 'Normal'});
vim.api.nvim_set_hl(0, 'Special', {link = 'Normal'});
vim.api.nvim_set_hl(0, 'Identifier', {link = 'Normal'});
