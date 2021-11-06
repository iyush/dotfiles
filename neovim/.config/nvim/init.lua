for k in pairs(package.loaded) do
	if k:match('plugins') or k:match('first_load') then
		package.loaded[k] = nil
	end
end

if require("first_load")() then
  return
end

require('plugins')
require('nvim-tree')
require('after')

vim.o.expandtab = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.mouse = 'a'
vim.o.relativenumber = true

-- keymaps
vim.g.mapleader = ','
vim.api.nvim_set_keymap('n', '<leader><space>', ':nohlsearch<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>p', ':Files<CR>', {nowait = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>f', ':Rg<CR>', {nowait = true} )
vim.api.nvim_set_keymap('n', '<leader>B', ":NvimTreeFindFileToggle<CR>", { nowait = true } )
