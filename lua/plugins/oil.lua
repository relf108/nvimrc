return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
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
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Oil",
		config = function(_, opts)
			require("oil").setup(opts)
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilEnter",
				callback = vim.schedule_wrap(function(args)
					local oil = require("oil")
					if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_current_dir() then
						oil.open_preview(opts["preview"])
					end
				end),
			})
		end,
	},
}
