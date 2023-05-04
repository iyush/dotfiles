--  general keymaps
vim.g.mapleader = ','
vim.api.nvim_set_keymap('n', '<leader><space>', ':nohlsearch<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>p', ':Telescope find_files<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope buffers<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>f', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>B', ":NvimTreeFindFileToggle<CR>", { nowait = true } )

-- telescope specific
vim.api.nvim_set_keymap('n', '<leader>th', ':Telescope help_tags<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>td', ':Telescope diagnostics<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>tr', ':Telescope resume<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>tf', ':Telescope grep_string<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>tl', ":lua require('telescope.builtin').treesitter()<CR>", {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>tm', ":lua require('telescope.builtin').man_pages({sections={'ALL'}})<CR>", {nowait = true} )
