local dap_adapters = {
	dart = require("dap.dart"),
	python = require("dap.python"),
}
return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<F5>",
				function()
					require("utils").dap_continue_with_validation()
				end,
				desc = "DAP Continue",
			},
			{
				"<F9>",
				function()
					require("dap").terminate()
				end,
				desc = "DAP Terminate",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "DAP Step Over",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "DAP Step Into",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "DAP Step Out",
			},
			{
				"<Leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<Leader>B",
				function()
					require("dap").set_breakpoint()
				end,
				desc = "Set Breakpoint",
			},
			{
				"<Leader>lp",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "Log Point",
			},
			{
				"<Leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "DAP REPL",
			},
			{
				"<Leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "DAP Run Last",
			},
			{
				"<Leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "DAP Hover",
				mode = { "n", "v" },
			},
			{
				"<Leader>dp",
				function()
					require("dap.ui.widgets").preview()
				end,
				desc = "DAP Preview",
				mode = { "n", "v" },
			},
			{
				"<Leader>df",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.frames)
				end,
				desc = "DAP Frames",
			},
			{
				"<Leader>ds",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes)
				end,
				desc = "DAP Scopes",
			},
			{
				"<leader>vs",
				function()
					vim.cmd(":drop .vscode/launch.json")
				end,
				desc = "Open launch.json",
			},
			{
				"<leader>r",
				function()
					vim.cmd(":drop requests")
				end,
				desc = "Open requests",
			},
		},
		config = function()
			-- Dap configs
			for lang, adapter in pairs(dap_adapters) do
				require("dap").adapters[lang] = adapter
			end
		end,
	},
}
