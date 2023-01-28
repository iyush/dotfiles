require("nvim-tree").setup {
  renderer = {
    indent_markers = {
      enable = true
    }
  },
  update_focused_file = {
    enable = true
  },
  view = {
    width = {
      min = 30,
      max = -1,
      padding = 1
    }
  }
}
