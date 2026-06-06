local M = {}

local severity_label = {
  [vim.diagnostic.severity.ERROR] = "E",
  [vim.diagnostic.severity.WARN] = "W",
}

local severity_hl = {
  [vim.diagnostic.severity.ERROR] = "NvimTreeDiagnosticErrorIcon",
  [vim.diagnostic.severity.WARN] = "NvimTreeDiagnosticWarnIcon",
}

local function diagnostic_count_for_path(path, is_directory)
  local counts = {
    [vim.diagnostic.severity.ERROR] = 0,
    [vim.diagnostic.severity.WARN] = 0,
  }

  for _, diagnostic in ipairs(vim.diagnostic.get(nil)) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR or diagnostic.severity == vim.diagnostic.severity.WARN then
      local bufnr = diagnostic.bufnr
      local name = bufnr and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) or nil

      if name and name ~= "" then
        local matches = name == path
        if is_directory then
          matches = name:sub(1, #path + 1) == path .. "/"
        end

        if matches then
          counts[diagnostic.severity] = counts[diagnostic.severity] + 1
        end
      end
    end
  end

  if counts[vim.diagnostic.severity.ERROR] > 0 then
    return vim.diagnostic.severity.ERROR, counts[vim.diagnostic.severity.ERROR]
  elseif counts[vim.diagnostic.severity.WARN] > 0 then
    return vim.diagnostic.severity.WARN, counts[vim.diagnostic.severity.WARN]
  end
end

function M.decorator()
  local Decorator = require("nvim-tree.api").Decorator
  local DiagnosticCause = Decorator:extend()

  function DiagnosticCause:new()
    self.enabled = true
    self.icon_placement = "right_align"
  end

  function DiagnosticCause:icons(node)
    if not node or not node.absolute_path then
      return nil
    end

    local severity, count = diagnostic_count_for_path(node.absolute_path, node.type == "directory")
    if not severity or not count then
      return nil
    end

    local label = severity_label[severity]
    local hl = severity_hl[severity]
    if not label or not hl then
      return nil
    end

    local text = label .. " " .. count

    return {
      {
        str = text,
        hl = { hl },
      },
    }
  end

  return DiagnosticCause
end

return M
