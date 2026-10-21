local M = {}
local cached

local function valid(entry, identity)
	return type(entry) == "table"
		and vim.deep_equal(entry.identity, identity)
		and type(entry.output) == "string"
		and type(entry.version) == "table"
		and #entry.version == 3
		and vim.iter(entry.version):all(function(number)
			return type(number) == "number" and number >= 0 and number % 1 == 0
		end)
end

local function read(path)
	local file = io.open(path, "r")
	if not file then
		return
	end
	local contents = file:read("*a")
	file:close()
	local ok, entry = pcall(vim.json.decode, contents)
	if ok then
		return entry
	end
end

local function save(path, entry)
	vim.schedule(function()
		local directory = vim.fn.fnamemodify(path, ":h")
		if vim.fn.isdirectory(directory) == 0 then
			local ok = pcall(vim.fn.mkdir, directory, "p")
			if not ok then
				return
			end
		end
		local temporary = path .. "." .. vim.fn.getpid() .. ".tmp"
		local file = io.open(temporary, "w")
		if not file then
			return
		end
		local written = file:write(vim.json.encode(entry))
		local closed = file:close()
		if not written or not closed or not vim.uv.fs_rename(temporary, path) then
			os.remove(temporary)
		end
	end)
end

local function probe(original, opts)
	local executable = vim.fn.exepath(opts and opts.fzf_bin or "fzf")
	local binary = executable ~= "" and vim.uv.fs_realpath(executable) or nil
	local stat = binary and vim.uv.fs_stat(binary)
	if not stat then
		return original(opts)
	end
	local identity = { path = binary, size = stat.size, mtime = stat.mtime, ctime = stat.ctime }
	local path = vim.fn.stdpath("cache") .. "/fzf-version.json"
	if not valid(cached, identity) then
		cached = read(path)
	end
	if valid(cached, identity) then
		return vim.deepcopy(cached.version), 0, cached.output
	end
	local version, code, output = original(opts)
	local entry = { identity = identity, version = version, output = output }
	if code == 0 and valid(entry, identity) then
		cached = vim.deepcopy(entry)
		save(path, cached)
	end
	return version, code, output
end

-- Scope the adapter to a normal provider call. File discovery, formatting,
-- streaming, actions, and resume remain entirely owned by fzf-lua.
function M.call(callback, ...)
	local utils = require("fzf-lua.utils")
	local original = utils.fzf_version
	utils.fzf_version = function(opts)
		return probe(original, opts)
	end
	local function pack(...)
		return { n = select("#", ...), ... }
	end
	local results = pack(pcall(callback, ...))
	utils.fzf_version = original
	if not results[1] then
		error(results[2], 0)
	end
	return unpack(results, 2, results.n)
end

return M
