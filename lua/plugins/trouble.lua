return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<leader>dd", function()
				require("trouble").toggle({ mode = "diagnostics" })
			end)
		end,
	},
}
