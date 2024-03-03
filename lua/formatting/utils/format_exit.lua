return function(_, return_val)
	vim.notify("Formatter overridden", vim.log.levels.INFO)
	if return_val == 0 then
		vim.schedule(function()
			vim.notify("Formatted with exit code " .. return_val, vim.log.levels.INFO)
			vim.cmd(":e!")
		end)
	else
		vim.schedule(function()
			vim.notify("Formatted with non-zero exit code, using LSP", vim.log.levels.WARN)
			vim.lsp.buf.format({ async = true })
		end)
	end
end
