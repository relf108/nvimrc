return function(_, return_val)
	if return_val == 0 then
		vim.schedule(function()
			vim.notify("Formatter overridden: Exit code " .. return_val, vim.log.levels.INFO)
			vim.cmd(":e!")
		end)
	else
		vim.schedule(function()
			vim.notify("Formatter overridden: Non-zero exit code, using LSP", vim.log.levels.WARN)
			vim.lsp.buf.format({ async = true })
		end)
	end
end
