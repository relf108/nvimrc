local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/sindrets/diffview.nvim" }, { confirm = false, load = function() end })

local function load()
	loader.load("diffview.nvim")
end

vim.api.nvim_create_autocmd("CmdUndefined", {
	pattern = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
	once = true,
	callback = load,
})

vim.keymap.set("n", "<leader>dv", function()
	load()
	vim.cmd.DiffviewOpen()
end, { desc = "Open Diffview" })

vim.keymap.set("n", "<leader>dc", function()
	load()
	vim.cmd.DiffviewClose()
end, { desc = "Close Diffview" })
