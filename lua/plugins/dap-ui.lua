return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup({
				controls = {
					element = "repl",
					enabled = true,
					icons = {
						disconnect = "",
						pause = "",
						play = "",
						run_last = "",
						step_back = "",
						step_into = "",
						step_out = "",
						step_over = "",
						terminate = "",
					},
				},
				element_mappings = {},
				expand_lines = true,
				floating = {
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				force_buffers = true,
				icons = {
					collapsed = "",
					current_frame = "",
					expanded = "",
				},
				layouts = {
					-- {
					-- 	elements = {
					-- 		{
					-- 			id = "breakpoints",
					-- 			size = 0.15,
					-- 		},
					-- 		{
					-- 			id = "watches",
					-- 			size = 0.15,
					-- 		},
					-- 		{
					-- 			id = "stacks",
					-- 			size = 0.15,
					-- 		},
					-- 		{
					-- 			id = "scopes",
					-- 			size = 0.55,
					-- 		},
					-- 	},
					-- 	position = "left",
					-- 	size = 60,
					-- },
					{
						elements = {
							{
								id = "console",
								size = 0.6,
							},
							{
								id = "repl",
								size = 0.4,
							},
						},
						position = "left",
						size = 80,
					},
				},
				mappings = {
					edit = "e",
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					repl = "r",
					toggle = "t",
				},
				render = {
					indent = 1,
					max_value_lines = 100,
				},
			})
			require("dap").listeners.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end
			vim.api.nvim_set_keymap(
				"n",
				"<leader>du",
				':lua require("dapui").toggle()<CR>',
				{ noremap = true, silent = true }
			)
		end,
	},
}
