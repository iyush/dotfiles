local actions = require('telescope.actions')

require 'telescope'.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      }
    },
    layout_strategy = 'vertical'
  },
})
