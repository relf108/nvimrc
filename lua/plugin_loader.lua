local M = {}
local configured = {}

function M.load(name, setup)
	if configured[name] then
		return
	end

	local ok, err = pcall(vim.cmd.packadd, name)
	if not ok then
		local plug_dir =
			vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt", name)
		local msg = ("plugin_loader: packadd(%q) failed: %s\nCheck %s; if empty, delete it and restart (vim.pack reinstalls from nvim-pack-lock.json), or run :lua vim.pack.update({ %q }, { target = 'lockfile' })"):format(
			name,
			err,
			plug_dir,
			name
		)
		vim.notify(msg, vim.log.levels.ERROR)
		error(msg)
	end
	if setup then
		local sok, serr = pcall(setup)
		if not sok then
			local msg = ("plugin_loader: setup for %q failed: %s"):format(name, serr)
			vim.notify(msg, vim.log.levels.ERROR)
			error(msg)
		end
	end
	configured[name] = true
end

return M
