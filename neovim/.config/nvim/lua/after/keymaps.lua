-- keymaps
vim.g.mapleader = ','
vim.api.nvim_set_keymap('n', '<leader><space>', ':nohlsearch<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':lua require("telescope.builtin").buffers({sort_lastused = true})<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope live_grep<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>th', ':Telescope help_tags<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>td', ':Telescope diagnostics<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>B', ":NvimTreeFindFileToggle<CR>", { nowait = true } )
