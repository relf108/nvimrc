local sql = require("formatting.sql")
local lua = require("formatting.lua")
local markdown = require("formatting.markdown")
local python = require("formatting.python")

local format_overrides = {
	sql = sql,
	plsql = sql,
	mysql = sql,
	lua = lua,
	md = markdown,
	markdown = markdown,
	py = python,
	python = python,
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
