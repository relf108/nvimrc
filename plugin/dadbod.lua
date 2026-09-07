local loader = require("plugin_loader")

vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
}, { confirm = false, load = function() end })

local load_dadbod = loader.lazy_commands({
	DB = { nargs = "?", bang = true, range = -1 },
}, function()
	loader.load("vim-dadbod")
end)

local load_completion = loader.lazy_commands({
	DBCompletionClearCache = { nargs = 0 },
}, function()
	load_dadbod()
	loader.load("vim-dadbod-completion")
end)

local load_ui = loader.lazy_commands({
	DBUI = { nargs = 0 },
	DBUIToggle = { nargs = 0 },
	DBUIClose = { nargs = 0 },
	DBUIAddConnection = { nargs = 0 },
	DBUIFindBuffer = { nargs = 0 },
	DBUIRenameBuffer = { nargs = 0 },
	DBUILastQueryInfo = { nargs = 0 },
}, function()
	vim.g.db_ui_use_nerd_fonts = 1
	vim.g.db_ui_auto_execute_table_helpers = 1
	load_dadbod()
	loader.load("vim-dadbod-ui")
end)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	once = true,
	callback = function()
		load_dadbod()
		load_completion()
	end,
})

vim.keymap.set("n", "<leader>dbt", function()
	load_ui()
	vim.cmd.DBUIToggle()
end, { desc = "Toggle DB UI" })

vim.keymap.set("n", "<leader>dbf", function()
	load_ui()
	vim.cmd.DBUIFindBuffer()
end, { desc = "Find DB UI buffer" })
