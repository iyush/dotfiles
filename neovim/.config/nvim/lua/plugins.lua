-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'sheerun/vim-polyglot'
  use 'lervag/vimtex'      
  use 'tpope/vim-surround'
  use 'scrooloose/nerdtree'
  use 'drewtempelmeyer/palenight.vim'
  use {'junegunn/fzf', run = function() vim.fn['fzf#install']()  end }
  use 'junegunn/fzf.vim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-tree'.setup {} end
  }
end)
