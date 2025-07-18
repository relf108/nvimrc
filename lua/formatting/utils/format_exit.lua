return function(_, return_val)
	vim.schedule(function()
		vim.api.nvim_set_option_value("readonly", false, { buf = vim.g.get_buf_by_name(vim.g.formatting_buf_name) })
	end)
	if return_val == 0 then
		vim.schedule(function()
			vim.notify("Exit code: 0", vim.log.levels.INFO, {
				title = "Formatted " .. vim.api.nvim_get_option_value(
					"filetype",
					{ buf = vim.g.get_buf_by_name(vim.g.formatting_buf_name) }
				) .. " file.",
			})
			vim.cmd(":drop " .. vim.g.formatting_buf_name)
		end)
	else
		vim.schedule(function()
			vim.notify("Exit code: " .. return_val, vim.log.levels.WARN, {
				title = "Formatter override failed, using LSP formatter.",
			})
			vim.cmd(":drop " .. vim.g.formatting_buf_name)
			vim.lsp.buf.format({ async = true })
		end)
	end
end
