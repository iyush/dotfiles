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

