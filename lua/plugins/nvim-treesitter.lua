return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		init = function()
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

			local already_installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(parser)
					return not vim.tbl_contains(already_installed, parser)
				end)
				:totable()

			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"https://github.com/apple/pkl-neovim",
		lazy = true,
		event = "BufReadPre *.pkl",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		build = function()
			require("nvim-treesitter").install({ "pkl" })
		end,
	},
}
