local load_launchjs = require("functions.load-launch-json")
return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "bash", "dart", "codelldb" },
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = { "python" },
		config = function()
			require("dap-python").setup(vim.g.python_path())
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			local function pytest_conf()
				if not vim.g.file_exists(".vscode/launch.json") then
					return {}
				end

				local file = io.open(".vscode/launch.json", "r")
				if not file then
					return {}
				end

				local configs = require("json"):decode(file:read("*all"))["configurations"]
				for _, config in pairs(configs) do
					if config["module"] == "pytest" then
						return config
					end
				end
			end

			vim.keymap.set("n", "<F5>", function()
        load_launchjs()
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
				local config = pytest_conf()
				require("neotest").run.run({
					strategy = "dap",
					env = config["env"],
					args = config["args"],
				})
			end)
		end,
	},
}
