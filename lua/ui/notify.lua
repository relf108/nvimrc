local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/rcarriga/nvim-notify" }, { confirm = false, load = function() end })

local original_notify = vim.notify
local load_notify = loader.lazy(function()
	-- Keep loader error reporting from re-entering the notification proxy.
	vim.notify = original_notify
	loader.load("nvim-notify", function()
		require("notify").setup({
			stages = "static",
			fps = 60,
			timeout = 5000,
			background_colour = "#000000",
			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},
		})
		vim.notify = require("notify")
	end)
end)

vim.notify = function(message, level, opts)
	if vim.in_fast_event() then
		vim.schedule(function()
			vim.notify(message, level, opts)
		end)
		return
	end
	load_notify()
	return vim.notify(message, level, opts)
end

loader.lazy_commands({
	Notifications = { desc = "Show notification history" },
	NotificationsClear = { desc = "Clear notification history" },
}, load_notify)

return { load = load_notify }
