local job = require("plenary.job")
local on_exit = require("formatting.utils.format_exit")

return function()
	return {
		job:new({
			command = "sqlfluff",
			args = { "fix", vim.g.formatting_buf_name, "--dialect", "postgres" },
			on_exit = on_exit,
		}),
	}
end
