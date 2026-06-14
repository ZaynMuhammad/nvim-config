local parsers = {
  "lua",
  "vim",
  "vimdoc",
  "query",

  "javascript",
  "typescript",
  "tsx",
  "json",
  "jsonc",
  "html",
  "css",

  "rust",
  "c_sharp",
  "gdscript",

  "bash",
  "dockerfile",
  "toml",
  "yaml",
  "markdown",
  "markdown_inline",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    local ok_configs, configs = pcall(require, "nvim-treesitter.configs")

    -- nvim-treesitter master branch API
    if ok_configs then
      configs.setup({
        ensure_installed = parsers,
        highlight = { enable = true },
        indent = { enable = true },
      })
      return
    end

    -- Compatibility fallback in case lazy.nvim has not synced back from the
    -- nvim-treesitter main branch yet. Do not auto-install here because the
    -- main branch requires the external `tree-sitter` CLI.
    require("nvim-treesitter").setup()

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
