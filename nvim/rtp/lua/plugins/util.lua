return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
	},
	{
		"rcarriga/nvim-notify",
		dependencies = {
			{ "anuvyklack/keymap-amend.nvim" },
		},
		config = function()
			vim.notify = require("notify")

			local max_width = math.floor(vim.opt.columns:get() / 2) -- width does not include border
			require("notify").setup({
				background_colour = "#000000",
				max_width = max_width,
				on_open = function(win_id, notif)
					vim.api.nvim_win_set_option(win_id, "wrap", true)

					local win_height = 2 -- for notification title and separator
					-- each of notif.message is output to separate line
					for _, msg in ipairs(notif.message) do
						win_height = win_height + math.ceil(string.len(msg) / max_width)
					end
					vim.api.nvim_win_set_height(win_id, win_height)
				end,
				stages = "fade",
			})

			local keymap_amend = require("keymap-amend")
			keymap_amend("n", "<M-c>", function(original)
				original()
				---@diagnostic disable-next-line: undefined-field
				vim.notify.dismiss()
			end, { desc = "Close notifications" })
		end,
	},
}
