return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				default_config = {
					keymaps = {
						visual = {
							["<leader>mc"] = "<cmd>lua require('mason').compare()<CR>",
							["<leader>ms"] = "<cmd>lua require('mason').swap()<CR>",
							["<leader>mu"] = "<cmd>lua require('mason').update()<CR>",
							["<leader>mr"] = "<cmd>lua require('mason').remove()<CR>",
						},
						n = {
							["<leader>mc"] = "<cmd>lua require('mason').compare()<CR>",
							["<leader>ms"] = "<cmd>lua require('mason').swap()<CR>",
							["<leader>mu"] = "<cmd>lua require('mason').update()<CR>",
							["<leader>mr"] = "<cmd>lua require('mason').remove()<CR>",
						},
					},
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<space>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<space>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"jsonls",
					"lua_ls",
					"ruff_lsp",
					"pyright",
					"yamlls",
					"typos_lsp",
					"marksman",
					"bashls",
				},
			})
			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function(server_name) -- handler for lua_ls
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["pyright"] = function() -- handler for pyright
					require("lspconfig")["pyright"].setup({
						capabilities = capabilities,
						settings = {
							python = {
								analysis = {
									diagnosticMode = "workspace",
								},
							},
						},
					})
				end,
				["ruff_lsp"] = function(server_name) -- handler for ruff_lsp
					local ruff_conf = vim.fn.expand("~/.config/ruff/ruff.toml")
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = function(client)
							client.server_capabilities.hoverProvider = false
						end,
						init_options = {
							settings = {
								-- Any extra CLI arguments for `ruff` go here.
								args = {
									"--config=" .. ruff_conf,
								},
							},
						},
					})
				end,
			})
		end,
	},

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
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mfussenegger/nvim-dap", "kmontocam/nvim-conda" },
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "stylua", "debugpy" },
				handlers = {
					function(config)
						-- all sources with no handler get passed here

						-- Keep original functionality
						require("mason-nvim-dap").default_setup(config)
					end,
					python = function(config)
						config.adapters = {
							type = "executable",
							command = os.getenv("CONDA_PREFIX") .. "/bin/python",
							args = {
								"-m",
								"debugpy.adapter",
							},
						}
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
}
