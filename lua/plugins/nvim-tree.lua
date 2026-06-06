return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree" },
  },
  opts = {
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
    },
    renderer = {
      highlight_diagnostics = "icon",
      icons = {
        show = {
          diagnostics = true,
        },
      },
    },
  },
}
