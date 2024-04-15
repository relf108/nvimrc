local sql = require("formatting.sql")
local lua = require("formatting.lua")
local markdown = require("formatting.markdown")
local python = require("formatting.python")

vim.g.formatting_buf_name = ""

local format_overrides = {
	sql = sql,
	plsql = sql,
	mysql = sql,
	lua = lua,
	md = markdown,
	markdown = markdown,
}

return function()
	vim.g.formatting_buf_name = vim.api.nvim_buf_get_name(0)
	local filetype = vim.bo.filetype

	if string.find(vim.g.formatting_buf_name, vim.g.work_dir) then
		format_overrides["python"] = python
		format_overrides["py"] = python
	end

	if (format_overrides[filetype] or nil) ~= nil then
		vim.cmd("silent! w!")
		local jobs = format_overrides[filetype]()
		for _, job in ipairs(jobs) do
			vim.api.nvim_buf_set_option(vim.g.get_buf_by_name(vim.g.formatting_buf_name), "readonly", true)
			vim.notify("Buffer temporarily set to readonly.", vim.log.levels.WARN, {
				title = "Formatting " .. filetype .. "...",
			})
			job:start()
		end
	else
		vim.lsp.buf.format({ async = true })
	end
end
