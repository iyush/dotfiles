if require("first_load")() then
  return
end

require('plugins')
require('nvim-tree')
require('after')

vim.api.nvim_set_option("clipboard","unnamed")
vim.g.hidden = true
vim.o.expandtab = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.mouse = 'a'
vim.o.relativenumber = true
vim.o.cursorline = true
