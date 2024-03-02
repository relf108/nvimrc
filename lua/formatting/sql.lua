local job = require("plenary.job")

return function()
	return job:new({
		command = "sqlfmt",
		args = { vim.g.formattingFileName },
		on_exit = vim.g.format_exit,
	})
end
