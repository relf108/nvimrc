local noice = require("noice")

-- Add any other formatter overrides here
-- The key should be the filetype and the value should be the function to run
-- Don't forget to require the file below

local sql = require("formatting.sql")

local format_overrides = {
	sql = sql,
	plsql = sql,
	mysql = sql,
}

vim.g.formattingFileName = ""

vim.g.format_exit = function(j, return_val)
	if return_val == 0 then
		vim.schedule(function()
			noice.notify("Formatted " .. vim.g.formattingFileName, "success")
			vim.cmd(":e!")
		end)
	else
		vim.schedule(function()
			noice.notify(table.concat(j:stderr_result(), "\n"), "error")
		end)
	end
end

vim.g.format = function()
	local fileType = vim.bo.filetype
	if (format_overrides[fileType] or nil) ~= nil then
		vim.g.formattingFileName = vim.api.nvim_buf_get_name(0)
		format_overrides[fileType]():start()
	else
		vim.lsp.buf.format({ async = true })
	end
end
