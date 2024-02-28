local async = require("plenary.async")

local sql = function()
	local fileName = vim.api.nvim_buf_get_name(0)
	vim.cmd(":silent !sqlfmt " .. fileName)
end

-- Add any other formatter overrides here
-- The key should be the filetype and the value should be the function to run

local format_overrides = {
	sql = sql,
	plsql = sql,
	mysql = sql,
}

vim.g.format = function()
	if (format_overrides[vim.bo.filetype] or nil) ~= nil then
		async.run(format_overrides[vim.bo.filetype])
	else
		vim.lsp.buf.format({ async = true })
	end
end
