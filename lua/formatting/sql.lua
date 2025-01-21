local job = require("plenary.job")
local on_exit = require("formatting.utils.format_exit")

local added_ext = false

local function on_exit_override(_, return_val)
	if added_ext then
		local oldname = vim.g.formatting_buf_name:gsub("%.sql", "")
		os.rename(vim.g.formatting_buf_name, oldname)
		vim.g.formatting_buf_name = oldname
		added_ext = false
	end
	on_exit(_, return_val)
end

return function()
	if
		not string.match(vim.g.formatting_buf_name, "%.sql")
		and not string.match(vim.g.formatting_buf_name, "%.plsql")
		and not string.match(vim.g.formatting_buf_name, "%.mysql")
	then
		local newname = vim.g.formatting_buf_name .. ".sql"
		os.execute("cp " .. vim.g.formatting_buf_name .. " " .. newname)
		vim.g.formatting_buf_name = newname
		added_ext = true
	end

	local args = { "fix", vim.g.formatting_buf_name, "--dialect", "postgres", "-q" }
	if vim.g.file_exists("./pyproject.toml") then
		table.insert(args, "--config")
		table.insert(args, "./pyproject.toml")
	end

	return {
		job:new({
			command = "sqlfluff",
			args = args,
			on_exit = on_exit_override,
		}),
	}
end
