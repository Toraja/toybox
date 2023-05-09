local M = {}

function M.block_until_autocmd_event(event_name, wait_interval_ms, fn, timeout_ms)
	if timeout_ms == nil then
		timeout_ms = 60000
	end
	local done = false
	vim.api.nvim_create_autocmd("User", {
		pattern = event_name,
		callback = function()
			done = true
			return true
		end,
	})
	print("Waiting for " .. event_name)
	fn()
	local fail_code_timeout = -1
	local cb_success, fail_code = vim.wait(timeout_ms, function()
		return done
	end, wait_interval_ms)
	if cb_success then
		print("Ready")
	elseif fail_code == fail_code_timeout then
		print(string.format("Timed out while waiting for %s event.", event_name))
	else
		print(string.format("Interrupted while waiting for %s event", event_name))
	end
end

return M
