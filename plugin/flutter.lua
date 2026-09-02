local loader = require("plugin_loader")

vim.pack.add({
	"https://github.com/dart-lang/dart-vim-plugin",
	"https://github.com/stevearc/dressing.nvim",
	"https://github.com/akinsho/flutter-tools.nvim",
}, { confirm = false, load = function() end })

local function load()
	loader.load("dart-vim-plugin")
	loader.load("dressing.nvim")
	loader.load("flutter-tools.nvim", function()
		require("flutter-tools").setup({})
	end)
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	pattern = "*.dart",
	once = true,
	callback = load,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dart",
	once = true,
	callback = load,
})
