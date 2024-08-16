local dap_adapters = {
	dart = require("dap.dart"),
	python = require("dap.python"),
}
return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			-- Dap configs
			for lang, adapter in pairs(dap_adapters) do
				require("dap").adapters[lang] = adapter
			end

			vim.keymap.set("n", "<F5>", function()
				require("functions.dap-continue-with-validation")()
			end)
			vim.keymap.set("n", "<F10>", function()
				require("dap").step_over()
			end)
			vim.keymap.set("n", "<F11>", function()
				require("dap").step_into()
			end)
			vim.keymap.set("n", "<F12>", function()
				require("dap").step_out()
			end)
			vim.keymap.set("n", "<F9>", function()
				require("dap").terminate()
			end)
			vim.keymap.set("n", "<Leader>b", function()
				require("dap").toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>B", function()
				require("dap").set_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>lp", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.open()
			end)
			vim.keymap.set("n", "<Leader>dl", function()
				require("dap").run_last()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end)
			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end)
			vim.keymap.set("n", "<Leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end)

			vim.keymap.set("n", "<leader>tf", function()
				require("neotest").run.run()
			end)

			vim.keymap.set("n", "<leader>vs", function()
				vim.cmd(":drop .vscode/launch.json")
			end)
		end,
	},
}
