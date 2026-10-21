local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/Chaitanyabsprip/fastaction.nvim" }, { confirm = false, load = function() end })

local original_select = vim.ui.select
local load = loader.lazy(function()
	loader.load("fastaction.nvim", function()
		require("fastaction").setup({
			register_ui_select = true,
		})
	end)
end)

vim.ui.select = function(items, opts, on_choice)
	-- Let Fastaction capture the real fallback, not this loading proxy.
	vim.ui.select = original_select
	load()
	return vim.ui.select(items, opts, on_choice)
end
