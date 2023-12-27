local M = {}

local highlight_word_default_opts = {
	bufnr = 0,
	exclusive = false,
}

function M.highlight_word(opts)
	opts = vim.tbl_deep_extend("force", highlight_word_default_opts, opts or {})

	local mode = vim.api.nvim_get_mode()
	local word
	if mode.mode == "v" then
		-- exit visual mode so that <> mark is updated
		vim.cmd([[execute "normal! \<esc>"]])

		visual_text = require("text.select").get_visual_text(opts.bufnr)
		if vim.tbl_count(visual_text) > 1 then
			vim.notify("Multiline selection is not supported", vim.log.levels.WARN, { title = "Highlight word" })
			return
		end

		word = visual_text[1]
	else
		word = vim.fn.expand("<cword>")
	end

	if opts.exclusive then
		word = "\\<" .. word .. "\\>"
	end

	vim.fn.setreg("/", word)
	vim.fn.histadd("search", word)
	vim.o.hlsearch = true
end

return M
