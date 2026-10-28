local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/sindrets/diffview.nvim" }, { confirm = false, load = function() end })

local load
local function complete(...)
	load()
	return require("diffview").completion(...)
end

local commands = {
	DiffviewOpen = { nargs = "*", complete = complete, desc = "Open diff view" },
	DiffviewFileHistory = { nargs = "*", complete = complete, range = true, desc = "Show file history" },
	DiffviewClose = { nargs = 0, bang = true, desc = "Close diff view" },
	DiffviewFocusFiles = { nargs = 0, bang = true, desc = "Focus files panel" },
	DiffviewToggleFiles = { nargs = 0, bang = true, desc = "Toggle files panel" },
	DiffviewRefresh = { nargs = 0, bang = true, desc = "Refresh diff view" },
	DiffviewLog = { nargs = 0, bang = true, desc = "Show diffview log" },
}

load = loader.lazy_commands(commands, function()
	loader.load("diffview.nvim")
end)

vim.keymap.set("n", "<leader>dv", function()
	load()
	vim.cmd.DiffviewOpen()
end, { desc = "Open Diffview" })

vim.keymap.set("n", "<leader>dc", function()
	load()
	vim.cmd.DiffviewClose()
end, { desc = "Close Diffview" })
