-- keymaps
vim.g.mapleader = ','
vim.api.nvim_set_keymap('n', '<leader><space>', ':nohlsearch<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>p', ':Files<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>f', ':Rg<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>B', ":NvimTreeFindFileToggle<CR>", { nowait = true } )
