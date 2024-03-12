local job = require("plenary.job")
local on_exit = require("formatting.utils.format_exit")

return function()
	return {
		job:new({
			command = "sqlfmt",
			args = { vim.api.nvim_buf_get_name(0) },
			on_exit = on_exit,
		}),
	}
end
