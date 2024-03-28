return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

			vim.keymap.set("n", "<leader>dd", function()
				require("trouble").toggle({ mode = "document_diagnostics" })
			end)
			vim.keymap.set("n", "<leader>dw", function()
				require("trouble").toggle({ mode = "workspace_diagnostics" })
			end)
		end,
	},
}
