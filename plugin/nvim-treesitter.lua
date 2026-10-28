vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
}, { confirm = false, load = true })

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
}

local function start(buf)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end
	local options = vim.bo[buf]
	if options.filetype == "" or (options.buftype ~= "" and options.buftype ~= "help") then
		return
	end
	if pcall(vim.treesitter.start, buf) then
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local function install_missing()
	local installed = {}
	for _, parser in ipairs(require("nvim-treesitter.config").get_installed("parsers")) do
		installed[parser] = true
	end

	local to_install = vim.iter(ensure_installed)
		:filter(function(parser)
			return not installed[parser]
		end)
		:totable()

	if #to_install == 0 then
		return
	end

	require("nvim-treesitter").install(to_install):await(vim.schedule_wrap(function(err, success)
		if err or not success then
			vim.notify(
				"Tree-sitter parser installation failed: " .. tostring(err or "unknown error"),
				vim.log.levels.ERROR
			)
		end
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				start(buf)
			end
		end
	end))
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		start(args.buf)
	end,
})

vim.api.nvim_create_user_command("TSInstallMissing", install_missing, {
	desc = "Install missing parsers from the configured Tree-sitter language list",
})
