return function()
  if vim.pack == nil then
    vim.notify(
      "This config uses vim.pack. Please use Neovim 0.12+.",
      vim.log.levels.ERROR
    )
    return true
  end

  return false
end
