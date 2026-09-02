local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/voldikss/vim-floaterm" }, { confirm = false, load = function() end })

vim.g.floaterm_height = 0.9
vim.g.floaterm_width = 0.9

local function load()
	loader.load("vim-floaterm")
end

vim.api.nvim_create_autocmd("CmdUndefined", {
	pattern = "Floaterm*",
	once = true,
	callback = load,
})

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
