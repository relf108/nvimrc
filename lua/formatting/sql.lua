local job = require("plenary.job")
local on_exit = require("formatting.utils.format_exit")

return function()
	local args = { "fix", vim.g.formatting_buf_name, "--dialect", "postgres" }
	if vim.g.file_exists("./pyproject.toml") then
		table.insert(args, "--config")
		table.insert(args, "./pyproject.toml")
	end

	return {
		job:new({
			command = "sqlfluff",
			args = args,
			on_exit = on_exit,
		}),
	}
end
