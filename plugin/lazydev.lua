local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/folke/lazydev.nvim" }, { confirm = false, load = function() end })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	once = true,
	callback = function()
		loader.load("lazydev.nvim", function()
			require("lazydev").setup({
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			})
		end)
	end,
})
