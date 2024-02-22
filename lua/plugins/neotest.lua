return {
	{
		"nvim-neotest/neotest-python",
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						python = vim.g.python_path,
					}),
				},
			})
		end,
	},
}
