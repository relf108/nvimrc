local lsp = require("lsp")
local utils = require("utils")

-- Ruff
local ruff_conf = vim.fn.expand("~/.config/ruff/ruff.toml")

lsp.enable("ruff", {
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
	init_options = {
		settings = {
			args = {
				"--config=" .. ruff_conf,
			},
		},
	},
})

-- Pyright
lsp.enable("pyright", {
	settings = {
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			pythonPath = utils.python_path(),
			analysis = {
				ignore = { "*" },
			},
		},
	},
})
