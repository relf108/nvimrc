local M = {}

-- Get buffer by name with error handling
function M.get_buf_by_name(name)
	if not name or name == "" then
		return 0
	end

	local success, bufs = pcall(vim.api.nvim_list_bufs)
	if not success then
		return 0
	end

	for _, buf in ipairs(bufs) do
		local success_name, buf_name = pcall(vim.api.nvim_buf_get_name, buf)
		if success_name and buf_name == name then
			return buf
		end
	end
	return 0
end

-- Get Python path with error handling
function M.python_path()
	local conda = os.getenv("CONDA_PREFIX")
	if conda then
		local python_path = conda .. "/bin/python"
		if M.file_exists(python_path) then
			return python_path
		end
	end

	local system_python = vim.fn.exepath("python")
	if system_python and system_python ~= "" then
		return system_python
	end

	-- Fallback
	return "python"
end

-- Check if file exists with error handling
function M.file_exists(file)
	if not file or file == "" then
		return false
	end

	local success, f = pcall(io.open, file, "rb")
	if success and f then
		f:close()
		return true
	end
	return false
end

-- Command repeat utility function
function M.cmd_repeat(cmdstr)
	if not cmdstr or cmdstr == "" then
		vim.notify("No command provided to cmd-repeat", vim.log.levels.WARN)
		return
	end

	for i = 1, vim.v.count1 do
		local success = pcall(vim.cmd, cmdstr)
		if not success then
			vim.notify("Failed to execute command: " .. cmdstr, vim.log.levels.ERROR)
			break
		end
	end
end

-- DAP continue with validation function
function M.dap_continue_with_validation()
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

return M
