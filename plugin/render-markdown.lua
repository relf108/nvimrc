local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, {
	confirm = false,
	load = function() end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	once = true,
	callback = function()
		loader.load("render-markdown.nvim", function()
			require("render-markdown").setup({})
		end)
	end,
})
