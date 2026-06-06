local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      },
    },
  },
  ts_ls = {},
  omnisharp = {
    settings = {
      FormattingOptions = { EnableEditorConfigSupport = true },
      RoslynExtensionsOptions = { enableAnalyzersSupport = true },
    },
  },
  gdscript = {},
}

return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      local diagnostic_hover = vim.api.nvim_create_augroup("DiagnosticHover", { clear = true })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = diagnostic_hover,
        callback = function()
          vim.diagnostic.open_float(nil, {
            focus = false,
            scope = "cursor",
          })
        end,
      })

      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = true,
    },
  },
}
