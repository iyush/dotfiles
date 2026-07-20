local gh = function(repo)
  return "https://github.com/" .. repo
end

-- vim.pack has no per-plugin `run` hook like packer. Use PackChanged for
-- plugins that need work after install/update.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data and ev.data.spec and ev.data.spec.name
    local kind = ev.data and ev.data.kind

    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      -- Make sure the plugin is loadable before calling its updater.
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end

      pcall(function()
        require("nvim-treesitter.install").update({ with_sync = true })()
      end)
    end
  end,
})

vim.pack.add({
  -- theme/syntax/editing
  gh("ellisonleao/gruvbox.nvim"),
  gh("sheerun/vim-polyglot"),
  gh("lervag/vimtex"),
  gh("tpope/vim-surround"),
  gh("drewtempelmeyer/palenight.vim"),

  -- Telescope for searching
  { src = gh("nvim-telescope/telescope.nvim"), version = "0.1.4" },
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-telescope/telescope-live-grep-args.nvim"),

  -- LSP/completion
  gh("williamboman/mason.nvim"),
  gh("williamboman/mason-lspconfig.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),
  gh("hrsh7th/cmp-cmdline"),
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-vsnip"),
  gh("hrsh7th/vim-vsnip"),
  gh("onsails/lspkind-nvim"),

  -- Treesitter for syntax highlight
  gh("nvim-treesitter/nvim-treesitter"),

  -- Terminal
  gh("akinsho/toggleterm.nvim"),

  -- status line
  gh("nvim-lualine/lualine.nvim"),
  gh("kyazdani42/nvim-web-devicons"),
}, { confirm = false, load = true })
