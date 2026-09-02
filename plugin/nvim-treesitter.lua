local loader = require("plugin_loader")

vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
}, { confirm = false, load = true })
vim.pack.add({ "https://github.com/apple/pkl-neovim" }, { confirm = false, load = function() end })

local ensure_installed = {
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"python",
	"dart",
	"typescript",
	"regex",
	"bash",
	"markdown",
	"json",
	"markdown_inline",
	"sql",
	"go",
	"rust",
	"yaml",
	"cmake",
	"nix",
	"requirements",
	"pkl",
}

local installed = {}
for _, parser in ipairs(require("nvim-treesitter.config").get_installed("parsers")) do
	installed[parser] = true
end

local to_install = vim.iter(ensure_installed)
	:filter(function(parser)
		return not installed[parser]
	end)
	:totable()

if #to_install > 0 then
	require("nvim-treesitter").install(to_install):wait(300000)
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		if pcall(vim.treesitter.start) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	pattern = "*.pkl",
	once = true,
	callback = function()
		loader.load("pkl-neovim")
	end,
})
