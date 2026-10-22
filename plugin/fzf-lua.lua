if vim.g.config_fzf_loaded then
	return
end
vim.g.config_fzf_loaded = true

local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, { confirm = false, load = function() end })

local load = loader.lazy(function()
	loader.load("fzf-lua", function()
		local opts = {}
		-- Fall back to the worker if an update removes the local scheduler patch.
		if require("fzf-lua.libuv").cooperative_streaming then
			opts.files = { multiprocess = false }
		end
		require("fzf-lua").setup(opts)
	end)
end)

vim.keymap.set("n", "<leader>ff", function()
	load()
	require("fzf_version_cache").call(require("fzf-lua").files)
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
	load()
	require("fzf_version_cache").call(require("fzf-lua").live_grep)
end, { desc = "Live grep" })

if vim.fn.argc(-1) == 0 then
	if vim.g.startup_picker_early then
		require("startup_picker").open(load)
	else
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				require("startup_picker").open(load)
			end,
		})
	end
end
