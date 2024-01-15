return {
	{
		"kmontocam/nvim-conda",
		config = function()
			vim.keymap.set("n", "<Leader>cc", vim.cmd.CondaActivate, {})
		end,
	},
}
