return {
	{
		"f-person/git-blame.nvim",
		config = function()
			require("gitblame").setup({
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000,
			})
		end,
	},
}
