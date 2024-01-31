return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local function pytest_env()
				if not vim.g.file_exists(".vscode/launch.json") then
					return {}
				end
				local file = io.open(".vscode/launch.json", "r")
				local configs = require("json"):decode(file:read("*all"))["configurations"]
				for _, config in pairs(configs) do
					if config["module"] == "pytest" then
						return config["env"]
					end
				end
			end

			dap.adapters.dart = {
				type = "executable",
				command = "dart",
				args = { "debug_adapter" },
			}
			dap.configurations.dart = {
				{
					type = "dart",
					request = "launch",
					name = "Launch Dart Program",
					program = "${file}",
					cwd = "${workspaceFolder}",
					args = { "--help" },
				},
			}
			dap.adapters.dart = {
				type = "executable",
				command = "flutter",
				args = { "debug_adapter" },
			}
			dap.configurations.dart = {
				{
					type = "dart",
					request = "launch",
					name = "Launch Flutter Program",
					program = "${file}",
					cwd = "${workspaceFolder}",
					toolArgs = { "-d", "ios" },
				},
			}
			vim.keymap.set("n", "<F5>", function()
				require("dap").continue()
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
				require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap", env = pytest_env() })
			end)
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			-- Point Python dap adapter to conda
			require("dap-python").setup(os.getenv("CONDA_PREFIX") .. "/bin/python")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
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
					{
						elements = {
							{
								id = "breakpoints",
								size = 0.15,
							},
							{
								id = "watches",
								size = 0.15,
							},
							{
								id = "stacks",
								size = 0.15,
							},
							{
								id = "scopes",
								size = 0.55,
							},
						},
						position = "left",
						size = 60,
					},
					{
						elements = {
							{
								id = "repl",
								size = 0.5,
							},
							{
								id = "console",
								size = 0.5,
							},
						},
						position = "bottom",
						size = 20,
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
