return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
		},
		opts = {},
		config = function()
			require("fzf-lua").setup({})
			if vim.bo.filetype ~= "" then
				return
			end
			require("fzf-lua").files({
				winopts = {
					fullscreen = true,
					on_create = function(args)
						vim.keymap.set("t", "<Esc>", function()
							require("fzf-lua").hide()
							vim.cmd("silent! qa!")
						end, { buffer = args.bufnr, nowait = true })
					end,
				},
			})
		end,
	},
}
