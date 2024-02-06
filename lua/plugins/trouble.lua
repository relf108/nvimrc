return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<leader>wd", function()
				require("trouble").toggle({ mode = "document_diagnostics" })
			end)
		end,
	},
}
