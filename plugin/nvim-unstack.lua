local loader = require("plugin_loader")

vim.pack.add({
	{
		src = "https://github.com/relf108/nvim-unstack",
		version = vim.version.range("*"),
	},
}, { confirm = false, load = function() end })

vim.schedule(function()
	loader.load("nvim-unstack", function()
		require("nvim-unstack").setup({
			debug = false,
			showsigns = true,
			layout = "quickfix_list",
			mapkey = "<leader>s",
		})
	end)
end)
