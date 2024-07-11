return function()
	if not vim.fn.filereadable(".vscode/launch.json") then
		return
	end

	local ok, err = pcall(
		require("dap.ext.vscode").load_launchjs,
		nil,
		{ codelldb = { "rust" }, lldb = { "rust" }, delve = { "go" } }
	)

	if ok then
		require("dap").configurations = {}
		return require("dap").continue()
	end

	if err then
		local charnum = ""
		err = err:gsub(".", function(c)
			if not (c == "" or c:find("%D")) then
				charnum = charnum .. c
			else
				charnum = ""
			end
		end)
		vim.cmd(":drop .vscode/launch.json")
		vim.cmd(":goto " .. charnum)
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		vim.schedule(function()
			vim.notify("Error at position: " .. row .. ", " .. col, vim.log.levels.WARN, {
				title = "Failed to load launch.json",
			})
		end)
	end
end
