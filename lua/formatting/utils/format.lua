local sql = require("formatting.sql")
local lua = require("formatting.lua")

local format_overrides = {
	sql = sql,
	plsql = sql,
	mysql = sql,
	lua = lua,
}

return function()
	local filetype = vim.bo.filetype
	if (format_overrides[filetype] or nil) ~= nil then
		vim.cmd("w!")
		format_overrides[filetype]():start()
	else
		vim.lsp.buf.format({ async = true })
	end
end