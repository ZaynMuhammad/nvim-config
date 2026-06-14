return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },

        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        markdown = { "prettier" },

        rust = { "rustfmt" },
        cs = { "csharpier" },
        gdscript = { "gdformat" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        local disabled_filetypes = {}
        if disabled_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end

        return {
          timeout_ms = 3000,
          lsp_format = "fallback",
        }
      end,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        gdscript = { "gdlint" },
        sh = { "shellcheck" },
      }

      local lint_group = vim.api.nvim_create_augroup("UserLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_group,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
