return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd("normal! ]c")
          else
            gs.next_hunk()
          end
        end, "Next git hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd("normal! [c")
          else
            gs.prev_hunk()
          end
        end, "Previous git hunk")

        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected hunk")
        map("n", "<leader>hb", gs.blame_line, "Blame line")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
      end,
    },
  },
}
