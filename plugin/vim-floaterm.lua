local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/voldikss/vim-floaterm" }, { confirm = false, load = function() end })

vim.g.floaterm_height = 0.9
vim.g.floaterm_width = 0.9

local load = loader.lazy_commands({
	FloatermNew = { nargs = "*", bang = true, range = true },
	FloatermUpdate = { nargs = "*", bang = true },
	FloatermShow = { nargs = "?", bang = true, count = 0 },
	FloatermHide = { nargs = "?", bang = true, count = 0 },
	FloatermKill = { nargs = "?", bang = true, count = 0 },
	FloatermToggle = { nargs = "?", bang = true, count = 0 },
	FloatermSend = { nargs = "?", bang = true, range = true },
	FloatermPrev = { nargs = 0 },
	FloatermNext = { nargs = 0 },
	FloatermFirst = { nargs = 0 },
	FloatermLast = { nargs = 0 },
}, function()
	loader.load("vim-floaterm")
end)

local mappings = {
	["<C-t>"] = "FloatermToggle",
	["<C-S-n>"] = "FloatermNew",
	["<C-S-d>"] = "FloatermKill",
	["<C-S-k>"] = "FloatermNext",
	["<C-S-j>"] = "FloatermPrev",
	["<C-S-h>"] = "FloatermFirst",
	["<C-S-l>"] = "FloatermLast",
}

for lhs, command in pairs(mappings) do
	vim.keymap.set({ "n", "t" }, lhs, function()
		load()
		vim.cmd(command)
	end, { desc = command })
end
