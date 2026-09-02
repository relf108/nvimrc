local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/stevearc/oil.nvim" }, { confirm = false, load = function() end })

local opts = {
	preview = {
		split = "belowright",
		vertical = true,
	},
	preview_win = {
		update_on_cursor_moved = true,
	},
	keymaps = {
		["<C-t>"] = false,
		["<C-v>"] = {
			"actions.select",
			opts = { vertical = true },
			desc = "Open the entry in a vertical split",
		},
	},
}

local function load()
	loader.load("oil.nvim", function()
		require("oil").setup(opts)
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilEnter",
			callback = vim.schedule_wrap(function(args)
				local oil = require("oil")
				if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_current_dir() then
					oil.open_preview(opts.preview)
				end
			end),
		})
	end)
end

vim.api.nvim_create_autocmd("CmdUndefined", {
	pattern = "Oil",
	once = true,
	callback = load,
})

vim.keymap.set("n", "<leader>r", function()
	load()
	vim.cmd("Oil requests")
end, { desc = "Open requests" })
