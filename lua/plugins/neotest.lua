return {
	{
		"nvim-neotest/neotest",
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python"),
				},
			})
		end,
	},
	"nvim-neotest/neotest-python",
}
