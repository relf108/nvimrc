local M = {}
local configured = {}

function M.load(name, setup)
	if configured[name] then
		return
	end

	vim.cmd.packadd(name)
	if setup then
		setup()
	end
	configured[name] = true
end

return M
