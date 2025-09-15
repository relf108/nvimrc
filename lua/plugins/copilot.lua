return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			sticky = {
				"@copilot",
				"#buffers:visible",
				"#files:full",
				"#gitdiff:staged",
				"#gitstatus",
				"#selection",
				"$claude-sonnet-4",
			},
			temperature = 0.1, -- Lower = focused, higher = creative
			window = {
				layout = "horizontal",
				width = 0.8,
				height = 0.3,
				row = nil,
				col = nil,
				relative = "editor",
				border = "rounded",
				zindex = 100,
			},
			auto_insert_mode = false, -- Enter insert mode when opening
			headers = {
				user = "👤 You",
				assistant = "🤖 Copilot",
				tool = "🔧 Tool",
			},
			separator = "━━",
			auto_fold = true, -- Automatically folds non-assistant messages
		},
		keys = {
			{ "<leader>ch", "<cmd>CopilotChat<cr>", mode = { "n", "v" }, desc = "Run CopilotChat Tests" },
			{ "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = "v", desc = "Run CopilotChat Tests" },
		},
	},
}
