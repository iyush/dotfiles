local actions = require('telescope.actions')
local lga_actions = require("telescope-live-grep-args.actions")
local action_state = require('telescope.actions.state')
local action_set = require('telescope.actions.set')

require 'telescope'.setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      }
    },
    layout_strategy = 'vertical',
    file_ignore_patterns = { "*node_modules/*", "*.git/*", "*dist/*", "*.cache/*" }
  },
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      ignore_current_buffer = true,
      sort_mru = true,
      layout_config = {
        width = 0.8
      },
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        }
      },
      layout_strategy = "vertical"
    }
  }
})
