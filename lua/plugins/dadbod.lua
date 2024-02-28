return {
	"kristijanhusak/vim-dadbod-ui",

	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.api.nvim_set_keymap("n", "<Leader>dbt", "<cmd>DBUIToggle<CR>", {})
		vim.api.nvim_set_keymap("n", "<Leader>dbf", "<cmd>DBUIFindBuffer<CR>", {})
	end,
}
