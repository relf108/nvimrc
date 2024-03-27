local job = require("plenary.job")
local on_exit = require("formatting.utils.format_exit")

return function()
	return {
		job:new({
			command = "sqlfluff",
			args = { "format", "-d", "postgres", "-p", "0", vim.api.nvim_buf_get_name(0) },
			on_exit = on_exit,
		}),
	}
end
