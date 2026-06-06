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
