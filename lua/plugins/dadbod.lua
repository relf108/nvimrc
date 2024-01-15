return {
	"tpope/vim-dadbod",
	{
		"kristijanhusak/vim-dadbod-ui",
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader>dbt", ":call db_ui#toggle()<CR>", {})
			vim.api.nvim_set_keymap("n", "<Leader>dbf", ":call db_ui#find_buffer()<CR>", {})
		end,
	},
	"kristijanhusak/vim-dadbod-completion",
}
