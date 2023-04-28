local M = {}

local default_opts = {
  -- If formatting takes longer than this amount of time, it will fail. Having no
  -- timeout at all tends to be ugly - larger files, complex or poor formatters
  -- will struggle to format within whatever the default timeout
  -- `vim.lsp.buf.format` uses.
  timeout = 10000,
  -- These filetypes will not be formatted automatically.
  excluded_filetypes = {},
  -- Prefer formatting with LSP for these filetypes.
  prefer_lsp_filetypes = {},
}

---@param filetype string
---@return boolean
function M:is_ft_excluded(filetype)
  return vim.tbl_contains(self.opts.excluded_filetypes, filetype)
end

---@param filetype string
---@return boolean
function M:ft_prefers_lsp(filetype)
  return vim.tbl_contains(self.opts.prefer_lsp_filetypes, filetype)
end

function M:setup(opts)
  if self.opts == nil then
    self.opts = vim.tbl_deep_extend("force", default_opts, opts or {})
  else
    self.opts = vim.tbl_deep_extend("force", self.opts, opts or {})
  end
end

return M
