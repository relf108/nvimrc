return {
	{
		"nvim-neotest/neotest-python",
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local conf = require("functions.pytest-conf")
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						python = vim.g.python_path(),
						strategy = "dap",
						env = conf("env"),
					}),
				},
			})
		end,
	},
}
