local loader = require("plugin_loader")

vim.pack.add({
	{
		src = "https://github.com/relf108/nvim-unstack",
		version = vim.version.range("*"),
	},
}, { confirm = false, load = function() end })

local load = loader.lazy_commands({
	NvimUnstack = {},
	UnstackFromClipboard = {},
	UnstackFromTmux = {},
}, function()
	loader.load("nvim-unstack", function()
		require("nvim-unstack").setup({
			debug = false,
			showsigns = true,
			layout = "quickfix_list",
			mapkey = false,
		})
	end)
end)

vim.keymap.set("v", "<leader>s", function()
	load()
	require("nvim-unstack").unstack()
end, { desc = "Unstack visual selection" })
