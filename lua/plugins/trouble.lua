return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<leader>xx", function()
				require("trouble").toggle({ mode = "workspace_diagnostics" })
			end)
			vim.keymap.set("n", "<leader>xl", function()
				require("trouble").toggle({ mode = "loclist" })
			end)
		end,
	},
}
