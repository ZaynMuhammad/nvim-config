return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<leader>E", function() Snacks.explorer.reveal() end, desc = "File Explorer (reveal)" },
  },
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = {
      enabled = true,
      replace_netrw = false,
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
