return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree" },
  },
  opts = function()
    local diagnostic_cause = require("config.nvim-tree-diagnostics").decorator()

    return {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        severity = {
          min = vim.diagnostic.severity.WARN,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      renderer = {
        decorators = {
          "Git",
          "Open",
          "Hidden",
          "Modified",
          "Bookmark",
          diagnostic_cause,
          "Copied",
          "Cut",
        },
        highlight_diagnostics = "icon",
        icons = {
          diagnostics_placement = "right_align",
          show = {
            diagnostics = true,
          },
        },
      },
    }
  end,
}
