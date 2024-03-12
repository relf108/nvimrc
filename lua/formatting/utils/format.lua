local sql = require("formatting.sql")
local lua = require("formatting.lua")
local md = require("formatting.md")

local format_overrides = {
	sql = sql,
	plsql = sql,
	mysql = sql,
	lua = lua,
	md = md,
  markdown = md,
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
