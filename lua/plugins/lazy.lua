return {
	{
		"LazyVim/LazyVim",
		autocommands = { "BufRead", "BufNewFile" },
		opts = {
			colorscheme = "catppuccin",
			defaults = {
				lazy = true,
				keymaps = false,
			},
			checker = {
				enabled = true,
			},
		},
	},
}
