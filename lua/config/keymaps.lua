local map = vim.keymap.set

map("n", "<C-p>", function()
  require("telescope.builtin").find_files()
end, { desc = "Find files" })

map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

local lsp_group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
    map("n", "go", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
    map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>f", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))

    if client and client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})
