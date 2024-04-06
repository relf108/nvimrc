return function(_, return_val)
	if return_val == 0 then
		vim.schedule(function()
			vim.notify("Exit code: 0", vim.log.levels.INFO, {
				title = "Formatter override successful.",
			})
			vim.cmd(":e!")
		end)
	else
		vim.schedule(function()
			vim.notify("Exit code: " .. return_val, vim.log.levels.WARN, {
				title = "Formatter override failed, using LSP formatter.",
			})
			vim.lsp.buf.format({ async = true })
		end)
	end
end
