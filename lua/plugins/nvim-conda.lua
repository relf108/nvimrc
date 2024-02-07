return {
	{
		"kmontocam/nvim-conda",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<Leader>cc", vim.cmd.CondaActivate, {})
		end,
	},
}
