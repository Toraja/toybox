local M = {}

local config = require("format.config")

---@param client table
---@return boolean
local function supports_formatting(client)
	return client.supports_method("textDocument/formatting")
end

---@param filetype string
---@return boolean
local function can_null_ls_format_filetype(filetype)
	local ok, sources = pcall(require, "null-ls.sources")
	if not ok then
		return false
	end
	if config:ft_prefers_lsp(filetype) then
		return false
	end
	return #sources.get_available(filetype, require("null-ls").methods.FORMATTING) == 0
end

---@param filetype string
local function get_filter(filetype)
	if can_null_ls_format_filetype(filetype) then
		return function(client)
			if client.name == "null-ls" then
				return true
			end
			return supports_formatting(client)
		end
	end

	return function(client)
		return supports_formatting(client)
	end
end

function M.run(filetype)
	filetype = filetype or vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype")
	vim.lsp.buf.format({
		filter = get_filter(filetype),
		timeout_ms = config.opts.timeout,
	})
end

local function create_autocmd()
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("AutoFormat", {}),
		pattern = "*",
		callback = function(args)
			if vim.b.auto_format_disabled then
				return
			end

			if not vim.lsp.buf.server_ready() then
				return
			end

			local ft = vim.api.nvim_buf_get_option(args.buf or vim.api.nvim_get_current_buf(), "filetype")
			if config:is_ft_excluded(ft) then
				return
			end

			M.run(ft)
		end,
	})
end

function M.toggle_auto()
	vim.b.auto_format_disabled = not vim.b.auto_format_disabled
	if vim.b.auto_format_disabled then
		print("Auto format disabled")
	else
		print("Auto format enabled")
	end
end

function M.setup(opts)
	config:setup(opts)

	create_autocmd()
end

return M
