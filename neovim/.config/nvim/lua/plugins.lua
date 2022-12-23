-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use, use_rocks)
  -- theme
  use { "ellisonleao/gruvbox.nvim" }

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

  -- LSP
  -- mason for installing lsp servers
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  }
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'onsails/lspkind-nvim'


  -- status line
  use {
  'nvim-lualine/lualine.nvim',
  requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  -- json parser
  use_rocks { 'lunajson' }
end)
