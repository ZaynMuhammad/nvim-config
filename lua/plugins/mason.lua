local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },

  -- TypeScript/JavaScript. vtsls is generally faster and more featureful than ts_ls.
  vtsls = {
    settings = {
      typescript = {
        preferences = {
          includePackageJsonAutoImports = "auto",
          importModuleSpecifier = "non-relative",
        },
        inlayHints = {
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
      javascript = {
        preferences = {
          includePackageJsonAutoImports = "auto",
          importModuleSpecifier = "non-relative",
        },
        inlayHints = {
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  },
  eslint = {
    settings = {
      workingDirectory = { mode = "auto" },
      format = false,
    },
  },

  -- C# via OmniSharp. Requires a dotnet SDK.
  omnisharp = {
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
        AnalyzeOpenDocumentsOnly = true,
        EnableDecompilationSupport = true,
      },
      Sdk = {
        IncludePrereleases = true,
      },
    },
  },

  -- Godot starts its own language server; this is enabled manually below.
  gdscript = {},

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        check = { command = "clippy" },
        procMacro = { enable = true },
        inlayHints = {
          bindingModeHints = { enable = false },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true, minLines = 25 },
          closureReturnTypeHints = { enable = "with_block" },
          lifetimeElisionHints = { enable = "skip_trivial" },
          typeHints = { enable = true },
        },
      },
    },
  },

  jsonls = {},
  yamlls = {},
  bashls = {},
  marksman = {},
  html = {},
  cssls = {},
  tailwindcss = {},
  dockerls = {},
  docker_compose_language_service = {},
  taplo = {},
}

local manual_servers = {
  gdscript = true,
}

local function mason_managed_servers()
  local names = {}
  for name, _ in pairs(servers) do
    if not manual_servers[name] then
      table.insert(names, name)
    end
  end
  table.sort(names)
  return names
end

return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.diagnostic.config({
        underline = true,
        severity_sort = true,
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
          },
        },
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

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      for server, config in pairs(servers) do
        local server_config = vim.tbl_deep_extend("force", { capabilities = capabilities }, config)
        vim.lsp.config(server, server_config)
      end

      for server, _ in pairs(manual_servers) do
        vim.lsp.enable(server)
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
      ensure_installed = mason_managed_servers(),
      automatic_enable = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "eslint_d",
        "csharpier",
        "gdtoolkit",
        "shfmt",
        "shellcheck",
      },
    },
  },
}
