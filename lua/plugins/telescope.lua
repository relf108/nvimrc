return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>ff",
				':lua require"telescope.builtin".find_files({ hidden = true, file_ignore_patterns = {".git"} })<CR>',
				{ noremap = true, silent = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>fg",
				':lua require"telescope.builtin".live_grep({ hidden = true, file_ignore_patterns = {".git"} })<CR>',
				{ noremap = true, silent = true }
			)
		end,
	},
}
