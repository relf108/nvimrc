local M = {}
local configured = {}

function M.load(name, setup)
	if configured[name] then
		return
	end

	local ok, err = pcall(vim.cmd.packadd, name)
	if not ok then
		local plug_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt", name)
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

function M.lazy_commands(commands, load)
	local loaded = false

	local function ensure_loaded()
		if loaded then
			return
		end

		for command in pairs(commands) do
			pcall(vim.api.nvim_del_user_command, command)
		end
		load()
		loaded = true
	end

	local function create_proxy(command, opts)
		vim.api.nvim_create_user_command(command, function(ctx)
			ensure_loaded()
			vim.api.nvim_cmd({
				cmd = command,
				args = ctx.fargs,
				bang = opts.bang and ctx.bang or nil,
				count = opts.count and ctx.count or nil,
				mods = ctx.smods,
				range = opts.range and ctx.range > 0 and { ctx.line1, ctx.line2 } or nil,
				reg = opts.register and ctx.reg or nil,
			}, {})
		end, opts)
	end

	for command, opts in pairs(commands) do
		create_proxy(command, opts)
	end

	return ensure_loaded
end

return M
