local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/Chaitanyabsprip/fastaction.nvim" }, { confirm = false, load = function() end })

vim.api.nvim_create_autocmd("LspAttach", {
	once = true,
	callback = function()
		loader.load("fastaction.nvim", function()
			require("fastaction").setup({
				register_ui_select = true,
			})
		end)
	end,
})
