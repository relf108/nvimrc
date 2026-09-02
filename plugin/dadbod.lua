local loader = require("plugin_loader")

vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
}, { confirm = false, load = function() end })

local function load_dadbod()
	loader.load("vim-dadbod")
end

local function load_ui()
	vim.g.db_ui_use_nerd_fonts = 1
	vim.g.db_ui_auto_execute_table_helpers = 1
	load_dadbod()
	loader.load("vim-dadbod-ui")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	once = true,
	callback = function()
		load_dadbod()
		loader.load("vim-dadbod-completion")
	end,
})

vim.api.nvim_create_autocmd("CmdUndefined", {
	pattern = "DBUI*",
	once = true,
	callback = load_ui,
})

vim.keymap.set("n", "<leader>dbt", function()
	load_ui()
	vim.cmd.DBUIToggle()
end, { desc = "Toggle DB UI" })

vim.keymap.set("n", "<leader>dbf", function()
	load_ui()
	vim.cmd.DBUIFindBuffer()
end, { desc = "Find DB UI buffer" })
