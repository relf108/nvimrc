return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function()
			local fzf = require("fzf-lua")
			vim.keymap.set("n", "<leader>ff", fzf.files, {})
			vim.keymap.set("n", "<leader>fg", fzf.live_grep, {})
		end,
	},
}
