local loader = require("plugin_loader")

vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
}, { confirm = false, load = function() end })

local load_dap = loader.lazy_commands({
	DapSetLogLevel = { nargs = 1 },
	DapShowLog = { nargs = 0 },
	DapContinue = { nargs = 0 },
	DapToggleBreakpoint = { nargs = 0 },
	DapClearBreakpoints = { nargs = 0 },
	DapToggleRepl = { nargs = 0 },
	DapStepOver = { nargs = 0 },
	DapStepInto = { nargs = 0 },
	DapStepOut = { nargs = 0 },
	DapPause = { nargs = 0 },
	DapTerminate = { nargs = 0 },
	DapDisconnect = { nargs = 0 },
	DapRestartFrame = { nargs = 0 },
	DapNew = { nargs = "*" },
	DapEval = { nargs = 0, bang = true, range = "%", bar = true },
}, function()
	loader.load("nvim-dap", function()
		local dap = require("dap")
		dap.adapters.dart = require("dap.dart")
		dap.adapters.python = require("dap.python")
		dap.adapters.lua = require("dap.lua")
	end)
end)

local function load_ui()
	load_dap()
	loader.load("nvim-dap-ui", function()
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
				{
					elements = {
						{ id = "console", size = 0.5 },
						{ id = "watches", size = 0.25 },
						{ id = "scopes", size = 0.25 },
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
	end)
end

local function dap_map(lhs, method, desc)
	vim.keymap.set("n", lhs, function()
		load_ui()
		require("dap")[method]()
	end, { desc = desc })
end

dap_map("<F5>", "continue", "DAP Continue")
dap_map("<F9>", "terminate", "DAP Terminate")
dap_map("<F10>", "step_over", "DAP Step Over")
dap_map("<F11>", "step_into", "DAP Step Into")
dap_map("<F12>", "step_out", "DAP Step Out")
dap_map("<leader>b", "toggle_breakpoint", "Toggle Breakpoint")
dap_map("<leader>B", "set_breakpoint", "Set Breakpoint")
dap_map("<leader>dl", "run_last", "DAP Run Last")

vim.keymap.set("n", "<leader>dr", function()
	load_ui()
	require("dap").repl.open()
end, { desc = "DAP REPL" })

vim.keymap.set("n", "<leader>lp", function()
	load_ui()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Log Point" })

vim.keymap.set({ "n", "v" }, "<leader>dh", function()
	load_ui()
	require("dap.ui.widgets").hover()
end, { desc = "DAP Hover" })

vim.keymap.set({ "n", "v" }, "<leader>dp", function()
	load_ui()
	require("dap.ui.widgets").preview()
end, { desc = "DAP Preview" })

vim.keymap.set("n", "<leader>df", function()
	load_ui()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { desc = "DAP Frames" })

vim.keymap.set("n", "<leader>ds", function()
	load_ui()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "DAP Scopes" })

vim.keymap.set("n", "<leader>du", function()
	load_ui()
	require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

vim.keymap.set("n", "<leader>vs", function()
	vim.cmd.drop(".vscode/launch.json")
end, { desc = "Open launch.json" })
