local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/windwp/nvim-autopairs" }, { confirm = false, load = function() end })

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		loader.load("nvim-autopairs", function()
			require("nvim-autopairs").setup({})
		end)
	end,
})
