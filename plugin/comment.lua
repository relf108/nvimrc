local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/numToStr/Comment.nvim" }, { confirm = false, load = function() end })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	once = true,
	callback = function()
		loader.load("Comment.nvim", function()
			require("Comment").setup()
		end)
	end,
})
