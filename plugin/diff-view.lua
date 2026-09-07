local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/sindrets/diffview.nvim" }, { confirm = false, load = function() end })

local commands = {
	DiffviewOpen = { nargs = "*" },
	DiffviewFileHistory = { nargs = "*", range = true },
	DiffviewClose = { nargs = 0, bang = true },
	DiffviewFocusFiles = { nargs = 0, bang = true },
	DiffviewToggleFiles = { nargs = 0, bang = true },
	DiffviewRefresh = { nargs = 0, bang = true },
	DiffviewLog = { nargs = 0, bang = true },
}

local load = loader.lazy_commands(commands, function()
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
