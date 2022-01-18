vim.cmd([[
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline', '--exclude=node_modules']}), <bang>0)
  ]])
