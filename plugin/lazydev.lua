local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/folke/lazydev.nvim" }, { confirm = false, load = function() end })

local load = loader.lazy_commands({
	LazyDev = { nargs = "*" },
}, function()
	loader.load("lazydev.nvim", function()
		require("lazydev").setup({
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		})
	end)
end)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	once = true,
	callback = load,
})
